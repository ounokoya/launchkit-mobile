// The LaunchKit API seen by the app (ADR-0014): one interface, used by the screens and replaced by a fake in the
// tests, and its dio implementation. Errors become ApiError: test `code`, show `detail` (already translated).
import 'package:dio/dio.dart';

import 'models.dart';

class ApiError implements Exception {
  const ApiError(this.status, this.code, this.detail, [this.errors = const {}]);

  /// 0 when the API could not be reached (no network, server down).
  final int status;
  final String code;
  final String detail;

  /// Translated messages per field (400 invalid_request).
  final Map<String, List<String>> errors;

  bool get isNetwork => status == 0;
  String? field(String name) => errors[name]?.join(' ');

  @override
  String toString() => 'ApiError($status, $code)';
}

abstract interface class LaunchKitApi {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String locale,
  });
  Future<Session> verifyEmail(String token);
  Future<void> resendVerification(String email);
  Future<Session> login(String email, String password);
  Future<void> logout();
  Future<Me> me();
  Future<User> updateMe({String? name, String? locale});

  Future<String> createOrg(String name);
  Future<OrgAccess> org(String org);

  Future<List<Project>> projects(String org);
  Future<ProjectDetail> project(String org, String id);
  Future<Project> createProject(String org, ProjectInput input);
  Future<Project> updateProject(String org, String id, ProjectInput input);
  Future<void> deleteProject(String org, String id);

  Future<MembersList> members(String org);
  Future<void> invite(String org, String email, Role role);
  Future<void> changeRole(String org, String user, Role role);
  Future<void> removeMember(String org, String user);
  Future<void> resendInvitation(String org, String id);
  Future<void> cancelInvitation(String org, String id);

  Future<InvitationInfo> invitation(String token);
  Future<String> acceptInvitation(String token);
  Future<void> declineInvitation(String token);

  Future<Billing> billing(String org);
  Future<void> checkout(String org);
}

/// Turns a dio failure into an ApiError (problem+json, or no answer at all).
ApiError toApiError(DioException e) {
  final response = e.response;
  if (response == null) return ApiError(0, 'network', e.message ?? 'network');
  final data = response.data;
  if (data is Map) {
    final errors = <String, List<String>>{};
    final raw = data['errors'];
    if (raw is Map) {
      for (final entry in raw.entries) {
        errors['${entry.key}'] = [
          for (final m in (entry.value is List ? entry.value as List : [entry.value])) '$m',
        ];
      }
    }
    return ApiError(
      response.statusCode ?? 500,
      '${data['code'] ?? 'server_error'}',
      '${data['detail'] ?? response.statusMessage ?? ''}',
      errors,
    );
  }
  return ApiError(response.statusCode ?? 500, 'server_error', response.statusMessage ?? '');
}

class DioLaunchKitApi implements LaunchKitApi {
  /// [token] and [locale] are read on every request; [onUnauthorized] runs when the API refuses the session (401).
  DioLaunchKitApi({
    required String baseUrl,
    required String? Function() token,
    required String Function() locale,
    void Function()? onUnauthorized,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = '${baseUrl.replaceAll(RegExp(r'/$'), '')}/api/v1'
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 20)
      ..headers['Accept'] = 'application/json';
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final value = token();
          if (value != null) options.headers['Authorization'] = 'Bearer $value';
          options.headers['Accept-Language'] = locale();
          handler.next(options);
        },
        onError: (e, handler) {
          final signedIn = e.requestOptions.headers.containsKey('Authorization');
          if (e.response?.statusCode == 401 && signedIn) onUnauthorized?.call();
          handler.next(e);
        },
      ),
    );
  }

  final Dio _dio;

  Future<T> _call<T>(Future<Response<dynamic>> Function() request, T Function(dynamic data) read) async {
    try {
      final response = await request();
      return read(response.data);
    } on DioException catch (e) {
      throw toApiError(e);
    }
  }

  Future<void> _send(Future<Response<dynamic>> Function() request) => _call(request, (_) {});
  String _o(String org) => '/orgs/${Uri.encodeComponent(org)}';
  String _t(String token) => '/invitations/${Uri.encodeComponent(token)}';

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String locale,
  }) => _send(
    () => _dio.post('/auth/register', data: {'name': name, 'email': email, 'password': password, 'locale': locale}),
  );

  @override
  Future<Session> verifyEmail(String token) =>
      _call(() => _dio.post('/auth/verify-email', data: {'token': token}), (d) => Session.fromJson(obj(d)));

  @override
  Future<void> resendVerification(String email) =>
      _send(() => _dio.post('/auth/verify-email/resend', data: {'email': email}));

  @override
  Future<Session> login(String email, String password) => _call(
    () => _dio.post('/auth/login', data: {'email': email, 'password': password}),
    (d) => Session.fromJson(obj(d)),
  );

  @override
  Future<void> logout() => _send(() => _dio.post('/auth/logout'));

  @override
  Future<Me> me() => _call(() => _dio.get('/me'), (d) => Me.fromJson(obj(d)));

  @override
  Future<User> updateMe({String? name, String? locale}) => _call(
    () => _dio.patch('/me', data: {'name': ?name, 'locale': ?locale}),
    (d) => User.fromJson(obj(obj(d)['user'])),
  );

  @override
  Future<String> createOrg(String name) =>
      _call(() => _dio.post('/orgs', data: {'name': name}), (d) => obj(obj(d)['org'])['id'] as String);

  @override
  Future<OrgAccess> org(String org) => _call(() => _dio.get(_o(org)), (d) => OrgAccess.fromJson(obj(d)));

  @override
  Future<List<Project>> projects(String org) =>
      _call(() => _dio.get('${_o(org)}/projects'), (d) => [for (final p in objs(d)) Project.fromJson(p)]);

  @override
  Future<ProjectDetail> project(String org, String id) =>
      _call(() => _dio.get('${_o(org)}/projects/${Uri.encodeComponent(id)}'), (d) => ProjectDetail.fromJson(obj(d)));

  @override
  Future<Project> createProject(String org, ProjectInput input) =>
      _call(() => _dio.post('${_o(org)}/projects', data: input.toJson()), _project);

  @override
  Future<Project> updateProject(String org, String id, ProjectInput input) =>
      _call(() => _dio.patch('${_o(org)}/projects/${Uri.encodeComponent(id)}', data: input.toJson()), _project);

  static Project _project(dynamic d) {
    final j = obj(d);
    return Project.fromJson(j.containsKey('project') ? obj(j['project']) : j);
  }

  @override
  Future<void> deleteProject(String org, String id) =>
      _send(() => _dio.delete('${_o(org)}/projects/${Uri.encodeComponent(id)}'));

  @override
  Future<MembersList> members(String org) =>
      _call(() => _dio.get('${_o(org)}/members'), (d) => MembersList.fromJson(obj(d)));

  @override
  Future<void> invite(String org, String email, Role role) =>
      _send(() => _dio.post('${_o(org)}/invitations', data: {'email': email, 'role': role.name}));

  @override
  Future<void> changeRole(String org, String user, Role role) =>
      _send(() => _dio.patch('${_o(org)}/members/${Uri.encodeComponent(user)}', data: {'role': role.name}));

  @override
  Future<void> removeMember(String org, String user) =>
      _send(() => _dio.delete('${_o(org)}/members/${Uri.encodeComponent(user)}'));

  @override
  Future<void> resendInvitation(String org, String id) =>
      _send(() => _dio.post('${_o(org)}/invitations/${Uri.encodeComponent(id)}/resend'));

  @override
  Future<void> cancelInvitation(String org, String id) =>
      _send(() => _dio.delete('${_o(org)}/invitations/${Uri.encodeComponent(id)}'));

  @override
  Future<InvitationInfo> invitation(String token) =>
      _call(() => _dio.get(_t(token)), (d) => InvitationInfo.fromJson(obj(d)));

  @override
  Future<String> acceptInvitation(String token) =>
      _call(() => _dio.post('${_t(token)}/accept'), (d) => obj(obj(d)['org'])['id'] as String);

  @override
  Future<void> declineInvitation(String token) => _send(() => _dio.post('${_t(token)}/decline'));

  @override
  Future<Billing> billing(String org) => _call(() => _dio.get('${_o(org)}/billing'), (d) => Billing.fromJson(obj(d)));

  @override
  Future<void> checkout(String org) => _send(() => _dio.post('${_o(org)}/billing/checkout', data: {'plan': 'pro'}));
}
