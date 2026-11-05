// M06 Membres, M06b un seul membre, M06c inviter (feuille du bas). Admins open a row to change a role, remove a
// member, resend or cancel an invitation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api.dart';
import '../data/models.dart';
import '../state/data.dart';
import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final list = ref.watch(membersProvider);
    final access = ref.watch(orgAccessProvider).value;
    final isAdmin = access?.role.isAdmin ?? false;
    final me = ref.watch(sessionProvider.select((s) => s.user?.id));
    Future<void> reload() async {
      ref.invalidate(orgAccessProvider);
      ref.invalidate(membersProvider);
      await ref.read(membersProvider.future).catchError((_) => const MembersList([], []));
    }

    final data = list.value;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabHeader(t.commonNavMembers),
          Expanded(
            child: switch (list) {
              AsyncValue(hasValue: false, :final error?) => ErrorView(error: error, onRetry: reload),
              AsyncValue(hasValue: false) => const Center(child: CircularProgressIndicator()),
              _ => RefreshIndicator(
                onRefresh: reload,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    if (access != null)
                      Text(_summary(context, access.org), style: LkText.subtitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 16),
                    if (list.hasError) ...[OfflineBanner(onRetry: reload), const SizedBox(height: 16)],
                    for (final m in data!.members)
                      _Row(
                        name: m.name,
                        id: m.id,
                        subtitle: m.email,
                        badge: LkBadge(
                          roleLabel(t, m.role),
                          tone: m.role.isAdmin ? LkBadgeTone.primary : LkBadgeTone.neutral,
                        ),
                        onTap: isAdmin && m.role != Role.owner && m.id != me
                            ? () => _memberActions(context, ref, m)
                            : null,
                      ),
                    for (final i in data.invitations)
                      _Row(
                        name: i.email,
                        id: i.id,
                        subtitle: roleLabel(t, i.role),
                        badge: LkBadge(t.commonStatusPending, tone: LkBadgeTone.warning),
                        onTap: isAdmin ? () => _invitationActions(context, ref, i) : null,
                      ),
                    if (data.members.length == 1 && data.invitations.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: LkEmptyState(
                          illustration: 'membres-vide',
                          title: t.membersEmptyTitle,
                          text: t.membersEmptyText(access?.org.name ?? ''),
                        ),
                      ),
                  ],
                ),
              ),
            },
          ),
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: LkButton(t.membersInviteTitle, onPressed: () => showLkSheet(context, (_) => const InviteSheet())),
            ),
        ],
      ),
    );
  }

  String _summary(BuildContext context, Org org) {
    final t = context.t;
    return [
      t.membersSummaryActive(org.usage.members),
      if (org.usage.pendingInvitations > 0) t.membersSummaryPending(org.usage.pendingInvitations),
      if (org.limits.members != null) t.membersSummaryLimit('${org.limits.members}', planLabel(t, org.plan)),
    ].join(' · ');
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function(LaunchKitApi api, String org) call,
    String done,
  ) async {
    try {
      await call(ref.read(apiProvider), ref.read(sessionProvider).orgId!);
      refreshOrgData(ref);
      if (context.mounted) showMessage(context, done);
    } on ApiError catch (e) {
      if (context.mounted) showMessage(context, errorText(context.t, e));
    }
  }

  Future<void> _memberActions(BuildContext context, WidgetRef ref, Member m) async {
    final t = context.t;
    final newRole = m.role == Role.admin ? Role.member : Role.admin;
    final orgName = ref.read(sessionProvider).org?.name ?? '';
    final choice = await showLkSheet<String>(
      context,
      (sheet) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(m.name, style: LkText.pageTitle)),
          const SizedBox(height: 4),
          Text(m.email, style: LkText.meta),
          const SizedBox(height: 24),
          LkButton(
            '${t.membersActionChangeRole} · ${roleLabel(t, newRole)}',
            kind: LkButtonKind.secondary,
            onPressed: () => Navigator.pop(sheet, 'role'),
          ),
          const SizedBox(height: 10),
          LkButton(t.membersActionRemove, kind: LkButtonKind.danger, onPressed: () => Navigator.pop(sheet, 'remove')),
        ],
      ),
    );
    if (!context.mounted) return;
    if (choice == 'role') {
      await _run(
        context,
        ref,
        (api, org) => api.changeRole(org, m.id, newRole),
        t.membersToastRoleChanged(m.name, roleLabel(t, newRole)),
      );
    } else if (choice == 'remove') {
      final sure = await showLkSheet<bool>(
        context,
        (sheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(header: true, child: Text(t.membersConfirmRemoveTitle(m.name), style: LkText.pageTitle)),
            const SizedBox(height: 10),
            Text(t.membersConfirmRemoveText(m.name, orgName), style: LkText.body),
            const SizedBox(height: 24),
            LkButton(
              t.membersConfirmRemoveConfirm,
              kind: LkButtonKind.danger,
              onPressed: () => Navigator.pop(sheet, true),
            ),
            const SizedBox(height: 10),
            LkButton(t.commonActionCancel, kind: LkButtonKind.secondary, onPressed: () => Navigator.pop(sheet, false)),
          ],
        ),
      );
      if (sure == true && context.mounted) {
        await _run(context, ref, (api, org) => api.removeMember(org, m.id), t.membersToastRemoved(m.name, orgName));
      }
    }
  }

  Future<void> _invitationActions(BuildContext context, WidgetRef ref, Invitation i) async {
    final t = context.t;
    final choice = await showLkSheet<String>(
      context,
      (sheet) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(i.email, style: LkText.pageTitle)),
          const SizedBox(height: 24),
          LkButton(
            t.membersActionResendInvite,
            kind: LkButtonKind.secondary,
            onPressed: () => Navigator.pop(sheet, 'resend'),
          ),
          const SizedBox(height: 10),
          LkButton(
            t.membersActionCancelInvite,
            kind: LkButtonKind.danger,
            onPressed: () => Navigator.pop(sheet, 'cancel'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (choice == 'resend') {
      await _run(context, ref, (api, org) => api.resendInvitation(org, i.id), t.membersToastInvitationResent(i.email));
    } else if (choice == 'cancel') {
      await _run(context, ref, (api, org) => api.cancelInvitation(org, i.id), t.membersToastInvitationCanceled);
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.name, required this.id, required this.subtitle, required this.badge, this.onTap});
  final String name, id, subtitle;
  final Widget badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      constraints: const BoxConstraints(minHeight: 76),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: LkColors.border)),
      ),
      child: Row(
        children: [
          LkAvatar(name: name, id: id),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: LkText.rowTitle, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: LkText.meta, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          badge,
        ],
      ),
    ),
  );
}

/// M06c: e-mail and role of the person to invite.
class InviteSheet extends ConsumerStatefulWidget {
  const InviteSheet({super.key});
  @override
  ConsumerState<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<InviteSheet> {
  final _email = TextEditingController();
  Role _role = Role.member;
  ApiError? _error;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(apiProvider).invite(ref.read(sessionProvider).orgId!, email, _role);
      if (!mounted) return;
      refreshOrgData(ref);
      final message = context.t.membersToastInvitationSent(email);
      Navigator.pop(context);
      showMessage(context, message);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final error = _error;
    Widget choice(Role role, String title, String desc) {
      final selected = _role == role;
      return Semantics(
        inMutuallyExclusiveGroup: true,
        checked: selected,
        child: LkCard(
          onTap: () => setState(() => _role = role),
          color: selected ? LkColors.primary50 : LkColors.bg,
          borderColor: selected ? LkColors.primary500 : LkColors.border,
          radius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? LkColors.primary500 : LkColors.textMuted,
                    width: selected ? 5 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: LkText.rowTitle),
                    Text(desc, style: LkText.meta),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(t.membersInviteTitle, style: LkText.pageTitle)),
        const SizedBox(height: 6),
        Text(t.membersInviteDesc, style: LkText.body),
        const SizedBox(height: 20),
        if (error != null && error.errors.isEmpty) ...[
          LkAlert(errorText(t, error), tone: LkTone.danger),
          const SizedBox(height: 16),
        ],
        LkField(
          label: t.authFieldEmail,
          controller: _email,
          icon: 'mail',
          hint: 'yao@demo.test',
          keyboardType: TextInputType.emailAddress,
          error: error?.field('email'),
        ),
        const SizedBox(height: 16),
        Text(t.membersInviteRole, style: LkText.label),
        const SizedBox(height: 8),
        choice(Role.admin, t.commonRoleAdmin, t.commonRoleAdminDesc),
        const SizedBox(height: 10),
        choice(Role.member, t.commonRoleMember, t.commonRoleMemberDesc),
        const SizedBox(height: 24),
        LkButton(t.membersInviteSubmit, onPressed: _submit, loading: _busy),
      ],
    );
  }
}
