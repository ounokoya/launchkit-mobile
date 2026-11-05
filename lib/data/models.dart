// Shapes returned by the API (server/docs/api_usage.md), read from JSON.
typedef Json = Map<String, dynamic>;

/// A JSON object, whatever its static type (empty when absent).
Json obj(Object? value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

List<Json> objs(Object? value) => value is List ? [for (final v in value) obj(v)] : const [];

enum Role {
  owner,
  admin,
  member;

  static Role parse(Object? value) => Role.values.firstWhere((r) => r.name == value, orElse: () => Role.member);
  bool get isAdmin => this != Role.member;
}

enum Plan {
  free,
  pro;

  static Plan parse(Object? value) => value == 'pro' ? Plan.pro : Plan.free;
}

enum ProjectStatus {
  active('active'),
  inProgress('in_progress'),
  draft('draft');

  const ProjectStatus(this.api);
  final String api;
  static ProjectStatus parse(Object? value) =>
      ProjectStatus.values.firstWhere((s) => s.api == value, orElse: () => ProjectStatus.draft);
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.locale,
    this.isSuperAdmin = false,
  });
  final String id, name, email, locale;
  final bool isSuperAdmin;

  factory User.fromJson(Json j) => User(
    id: j['id'] as String,
    name: j['name'] as String,
    email: j['email'] as String,
    locale: (j['locale'] as String?) ?? 'fr',
    isSuperAdmin: (j['isSuperAdmin'] as bool?) ?? false,
  );
}

class Session {
  const Session({required this.token, required this.user});
  final String token;
  final User user;
  factory Session.fromJson(Json j) => Session(token: j['token'] as String, user: User.fromJson(obj(j['user'])));
}

/// An organization of the signed-in person (GET /me).
class MyOrganization {
  const MyOrganization({
    required this.id,
    required this.name,
    required this.plan,
    required this.role,
    required this.members,
  });
  final String id, name;
  final Plan plan;
  final Role role;
  final int members;

  factory MyOrganization.fromJson(Json j) => MyOrganization(
    id: j['id'] as String,
    name: j['name'] as String,
    plan: Plan.parse(j['plan']),
    role: Role.parse(j['role']),
    members: (j['members'] as num?)?.toInt() ?? 1,
  );
}

class Me {
  const Me(this.user, this.organizations);
  final User user;
  final List<MyOrganization> organizations;
  factory Me.fromJson(Json j) =>
      Me(User.fromJson(obj(j['user'])), [for (final o in objs(j['organizations'])) MyOrganization.fromJson(o)]);
}

class Usage {
  const Usage({required this.projects, required this.members, required this.pendingInvitations});
  final int projects, members, pendingInvitations;
  factory Usage.fromJson(Json j) => Usage(
    projects: (j['projects'] as num?)?.toInt() ?? 0,
    members: (j['members'] as num?)?.toInt() ?? 0,
    pendingInvitations: (j['pendingInvitations'] as num?)?.toInt() ?? 0,
  );
}

/// Plan limits; null means unlimited (Pro).
class Limits {
  const Limits({this.projects, this.members});
  final int? projects, members;
  factory Limits.fromJson(Json j) =>
      Limits(projects: (j['projects'] as num?)?.toInt(), members: (j['members'] as num?)?.toInt());
}

class Org {
  const Org({required this.id, required this.name, required this.plan, required this.usage, required this.limits});
  final String id, name;
  final Plan plan;
  final Usage usage;
  final Limits limits;

  bool get atProjectLimit => limits.projects != null && usage.projects >= limits.projects!;

  factory Org.fromJson(Json j) => Org(
    id: j['id'] as String,
    name: j['name'] as String,
    plan: Plan.parse(j['plan']),
    usage: Usage.fromJson(obj(j['usage'])),
    limits: Limits.fromJson(obj(j['limits'])),
  );
}

/// GET /orgs/{org}: the organization and my role in it.
class OrgAccess {
  const OrgAccess(this.org, this.role);
  final Org org;
  final Role role;
  factory OrgAccess.fromJson(Json j) => OrgAccess(Org.fromJson(obj(j['org'])), Role.parse(j['role']));
}

class Project {
  const Project({
    required this.id,
    required this.name,
    this.description = '',
    this.status = ProjectStatus.draft,
    this.leadId,
    this.leadName,
    this.dueDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id, name, description, createdBy, createdAt, updatedAt;
  final ProjectStatus status;
  final String? leadId, leadName, dueDate;

  factory Project.fromJson(Json j) => Project(
    id: j['id'] as String,
    name: j['name'] as String,
    description: (j['description'] as String?) ?? '',
    status: ProjectStatus.parse(j['status']),
    leadId: j['leadId'] as String?,
    leadName: j['leadName'] as String?,
    dueDate: j['dueDate'] as String?,
    createdBy: (j['createdBy'] as String?) ?? '',
    createdAt: j['createdAt'] as String,
    updatedAt: (j['updatedAt'] as String?) ?? j['createdAt'] as String,
  );
}

/// What the project form sends (POST and PATCH /projects).
class ProjectInput {
  const ProjectInput({
    required this.name,
    this.description = '',
    this.status = ProjectStatus.draft,
    this.leadId,
    this.dueDate,
  });
  final String name, description;
  final ProjectStatus status;
  final String? leadId, dueDate;

  Json toJson() => {
    'name': name,
    'description': description,
    'status': status.api,
    'leadId': leadId,
    if (dueDate != null) 'dueDate': dueDate,
  };
}

class Actor {
  const Actor(this.id, this.name);
  final String id, name;
}

class Activity {
  const Activity({required this.id, required this.type, required this.data, this.actor, required this.createdAt});
  final String id, type, createdAt;
  final Map<String, String> data;
  final Actor? actor;

  factory Activity.fromJson(Json j) {
    final actor = j['actor'] == null ? null : obj(j['actor']);
    return Activity(
      id: j['id'] as String,
      type: j['type'] as String,
      data: {for (final e in (obj(j['data'])).entries) e.key: '${e.value}'},
      actor: actor == null ? null : Actor(actor['id'] as String, actor['name'] as String),
      createdAt: j['createdAt'] as String,
    );
  }
}

class Member {
  const Member({required this.id, required this.name, required this.email, required this.role});
  final String id, name, email;
  final Role role;
  factory Member.fromJson(Json j) => Member(
    id: j['id'] as String,
    name: j['name'] as String,
    email: j['email'] as String,
    role: Role.parse(j['role']),
  );
}

class Invitation {
  const Invitation({required this.id, required this.email, required this.role});
  final String id, email;
  final Role role;
  factory Invitation.fromJson(Json j) =>
      Invitation(id: j['id'] as String, email: j['email'] as String, role: Role.parse(j['role']));
}

class MembersList {
  const MembersList(this.members, this.invitations);
  final List<Member> members;
  final List<Invitation> invitations;
  factory MembersList.fromJson(Json j) => MembersList(
    [for (final m in objs(j['members'])) Member.fromJson(m)],
    [for (final i in objs(j['invitations'])) Invitation.fromJson(i)],
  );
}

class ProjectDetail {
  const ProjectDetail(this.project, this.members, this.history);
  final Project project;
  final List<Member> members;
  final List<Activity> history;
  factory ProjectDetail.fromJson(Json j) => ProjectDetail(
    Project.fromJson(obj(j['project'])),
    [for (final m in objs(j['members'])) Member.fromJson(m)],
    [for (final a in objs(j['history'])) Activity.fromJson(a)],
  );
}

class Billing {
  const Billing({
    required this.plan,
    required this.usage,
    required this.limits,
    required this.proPrice,
    required this.currency,
    required this.pendingPayment,
  });
  final Plan plan;
  final Usage usage;
  final Limits limits;
  final int proPrice;
  final String currency;
  final bool pendingPayment;

  factory Billing.fromJson(Json j) {
    final pro = obj(obj(j['prices'])['pro']);
    return Billing(
      plan: Plan.parse(j['plan']),
      usage: Usage.fromJson(obj(j['usage'])),
      limits: Limits.fromJson(obj(j['limits'])),
      proPrice: (pro['amount'] as num?)?.toInt() ?? 2900,
      currency: (pro['currency'] as String?) ?? 'EUR',
      pendingPayment: (j['pendingPayment'] as bool?) ?? false,
    );
  }
}

/// GET /invitations/{token}.
class InvitationInfo {
  const InvitationInfo({
    required this.orgId,
    required this.orgName,
    required this.inviter,
    required this.role,
    required this.email,
  });
  final String orgId, orgName, inviter, email;
  final Role role;
  factory InvitationInfo.fromJson(Json j) {
    final org = obj(j['org']);
    return InvitationInfo(
      orgId: org['id'] as String,
      orgName: org['name'] as String,
      inviter: (j['inviter'] as String?) ?? '',
      role: Role.parse(j['role']),
      email: j['email'] as String,
    );
  }
}
