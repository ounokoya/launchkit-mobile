// M03 Choisir l'organisation, M11 Créer son organisation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/api.dart';
import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

class OrgsScreen extends ConsumerStatefulWidget {
  const OrgsScreen({super.key});
  @override
  ConsumerState<OrgsScreen> createState() => _OrgsScreenState();
}

class _OrgsScreenState extends ConsumerState<OrgsScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final session = ref.watch(sessionProvider);
    final orgs = session.organizations;
    final selected = orgs.where((o) => o.id == (_selected ?? session.orgId)).firstOrNull ?? orgs.firstOrNull;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                children: [
                  Semantics(header: true, child: Text(t.mobileOrgsTitle, style: LkText.screenTitle)),
                  const SizedBox(height: 8),
                  Text(t.mobileOrgsSubtitle, style: LkText.subtitle),
                  const SizedBox(height: 24),
                  for (final org in orgs) ...[
                    Semantics(
                      selected: org.id == selected?.id,
                      child: LkCard(
                        onTap: () => setState(() => _selected = org.id),
                        color: org.id == selected?.id ? LkColors.primary50 : LkColors.bg,
                        borderColor: org.id == selected?.id ? LkColors.primary500 : LkColors.border,
                        child: Row(
                          children: [
                            LkAvatar(name: org.name, id: org.id),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(org.name, style: LkText.cardTitle),
                                  const SizedBox(height: 2),
                                  Text(t.mobileOrgsDesc(org.members, planLabel(t, org.plan)), style: LkText.meta),
                                ],
                              ),
                            ),
                            LkBadge(
                              roleLabel(t, org.role),
                              tone: org.role.isAdmin ? LkBadgeTone.primary : LkBadgeTone.neutral,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  LkCard(
                    onTap: () => context.push('/onboarding'),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LkIcon('plus', color: LkColors.primary500),
                        const SizedBox(width: 10),
                        Text(t.mobileOrgsCreate, style: LkText.bodyStrong.copyWith(color: LkColors.primary500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (selected != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: LkButton(
                  t.mobileOrgsContinueWith(selected.name),
                  onPressed: () async {
                    await ref.read(sessionProvider.notifier).selectOrg(selected.id);
                    if (context.mounted) context.go('/projects');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _name = TextEditingController();
  ApiError? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await ref.read(apiProvider).createOrg(_name.text.trim());
      await ref.read(sessionProvider.notifier).refresh(select: id);
      if (mounted) context.go('/projects');
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
    return AuthScaffold(
      children: [
        Semantics(header: true, child: Text(t.onboardingOrgTitle, style: LkText.authTitle)),
        const SizedBox(height: 10),
        Text(t.onboardingOrgText, style: LkText.subtitle),
        const SizedBox(height: 28),
        if (error != null && error.errors.isEmpty) ...[
          LkAlert(errorText(t, error), tone: LkTone.danger),
          const SizedBox(height: 16),
        ],
        LkField(
          label: t.onboardingOrgName,
          controller: _name,
          hint: 'Acme',
          help: t.onboardingOrgNameHelp,
          error: error?.field('name'),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 20),
        LkNote(t.onboardingDefaultPlan('3', '3'), icon: 'zap'),
        const SizedBox(height: 28),
        LkButton(t.onboardingSubmit, onPressed: _submit, loading: _busy),
      ],
    );
  }
}
