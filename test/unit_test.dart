// Pure logic: display helpers (same rules as the web), models, the API client, the redirections and the session.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:launchkit/data/api.dart';
import 'package:launchkit/data/models.dart';
import 'package:launchkit/format.dart';
import 'package:launchkit/l10n/app_localizations_en.dart';
import 'package:launchkit/l10n/app_localizations_fr.dart';
import 'package:launchkit/router.dart';
import 'package:launchkit/state/session.dart';

import 'support/fake_api.dart';

/// Answers dio requests from a table, and records them.
class FakeAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  ResponseBody Function(RequestOptions o) reply = (_) => ResponseBody.fromString('{}', 200, headers: _json);
  static const _json = {
    Headers.contentTypeHeader: ['application/json'],
  };

  static ResponseBody json(Object body, [int status = 200]) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [status >= 400 ? 'application/problem+json' : 'application/json'],
    },
  );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return reply(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() => initializeDateFormatting());
  final fr = AppLocalizationsFr(), en = AppLocalizationsEn();

  group('format (same results as web/src/lib/format.ts)', () {
    final now = DateTime.utc(2026, 11, 5, 12);
    test('relative time', () {
      expect(relativeTime(fr, '2026-11-05T11:59:40Z', now: now), 'à l’instant');
      expect(relativeTime(fr, '2026-11-05T11:35:00Z', now: now), 'il y a 25 min');
      expect(relativeTime(fr, '2026-11-05T10:00:00Z', now: now), 'il y a 2 h');
      expect(relativeTime(fr, '2026-11-04T10:00:00Z', now: now), 'hier');
      expect(relativeTime(fr, '2026-11-01T10:00:00Z', now: now), 'il y a 4 jours');
      expect(relativeTime(en, '2026-11-01T10:00:00Z', now: now), '4 days ago');
      expect(relativeTime(fr, '2026-11-06T10:00:00Z', now: now), 'à l’instant');
    });
    test('dates', () {
      expect(longDate('2026-11-28', 'fr'), '28 novembre 2026');
      expect(longDate('2026-11-28', 'en'), 'November 28, 2026');
      expect(shortDate('2026-11-28', 'fr'), '28 nov. 2026');
      expect(shortDate('2026-11-28T09:30:00.000Z', 'en'), 'Nov 28, 2026');
    });
    test('initials', () {
      expect(initials('Marie Koné'), 'MK');
      expect(initials('Awa'), 'AW');
      expect(initials('  Jean   Paul Diallo '), 'JD');
      expect(initials(''), '?');
      expect(initials('A'), 'A');
    });
    test('avatar colour: same id, same colour as on the web', () {
      const web = {'abc': 5, '12345': 1, 'super-admin': 1, 'system': 3, 'marie-koné': 5, '8f3a2c1d-7e6b': 2};
      web.forEach((id, colour) => expect(avatarColor(id), colour, reason: id));
    });
    test('price', () {
      expect(price(2900, 'EUR', 'fr').replaceAll(' ', ' ').replaceAll(' ', ' '), '29 €');
      expect(price(0, 'EUR', 'en'), '€0');
      expect(price(2950, 'EUR', 'en'), '€29.50');
    });
  });

  group('models', () {
    test('read the API shapes', () {
      final me = Me.fromJson({
        'user': {
          'id': 'u1',
          'name': 'Marie',
          'email': 'm@demo.test',
          'emailVerified': true,
          'isSuperAdmin': false,
          'locale': 'en',
        },
        'organizations': [
          {'id': 'o1', 'name': 'Acme', 'plan': 'pro', 'role': 'admin', 'members': 2},
        ],
      });
      expect(me.user.locale, 'en');
      expect(me.organizations.single.plan, Plan.pro);
      expect(me.organizations.single.role.isAdmin, isTrue);
      final access = OrgAccess.fromJson({
        'org': {
          'id': 'o1',
          'name': 'Acme',
          'plan': 'free',
          'usage': {'projects': 3, 'members': 2, 'pendingInvitations': 1},
          'limits': {'projects': 3, 'members': 3},
        },
        'role': 'member',
      });
      expect(access.org.atProjectLimit, isTrue);
      expect(access.role, Role.member);
      final pro = Org.fromJson({
        'id': 'o',
        'name': 'A',
        'plan': 'pro',
        'usage': {'projects': 9},
        'limits': {'projects': null},
      });
      expect(pro.atProjectLimit, isFalse);
      final detail = ProjectDetail.fromJson({
        'project': {'id': 'p', 'name': 'Site', 'status': 'in_progress', 'createdAt': '2026-11-01T00:00:00Z'},
        'members': [
          {'id': 'u1', 'name': 'Marie', 'email': 'm@demo.test', 'role': 'owner'},
        ],
        'history': [
          {
            'id': 'a',
            'type': 'project_status_changed',
            'data': {'status': 'active'},
            'actor': null,
            'createdAt': '2026-11-01T00:00:00Z',
          },
        ],
      });
      expect(detail.project.status, ProjectStatus.inProgress);
      expect(detail.project.updatedAt, detail.project.createdAt);
      expect(detail.history.single.actor, isNull);
      final billing = Billing.fromJson({
        'plan': 'free',
        'usage': {},
        'limits': {},
        'prices': {
          'pro': {'amount': 2900, 'currency': 'EUR'},
        },
        'pendingPayment': true,
      });
      expect((billing.proPrice, billing.currency, billing.pendingPayment), (2900, 'EUR', true));
      final invitation = InvitationInfo.fromJson({
        'org': {'id': 'o', 'name': 'Acme'},
        'inviter': 'Marie',
        'role': 'admin',
        'email': 'j@demo.test',
      });
      expect(invitation.role, Role.admin);
      expect(ProjectStatus.parse('nope'), ProjectStatus.draft);
      expect(Role.parse(null), Role.member);
      expect(const ProjectInput(name: 'X', dueDate: '2026-12-01').toJson(), {
        'name': 'X',
        'description': '',
        'status': 'draft',
        'leadId': null,
        'dueDate': '2026-12-01',
      });
    });
  });

  group('API client', () {
    late FakeAdapter adapter;
    late DioLaunchKitApi api;
    String? token = 'tok';
    var unauthorized = 0;
    setUp(() {
      adapter = FakeAdapter();
      token = 'tok';
      unauthorized = 0;
      api = DioLaunchKitApi(
        baseUrl: 'http://api.test/',
        token: () => token,
        locale: () => 'en',
        onUnauthorized: () => unauthorized++,
        dio: Dio()..httpClientAdapter = adapter,
      );
    });

    test('sends the token and the language, reads the answer', () async {
      adapter.reply = (_) => FakeAdapter.json({
        'user': {'id': 'u', 'name': 'M', 'email': 'm@demo.test', 'locale': 'fr'},
        'organizations': [],
      });
      final me = await api.me();
      final r = adapter.requests.single;
      expect(r.uri.toString(), 'http://api.test/api/v1/me');
      expect(r.headers['Authorization'], 'Bearer tok');
      expect(r.headers['Accept-Language'], 'en');
      expect(me.user.name, 'M');
    });

    test('calls the documented routes', () async {
      adapter.reply = (o) => FakeAdapter.json(switch (o.path) {
        '/orgs' => {
          'org': {'id': 'o9'},
        },
        '/invitations/a%2Fb/accept' => {
          'org': {'id': 'o2'},
          'role': 'member',
        },
        '/orgs/o1/projects' when o.method == 'POST' => {'id': 'p', 'name': 'N', 'createdAt': '2026-11-01T00:00:00Z'},
        '/me' => {
          'user': {'id': 'u', 'name': 'M', 'email': 'm@demo.test', 'locale': 'en'},
        },
        '/orgs/o1/projects/p' when o.method == 'PATCH' => {
          'project': {'id': 'p', 'name': 'M', 'createdAt': '2026-11-01T00:00:00Z'},
        },
        _ => <String, Object>{},
      });
      expect(await api.createOrg('Acme'), 'o9');
      expect(await api.acceptInvitation('a/b'), 'o2');
      expect((await api.createProject('o1', const ProjectInput(name: 'N'))).name, 'N');
      expect((await api.updateProject('o1', 'p', const ProjectInput(name: 'M'))).name, 'M');
      await api.invite('o1', 'j@demo.test', Role.admin);
      await api.changeRole('o1', 'u2', Role.member);
      await api.removeMember('o1', 'u2');
      await api.resendInvitation('o1', 'i1');
      await api.cancelInvitation('o1', 'i1');
      await api.checkout('o1');
      await api.declineInvitation('t');
      await api.deleteProject('o1', 'p');
      await api.updateMe(locale: 'en');
      await api.register(name: 'M', email: 'm@demo.test', password: 'motdepasse-1', locale: 'fr');
      await api.resendVerification('m@demo.test');
      await api.logout();
      final calls = [for (final r in adapter.requests) '${r.method} ${r.path}'];
      expect(calls, [
        'POST /orgs',
        'POST /invitations/a%2Fb/accept',
        'POST /orgs/o1/projects',
        'PATCH /orgs/o1/projects/p',
        'POST /orgs/o1/invitations',
        'PATCH /orgs/o1/members/u2',
        'DELETE /orgs/o1/members/u2',
        'POST /orgs/o1/invitations/i1/resend',
        'DELETE /orgs/o1/invitations/i1',
        'POST /orgs/o1/billing/checkout',
        'POST /invitations/t/decline',
        'DELETE /orgs/o1/projects/p',
        'PATCH /me',
        'POST /auth/register',
        'POST /auth/verify-email/resend',
        'POST /auth/logout',
      ]);
      expect(adapter.requests[4].data, {'email': 'j@demo.test', 'role': 'admin'});
      expect(adapter.requests[12].data, {'locale': 'en'});
    });

    test('problem+json becomes ApiError with the translated detail and the field errors', () async {
      adapter.reply = (_) => FakeAdapter.json({
        'status': 400,
        'code': 'invalid_request',
        'detail': 'Some information is missing.',
        'errors': {
          'name': ['This field is required.'],
          'email': 'Enter a valid email.',
        },
      }, 400);
      final e = await api.createOrg('').then<ApiError?>((_) => null, onError: (Object e) => e as ApiError);
      expect((e!.status, e.code, e.detail), (400, 'invalid_request', 'Some information is missing.'));
      expect(e.field('name'), 'This field is required.');
      expect(e.field('email'), 'Enter a valid email.');
      expect(e.field('other'), isNull);
      expect(e.isNetwork, isFalse);
      expect('$e', 'ApiError(400, invalid_request)');
    });

    test('a 401 on a signed-in call ends the session; not on sign-in itself', () async {
      adapter.reply = (_) => FakeAdapter.json({'status': 401, 'code': 'unauthorized', 'detail': 'Expired'}, 401);
      await expectLater(api.me(), throwsA(isA<ApiError>().having((e) => e.status, 'status', 401)));
      expect(unauthorized, 1);
      token = null;
      await expectLater(api.login('m@demo.test', 'x'), throwsA(isA<ApiError>()));
      expect(unauthorized, 1);
    });

    test('no answer at all: a network error', () async {
      final api = DioLaunchKitApi(baseUrl: 'http://127.0.0.1:9', token: () => null, locale: () => 'fr');
      final e = await api.me().then<ApiError?>((_) => null, onError: (Object e) => e as ApiError);
      expect(e!.isNetwork, isTrue);
      expect(
        toApiError(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(requestOptions: RequestOptions(), statusCode: 502, statusMessage: 'Bad Gateway'),
          ),
        ).code,
        'server_error',
      );
    });
  });

  group('redirections', () {
    const signedOut = SessionState(ready: true);
    const acme = MyOrganization(id: 'o1', name: 'Acme', plan: Plan.free, role: Role.owner, members: 1);
    const globex = MyOrganization(id: 'o2', name: 'Globex', plan: Plan.pro, role: Role.member, members: 2);
    const user = User(id: 'u', name: 'Marie', email: 'm@demo.test', locale: 'fr');
    final inAcme = SessionState(ready: true, token: 't', user: user, organizations: const [acme, globex], orgId: 'o1');
    String? go(SessionState s, String location) => redirectFor(s, Uri.parse(location));

    test('before the session is checked: splash, then back to the address', () {
      expect(go(const SessionState(), '/verify-email?token=abc'), '/splash?from=%2Fverify-email%3Ftoken%3Dabc');
      expect(go(const SessionState(), '/splash'), isNull);
      expect(go(signedOut, '/splash?from=%2Fverify-email%3Ftoken%3Dabc'), '/verify-email?token=abc');
      expect(go(signedOut, '/splash?from=https%3A%2F%2Fevil.example'), '/projects');
    });
    test('signed out: public screens and invitations stay, the rest asks to sign in', () {
      for (final path in ['/login', '/signup', '/verify-email?email=a', '/invitations/t']) {
        expect(go(signedOut, path), isNull, reason: path);
      }
      expect(go(signedOut, '/projects'), '/login');
      expect(go(signedOut, '/members'), '/login?next=%2Fmembers');
    });
    test('signed in', () {
      expect(go(inAcme, '/login'), '/projects');
      expect(go(inAcme, '/login?next=%2Finvitations%2Ft'), '/invitations/t');
      expect(go(inAcme, '/login?next=%2F%2Fevil.example'), '/projects');
      expect(go(inAcme, '/verify-email?token=x'), isNull);
      expect(go(inAcme, '/invitations/t'), isNull);
      expect(go(inAcme, '/billing'), isNull);
      final none = SessionState(ready: true, token: 't', user: user);
      expect(go(none, '/projects'), '/onboarding');
      expect(go(none, '/onboarding'), isNull);
      final unchosen = SessionState(ready: true, token: 't', user: user, organizations: const [acme, globex]);
      expect(go(unchosen, '/projects'), '/orgs');
      expect(go(unchosen, '/orgs'), isNull);
      expect(go(unchosen, '/onboarding'), isNull);
    });
    test('API unreachable at start', () {
      const down = SessionState(ready: true, token: 't', unavailable: true);
      expect(go(down, '/projects'), '/unavailable');
      expect(go(down, '/unavailable'), isNull);
      expect(go(inAcme, '/unavailable'), '/projects');
    });
  });

  group('session', () {
    ProviderContainer make(FakeApi api, MemorySecretStore store) {
      final c = ProviderContainer(
        overrides: [apiProvider.overrideWithValue(api), secretStoreProvider.overrideWithValue(store)],
      );
      addTearDown(c.dispose);
      return c;
    }

    Future<void> idle() => Future<void>.delayed(const Duration(milliseconds: 10));

    test('no stored token: ready, signed out', () async {
      final c = make(FakeApi(), MemorySecretStore());
      c.read(sessionProvider);
      await idle();
      expect(c.read(sessionProvider).ready, isTrue);
      expect(c.read(sessionProvider).signedIn, isFalse);
    });

    test('stored token: GET /me, the only organization is chosen, the account language applies', () async {
      final api = FakeApi(
        user: const User(id: 'u', name: 'M', email: 'm@demo.test', locale: 'en'),
      );
      final c = make(api, MemorySecretStore({'session_token': 'tok'}));
      c.read(localeProvider);
      c.read(sessionProvider);
      await idle();
      final s = c.read(sessionProvider);
      expect((s.signedIn, s.org?.name), (true, 'Acme'));
      expect(c.read(localeProvider), 'en');
    });

    test('a choice made on the device wins over the account language and is saved on the account', () async {
      final store = MemorySecretStore({'session_token': 'tok', 'locale': 'fr'});
      final api = FakeApi(
        user: const User(id: 'u', name: 'M', email: 'm@demo.test', locale: 'en'),
      );
      final c = make(api, store);
      c.read(localeProvider);
      c.read(sessionProvider);
      await idle();
      expect(c.read(localeProvider), 'fr');
      await c.read(localeProvider.notifier).choose('en');
      expect(store.values['locale'], 'en');
      expect(api.calls, contains('updateMe:en'));
      api.failures['updateMe:fr'] = const ApiError(0, 'network', '');
      await c.read(localeProvider.notifier).choose('fr');
      expect(c.read(localeProvider), 'fr');
    });

    test('expired token: back to sign-in with the notice; API down: unavailable', () async {
      final api = FakeApi()..failures['me'] = const ApiError(0, 'network', '');
      final c = make(api, MemorySecretStore({'session_token': 'tok'}));
      c.read(sessionProvider);
      await idle();
      expect(c.read(sessionProvider).unavailable, isTrue);
      api.failures.clear();
      await c.read(sessionProvider.notifier).restore();
      expect(c.read(sessionProvider).signedIn, isTrue);
      await c.read(sessionProvider.notifier).expire();
      expect((c.read(sessionProvider).signedIn, c.read(sessionProvider).expired), (false, true));
    });

    test('several organizations: the stored choice, refresh with a new one, logout', () async {
      final api = FakeApi(
        orgs: const [
          MyOrganization(id: 'o1', name: 'Acme', plan: Plan.free, role: Role.owner, members: 1),
          MyOrganization(id: 'o2', name: 'Globex', plan: Plan.pro, role: Role.member, members: 2),
        ],
      );
      final store = MemorySecretStore({'session_token': 'tok', 'current_org': 'o2'});
      final c = make(api, store);
      c.read(sessionProvider);
      await idle();
      expect(c.read(sessionProvider).org?.name, 'Globex');
      await c.read(sessionProvider.notifier).selectOrg('o1');
      expect((c.read(sessionProvider).org?.name, store.values['current_org']), ('Acme', 'o1'));
      await c.read(sessionProvider.notifier).refresh(select: 'o2');
      expect(c.read(sessionProvider).orgId, 'o2');
      api.failures['logout'] = const ApiError(0, 'network', '');
      await c.read(sessionProvider.notifier).logout();
      expect((c.read(sessionProvider).signedIn, store.values.containsKey('session_token')), (false, false));
    });

    test('sign-in stores the token; the remembered link is given once, only if it is a path', () async {
      final store = MemorySecretStore();
      final c = make(FakeApi(), store);
      final s = c.read(sessionProvider.notifier);
      await idle();
      await s.signIn(const Session(token: 'new', user: marie));
      expect(store.values['session_token'], 'new');
      await s.rememberNext('/invitations/t');
      expect(await s.takeNext(), '/invitations/t');
      expect(await s.takeNext(), isNull);
      await s.rememberNext('//evil.example');
      expect(await s.takeNext(), isNull);
    });
  });
}
