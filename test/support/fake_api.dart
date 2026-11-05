// In-memory LaunchKit API for the screen tests: the demo data of the Penpot screens (Marie, Acme, three projects),
// with switches to make a call fail.
import 'package:launchkit/data/api.dart';
import 'package:launchkit/data/models.dart';

String ago(Duration d) => DateTime.now().toUtc().subtract(d).toIso8601String();

const marie = User(id: 'u-marie', name: 'Marie Koné', email: 'marie@demo.test', locale: 'fr');
const jean = User(id: 'u-jean', name: 'Jean Diallo', email: 'jean@demo.test', locale: 'fr');

class FakeApi implements LaunchKitApi {
  FakeApi({this.user = marie, List<MyOrganization>? orgs, List<Project>? projects, this.plan = Plan.free}) {
    orgList = orgs ?? [const MyOrganization(id: 'o-acme', name: 'Acme', plan: Plan.free, role: Role.owner, members: 3)];
    projectList =
        projects ??
        [
          Project(
            id: 'p1',
            name: 'Site vitrine',
            description: 'Refonte complète du site de l’agence : page d’accueil, catalogue de services et formulaire de contact.',
            status: ProjectStatus.active,
            leadId: 'u-marie',
            leadName: 'Marie Koné',
            dueDate: '2026-11-28',
            createdBy: 'u-marie',
            createdAt: ago(const Duration(days: 3)),
            updatedAt: ago(const Duration(hours: 2)),
          ),
          Project(
            id: 'p2',
            name: 'App mobile',
            status: ProjectStatus.inProgress,
            createdBy: 'u-jean',
            createdAt: ago(const Duration(days: 2)),
            updatedAt: ago(const Duration(days: 1)),
          ),
          Project(
            id: 'p3',
            name: 'Tableau de bord',
            status: ProjectStatus.draft,
            createdBy: 'u-marie',
            createdAt: ago(const Duration(hours: 5)),
            updatedAt: ago(const Duration(hours: 5)),
          ),
        ];
  }

  User user;
  late List<MyOrganization> orgList;
  late List<Project> projectList;
  Plan plan;
  List<Member> memberList = const [
    Member(id: 'u-marie', name: 'Marie Koné', email: 'marie@demo.test', role: Role.owner),
    Member(id: 'u-jean', name: 'Jean Diallo', email: 'jean@demo.test', role: Role.member),
  ];
  List<Invitation> invitationList = const [Invitation(id: 'i-awa', email: 'awa@demo.test', role: Role.member)];
  bool pendingPayment = false;
  int billingReadsUntilPro = 1;
  InvitationInfo invitationInfo = const InvitationInfo(
    orgId: 'o-acme',
    orgName: 'Acme',
    inviter: 'Marie Koné',
    role: Role.member,
    email: 'marie@demo.test',
  );

  /// Call name → error thrown by that call (e.g. {'login': ApiError(401, 'login_failed', …)}).
  final Map<String, ApiError> failures = {};
  final List<String> calls = [];

  Future<T> _<T>(String name, T Function() value) async {
    calls.add(name);
    final failure = failures[name];
    if (failure != null) throw failure;
    return value();
  }

  Role get role => orgList.first.role;
  int get maxProjects => 3;

  Org get _org => Org(
    id: orgList.first.id,
    name: orgList.first.name,
    plan: plan,
    usage: Usage(projects: projectList.length, members: memberList.length, pendingInvitations: invitationList.length),
    limits: plan == Plan.pro ? const Limits() : Limits(projects: maxProjects, members: 3),
  );

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String locale,
  }) => _('register', () {});
  @override
  Future<Session> verifyEmail(String token) => _('verifyEmail', () => Session(token: 'tok-verified', user: user));
  @override
  Future<void> resendVerification(String email) => _('resendVerification', () {});
  @override
  Future<Session> login(String email, String password) => _('login', () => Session(token: 'tok-login', user: user));
  @override
  Future<void> logout() => _('logout', () {});
  @override
  Future<Me> me() => _('me', () => Me(user, orgList));
  @override
  Future<User> updateMe({String? name, String? locale}) => _('updateMe:$locale', () => user);
  @override
  Future<String> createOrg(String name) => _('createOrg', () {
    orgList = [...orgList, MyOrganization(id: 'o-new', name: name, plan: Plan.free, role: Role.owner, members: 1)];
    return 'o-new';
  });
  @override
  Future<OrgAccess> org(String org) => _('org', () => OrgAccess(_org, role));
  @override
  Future<List<Project>> projects(String org) => _('projects', () => List.of(projectList));
  @override
  Future<ProjectDetail> project(String org, String id) => _('project', () {
    final p = projectList.firstWhere(
      (p) => p.id == id,
      orElse: () => throw const ApiError(404, 'not_found', 'Introuvable'),
    );
    return ProjectDetail(p, memberList, [
      Activity(
        id: 'a1',
        type: 'project_status_changed',
        data: const {'status': 'active'},
        actor: const Actor('u-marie', 'Marie Koné'),
        createdAt: ago(const Duration(hours: 2)),
      ),
      Activity(
        id: 'a2',
        type: 'project_description_changed',
        data: const {},
        actor: const Actor('u-jean', 'Jean Diallo'),
        createdAt: ago(const Duration(days: 1)),
      ),
    ]);
  });
  @override
  Future<Project> createProject(String org, ProjectInput input) => _('createProject', () {
    final p = Project(
      id: 'p-new',
      name: input.name,
      description: input.description,
      status: input.status,
      leadId: input.leadId,
      dueDate: input.dueDate,
      createdBy: user.id,
      createdAt: ago(Duration.zero),
      updatedAt: ago(Duration.zero),
    );
    projectList = [p, ...projectList];
    return p;
  });
  @override
  Future<Project> updateProject(String org, String id, ProjectInput input) => _('updateProject', () {
    final old = projectList.firstWhere((p) => p.id == id);
    final p = Project(
      id: id,
      name: input.name,
      description: input.description,
      status: input.status,
      leadId: input.leadId,
      dueDate: input.dueDate,
      createdBy: old.createdBy,
      createdAt: old.createdAt,
      updatedAt: ago(Duration.zero),
    );
    projectList = [for (final x in projectList) x.id == id ? p : x];
    return p;
  });
  @override
  Future<void> deleteProject(String org, String id) =>
      _('deleteProject', () => projectList = projectList.where((p) => p.id != id).toList());
  @override
  Future<MembersList> members(String org) =>
      _('members', () => MembersList(memberList, role.isAdmin ? invitationList : const []));
  @override
  Future<void> invite(String org, String email, Role role) =>
      _('invite', () => invitationList = [...invitationList, Invitation(id: 'i-$email', email: email, role: role)]);
  @override
  Future<void> changeRole(String org, String user, Role role) => _('changeRole:$user:${role.name}', () {
    memberList = [
      for (final m in memberList) m.id == user ? Member(id: m.id, name: m.name, email: m.email, role: role) : m,
    ];
  });
  @override
  Future<void> removeMember(String org, String user) =>
      _('removeMember:$user', () => memberList = memberList.where((m) => m.id != user).toList());
  @override
  Future<void> resendInvitation(String org, String id) => _('resendInvitation:$id', () {});
  @override
  Future<void> cancelInvitation(String org, String id) =>
      _('cancelInvitation:$id', () => invitationList = invitationList.where((i) => i.id != id).toList());
  @override
  Future<InvitationInfo> invitation(String token) => _('invitation', () => invitationInfo);
  @override
  Future<String> acceptInvitation(String token) => _('acceptInvitation', () => invitationInfo.orgId);
  @override
  Future<void> declineInvitation(String token) => _('declineInvitation', () {});
  @override
  Future<Billing> billing(String org) => _('billing', () {
    if (pendingPayment && --billingReadsUntilPro <= 0) {
      pendingPayment = false;
      plan = Plan.pro;
      orgList = [
        for (final o in orgList)
          MyOrganization(id: o.id, name: o.name, plan: Plan.pro, role: o.role, members: o.members),
      ];
    }
    final o = _org;
    return Billing(
      plan: plan,
      usage: o.usage,
      limits: o.limits,
      proPrice: 2900,
      currency: 'EUR',
      pendingPayment: pendingPayment,
    );
  });
  @override
  Future<void> checkout(String org) => _('checkout', () => pendingPayment = true);
}
