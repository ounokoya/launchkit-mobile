// M08 Profil et langue. The « Notifications » and « Mot de passe » rows of the mock-up have no API in v0.1:
// left out, like the notification bell of the web.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final session = ref.watch(sessionProvider);
    final user = session.user;
    final locale = ref.watch(localeProvider);
    if (user == null) return const SizedBox.shrink();
    Widget language(String code, String label) {
      final selected = locale == code;
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          child: InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: () => ref.read(localeProvider.notifier).choose(code),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: selected ? LkColors.bg : null, borderRadius: BorderRadius.circular(9)),
              child: Text(
                label,
                style: LkText.label.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? LkColors.text : LkColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        TabHeader(t.commonNavProfile),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LkAvatar(name: user.name, id: user.id, size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: LkText.pageTitle),
                        const SizedBox(height: 4),
                        Text(user.email, style: LkText.meta.copyWith(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(t.commonLanguageLabel.toUpperCase(), style: LkText.overline),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: LkColors.subtle, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [language('fr', t.commonLanguageFr), language('en', t.commonLanguageEn)]),
              ),
              const SizedBox(height: 28),
              Text(t.mobileProfileAccount.toUpperCase(), style: LkText.overline),
              const SizedBox(height: 10),
              LkCard(
                onTap: () => context.push('/orgs'),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    const LkIcon('folder'),
                    const SizedBox(width: 12),
                    Expanded(child: Text(t.mobileProfileOrganization, style: LkText.label.copyWith(fontSize: 15))),
                    Text(session.org?.name ?? '', style: LkText.meta.copyWith(fontSize: 14)),
                    const SizedBox(width: 4),
                    const LkIcon('chevron-right'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Material(
                color: LkColors.danger50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: LkColors.danger500),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final router = GoRouter.of(context);
                    await ref.read(sessionProvider.notifier).logout();
                    router.go('/login'); // a deliberate sign-out does not come back to the profile
                  },
                  child: SizedBox(
                    height: 52,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LkIcon('log-out', color: LkColors.danger700),
                        const SizedBox(width: 10),
                        Text(t.commonActionSignOut, style: LkText.bodyStrong.copyWith(color: LkColors.danger700)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
