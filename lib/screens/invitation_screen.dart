// M10 Invitation (accepter ou refuser), M10b expirée ou plus valable, M10c destinée à un autre compte.
// Opened from the link of the e-mail; without a session, sign-in (or sign-up) first, then back here.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/api.dart';
import '../data/models.dart';
import '../state/data.dart';
import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

class InvitationScreen extends ConsumerStatefulWidget {
  const InvitationScreen({super.key, required this.token});
  final String token;
  @override
  ConsumerState<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends ConsumerState<InvitationScreen> {
  ApiError? _error;
  bool _busy = false;
  String get _path => '/invitations/${widget.token}';

  @override
  void initState() {
    super.initState();
    if (!ref.read(sessionProvider).signedIn) WidgetsBinding.instance.addPostFrameCallback((_) => _toSignIn());
  }

  Future<void> _toSignIn() async {
    await ref.read(sessionProvider.notifier).rememberNext(_path);
    if (mounted) context.go('/login?next=${Uri.encodeComponent(_path)}');
  }

  Future<void> _answer(bool accept) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final api = ref.read(apiProvider);
    try {
      if (accept) {
        final org = await api.acceptInvitation(widget.token);
        await ref.read(sessionProvider.notifier).refresh(select: org);
        if (!mounted) return;
        refreshOrgData(ref);
        showMessage(context, context.t.invitationAccepted(ref.read(sessionProvider).org?.name ?? ''));
      } else {
        await api.declineInvitation(widget.token);
        if (!mounted) return;
        showMessage(context, context.t.invitationDeclined);
      }
      if (mounted) context.go('/projects');
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e;
      });
    }
  }

  Future<void> _switchAccount() async {
    await ref.read(sessionProvider.notifier).logout();
    await _toSignIn();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final session = ref.watch(sessionProvider);
    if (!session.signedIn) return const SplashScreen();
    final info = ref.watch(invitationProvider(widget.token));
    return info.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => e is ApiError && e.status == 410
          ? AuthScaffold(
              children: [
                const Center(child: LkIllustration('invitation')),
                const SizedBox(height: 24),
                Semantics(header: true, child: Text(t.errorInvitationUnavailable, style: LkText.authTitle)),
                const SizedBox(height: 10),
                if (e.detail != t.errorInvitationUnavailable) Text(e.detail, style: LkText.subtitle),
                const SizedBox(height: 32),
                LkButton(t.commonActionClose, onPressed: () => context.go('/projects')),
              ],
            )
          : Scaffold(
              body: SafeArea(
                child: ErrorView(error: e, onRetry: () => ref.invalidate(invitationProvider(widget.token))),
              ),
            ),
      data: (invitation) => _invitation(context, invitation, session.user!),
    );
  }

  Widget _invitation(BuildContext context, InvitationInfo invitation, User user) {
    final t = context.t;
    final wrongAccount = invitation.email.toLowerCase() != user.email.toLowerCase();
    final error = _error;
    return AuthScaffold(
      children: [
        const Center(child: LkIllustration('invitation')),
        const SizedBox(height: 24),
        Semantics(header: true, child: Text(t.invitationTitle(invitation.orgName), style: LkText.authTitle)),
        const SizedBox(height: 10),
        Text(t.invitationText(invitation.inviter, invitation.orgName), style: LkText.subtitle),
        const SizedBox(height: 20),
        if (wrongAccount)
          LkAlert(t.invitationWrongAccount(invitation.email), tone: LkTone.danger, icon: 'users')
        else
          Row(
            children: [
              Text(t.invitationProposedRole, style: LkText.subtitle.copyWith(color: LkColors.text)),
              const Spacer(),
              LkBadge(
                roleLabel(t, invitation.role),
                tone: invitation.role.isAdmin ? LkBadgeTone.primary : LkBadgeTone.neutral,
              ),
            ],
          ),
        const SizedBox(height: 14),
        Text(t.invitationSignedInAs(user.email), style: LkText.caption),
        if (error != null) ...[const SizedBox(height: 16), LkAlert(errorText(t, error), tone: LkTone.danger)],
        const SizedBox(height: 28),
        if (wrongAccount)
          LkButton(t.commonActionSignOut, kind: LkButtonKind.secondary, onPressed: _switchAccount)
        else ...[
          LkButton(t.invitationAccept, onPressed: () => _answer(true), loading: _busy),
          const SizedBox(height: 10),
          LkButton(t.invitationDecline, kind: LkButtonKind.secondary, onPressed: _busy ? null : () => _answer(false)),
        ],
      ],
    );
  }
}
