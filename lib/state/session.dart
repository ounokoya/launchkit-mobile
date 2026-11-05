// Who is signed in, in which organization, in which language (ADR-0014). The token lives in the system's secure
// storage; everything else is read again from the API (GET /me) when the app starts.
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config.dart';
import '../data/api.dart';
import '../data/models.dart';

abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String? value);
}

/// Keystore on Android, Keychain on iOS.
class SecureSecretStore implements SecretStore {
  const SecureSecretStore();
  static const _storage = FlutterSecureStorage();
  @override
  Future<String?> read(String key) => _storage.read(key: key);
  @override
  Future<void> write(String key, String? value) =>
      value == null ? _storage.delete(key: key) : _storage.write(key: key, value: value);
}

/// For the tests (and the Linux test target, which has no keyring).
class MemorySecretStore implements SecretStore {
  MemorySecretStore([Map<String, String>? values]) : values = values ?? {};
  final Map<String, String> values;
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String? value) async => value == null ? values.remove(key) : values[key] = value;
}

const _tokenKey = 'session_token', _orgKey = 'current_org', _localeKey = 'locale', _nextKey = 'next_link';

final secretStoreProvider = Provider<SecretStore>((ref) => const SecureSecretStore());

final apiProvider = Provider<LaunchKitApi>(
  (ref) => DioLaunchKitApi(
    baseUrl: Config.apiUrl,
    token: () => ref.read(sessionProvider).token,
    locale: () => ref.read(localeProvider),
    onUnauthorized: () => ref.read(sessionProvider.notifier).expire(),
  ),
);

class SessionState {
  const SessionState({
    this.ready = false,
    this.token,
    this.user,
    this.organizations = const [],
    this.orgId,
    this.expired = false,
    this.unavailable = false,
  });

  /// False until the stored session has been checked (splash).
  final bool ready;
  final String? token;
  final User? user;
  final List<MyOrganization> organizations;
  final String? orgId;

  /// The API refused the session: the sign-in screen says why (M01b).
  final bool expired;

  /// The API could not be reached while restoring the session (M12c, « Réessayer »).
  final bool unavailable;

  bool get signedIn => token != null && user != null;
  MyOrganization? get org => organizations.where((o) => o.id == orgId).firstOrNull;

  SessionState copyWith({String? orgId, List<MyOrganization>? organizations, User? user}) => SessionState(
    ready: ready,
    token: token,
    user: user ?? this.user,
    organizations: organizations ?? this.organizations,
    orgId: orgId ?? this.orgId,
  );
}

class SessionController extends Notifier<SessionState> {
  SecretStore get _store => ref.read(secretStoreProvider);
  LaunchKitApi get _api => ref.read(apiProvider);

  @override
  SessionState build() {
    Future.microtask(restore);
    return const SessionState();
  }

  /// Reads the stored token and checks it with GET /me.
  Future<void> restore() async {
    final token = await _store.read(_tokenKey);
    if (token == null) {
      state = const SessionState(ready: true);
      return;
    }
    state = SessionState(token: token);
    try {
      await _load(token, await _store.read(_orgKey));
    } on ApiError catch (e) {
      if (e.status == 401) return; // expire() already ran
      state = SessionState(ready: true, token: token, unavailable: true);
    }
  }

  Future<void> _load(String token, String? preferredOrg) async {
    final me = await _api.me();
    final orgs = me.organizations;
    final orgId = orgs.any((o) => o.id == preferredOrg) ? preferredOrg : (orgs.length == 1 ? orgs.first.id : null);
    state = SessionState(ready: true, token: token, user: me.user, organizations: orgs, orgId: orgId);
    await ref.read(localeProvider.notifier).accountLocale(me.user.locale);
  }

  Future<void> signIn(Session session) async {
    await _store.write(_tokenKey, session.token);
    state = SessionState(token: session.token, user: session.user);
    await _load(session.token, await _store.read(_orgKey));
  }

  /// Reloads the organizations (after creating one, joining one or upgrading), optionally switching to [select].
  Future<void> refresh({String? select}) async {
    final token = state.token;
    if (token == null) return;
    if (select != null) await _store.write(_orgKey, select);
    await _load(token, select ?? state.orgId);
  }

  Future<void> selectOrg(String id) async {
    await _store.write(_orgKey, id);
    state = state.copyWith(orgId: id);
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } on ApiError {
      // The session is forgotten on the device anyway.
    }
    await _clear();
    state = const SessionState(ready: true);
  }

  /// The API answered 401: forget the token and send the person back to sign-in (M01b).
  Future<void> expire() async {
    await _clear();
    state = const SessionState(ready: true, expired: true);
  }

  Future<void> _clear() async {
    await _store.write(_tokenKey, null);
    await _store.write(_orgKey, null);
  }

  /// An invitation opened without a session: reopened after sign-in or sign-up (as the web's lk_next cookie).
  Future<void> rememberNext(String path) => _store.write(_nextKey, path);

  Future<String?> takeNext() async {
    final next = await _store.read(_nextKey);
    if (next != null) await _store.write(_nextKey, null);
    return next != null && next.startsWith('/') && !next.startsWith('//') ? next : null;
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(SessionController.new);

/// Language of the app: the choice made on this device, otherwise the account's, otherwise the system's (fr by default).
class LocaleController extends Notifier<String> {
  SecretStore get _store => ref.read(secretStoreProvider);
  bool _chosen = false;

  @override
  String build() {
    Future.microtask(() async {
      final saved = await _store.read(_localeKey);
      if (saved == 'fr' || saved == 'en') {
        _chosen = true;
        state = saved!;
      }
    });
    return PlatformDispatcher.instance.locale.languageCode == 'en' ? 'en' : 'fr';
  }

  Future<void> accountLocale(String locale) async {
    if (!_chosen && (locale == 'fr' || locale == 'en')) state = locale;
  }

  /// FR | EN button (M01, M08): kept on the device and, when signed in, on the account.
  Future<void> choose(String locale) async {
    _chosen = true;
    state = locale;
    await _store.write(_localeKey, locale);
    if (ref.read(sessionProvider).signedIn) {
      try {
        await ref.read(apiProvider).updateMe(locale: locale);
      } on ApiError {
        // Still applied on the device; the account follows next time.
      }
    }
  }
}

final localeProvider = NotifierProvider<LocaleController, String>(LocaleController.new);
