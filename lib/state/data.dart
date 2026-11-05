// What the screens show, read from the API for the chosen organization. A refresh keeps the previous value, so a
// failed refresh shows the « Connexion impossible » banner over data already loaded (M13).
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models.dart';
import 'session.dart';

String _org(Ref ref) {
  final id = ref.watch(sessionProvider.select((s) => s.orgId));
  if (id == null) throw StateError('no organization selected');
  return id;
}

final orgAccessProvider = FutureProvider<OrgAccess>((ref) => ref.read(apiProvider).org(_org(ref)));

final projectsProvider = FutureProvider<List<Project>>((ref) => ref.read(apiProvider).projects(_org(ref)));

final projectProvider = FutureProvider.autoDispose.family<ProjectDetail, String>(
  (ref, id) => ref.read(apiProvider).project(_org(ref), id),
);

final membersProvider = FutureProvider<MembersList>((ref) => ref.read(apiProvider).members(_org(ref)));

final billingProvider = FutureProvider<Billing>((ref) => ref.read(apiProvider).billing(_org(ref)));

final invitationProvider = FutureProvider.autoDispose.family<InvitationInfo, String>(
  (ref, token) => ref.read(apiProvider).invitation(token),
);

/// After a change: the lists and the organization (usage, plan) are read again.
void refreshOrgData(WidgetRef ref) {
  ref.invalidate(orgAccessProvider);
  ref.invalidate(projectsProvider);
  ref.invalidate(membersProvider);
  ref.invalidate(billingProvider);
}
