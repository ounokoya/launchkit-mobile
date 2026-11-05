// Pieces shared by the screens: headers, language switch, organization chip, offline banner and error views
// (M12, M12b, M12c, M13).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/api.dart';
import '../data/models.dart';
import '../l10n/app_localizations.dart';
import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';

extension Texts on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this);
}

/// Message to show for a failed request: the API's translated `detail`, or « Connexion impossible ».
String errorText(AppLocalizations t, Object error) => switch (error) {
  ApiError(isNetwork: true) => t.errorNetwork,
  ApiError(:final detail) when detail.isNotEmpty => detail,
  _ => t.errorServerText,
};

void showMessage(BuildContext context, String message) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(message)));

String roleLabel(AppLocalizations t, Role role) => switch (role) {
  Role.owner => t.commonRoleOwner,
  Role.admin => t.commonRoleAdmin,
  Role.member => t.commonRoleMember,
};

String planLabel(AppLocalizations t, Plan plan) => plan == Plan.pro ? t.commonPlanPro : t.commonPlanFree;

/// FR | EN with the globe (M01, M02): changes the app's language at once.
class LanguageSwitch extends ConsumerWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    Widget choice(String code) => Semantics(
      button: true,
      selected: current == code,
      label: code == 'fr' ? context.t.commonLanguageFr : context.t.commonLanguageEn,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => ref.read(localeProvider.notifier).choose(code),
        child: SizedBox(
          width: 40,
          height: 48,
          child: Center(
            child: Text(
              code.toUpperCase(),
              style: LkText.metaStrong.copyWith(
                fontWeight: current == code ? FontWeight.w700 : FontWeight.w500,
                color: current == code ? LkColors.primary500 : LkColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
    return SizedBox(
      height: 48,
      child: IntrinsicWidth(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              top: 6,
              bottom: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LkColors.surface,
                  border: Border.all(color: LkColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LkIcon('globe', size: 20),
                  const SizedBox(width: 4),
                  choice('fr'),
                  Container(width: 1, height: 14, color: LkColors.border),
                  choice('en'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Frame of the screens without tabs (M01, M02, M09, M10, M11): language switch, logo, scrollable content.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.children, this.bottom, this.logo = true});
  final List<Widget> children;
  final Widget? bottom;
  final bool logo;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(alignment: Alignment.centerRight, child: LanguageSwitch()),
                  if (logo) ...[
                    const SizedBox(height: 24),
                    const Align(alignment: Alignment.centerLeft, child: LkLogo()),
                  ],
                  const SizedBox(height: 40),
                  ...children,
                ],
              ),
            ),
          ),
          if (bottom != null) Padding(padding: const EdgeInsets.fromLTRB(24, 0, 24, 16), child: bottom),
        ],
      ),
    ),
  );
}

/// Title of a tab (M04, M06, M07, M08), with an optional element on the right.
class TabHeader extends StatelessWidget {
  const TabHeader(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 24, 0),
    child: Row(
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(title, style: LkText.screenTitle)),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Back arrow and title of a pushed screen (M05, M05b).
class BackHeader extends StatelessWidget {
  const BackHeader(this.title, {super.key, this.trailing, this.onBack});
  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
    child: Row(
      children: [
        IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: onBack ?? () => context.canPop() ? context.pop() : context.go('/projects'),
          icon: const LkIcon('arrow-left', color: LkColors.text),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: LkText.pageTitle, overflow: TextOverflow.ellipsis),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// « Acme · Free » with the avatar: back to the choice of organization (M03).
class OrgChip extends ConsumerWidget {
  const OrgChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(sessionProvider.select((s) => s.org));
    if (org == null) return const SizedBox.shrink();
    return Semantics(
      button: true,
      label: '${org.name} · ${planLabel(context.t, org.plan)}',
      hint: context.t.mobileOrgsTitle,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => context.push('/orgs'),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Container(
              height: 36,
              padding: const EdgeInsets.only(left: 7, right: 8),
              decoration: BoxDecoration(
                color: LkColors.surface,
                border: Border.all(color: LkColors.border),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LkAvatar(name: org.name, id: org.id, size: 22),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      '${org.name} · ${planLabel(context.t, org.plan)}',
                      style: LkText.metaStrong.copyWith(fontWeight: FontWeight.w600, color: LkColors.text),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const LkIcon('chevron-down', size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// M13: data already loaded stays visible, with this banner.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => LkAlert(
    context.t.errorNetwork,
    icon: 'globe',
    action: TextButton(
      onPressed: onRetry,
      style: TextButton.styleFrom(
        foregroundColor: LkColors.primary500,
        minimumSize: const Size(48, 48),
        textStyle: LkText.label.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Text(context.t.commonActionRetry),
    ),
  );
}

/// A request failed and nothing is loaded: 403 (M12), 404 (M12b), network or server (M12c).
class ErrorView extends ConsumerWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final status = error is ApiError ? (error as ApiError).status : 500;
    final org = ref.watch(sessionProvider.select((s) => s.org?.name)) ?? '';
    final view = switch (status) {
      403 => LkEmptyState(illustration: 'erreur-403', title: t.errorForbiddenTitle, text: t.errorForbiddenText(org)),
      404 => LkEmptyState(
        illustration: 'erreur-404',
        title: t.errorNotFoundTitle,
        text: t.errorNotFoundText,
        action: LkButton(t.commonActionBackHome, onPressed: () => context.go('/projects')),
      ),
      _ => LkEmptyState(
        illustration: 'erreur-404',
        title: t.errorServerTitle,
        text: status == 0 ? t.errorNetwork : t.errorServerText,
        action: LkButton(t.commonActionRetry, onPressed: onRetry),
      ),
    };
    return Center(
      child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: view),
    );
  }
}

/// While the stored session is checked.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: LkLogo()));
}

/// The API could not be reached when the app started (M12c).
class UnavailableScreen extends ConsumerWidget {
  const UnavailableScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: SafeArea(
      child: ErrorView(error: const ApiError(0, 'network', ''), onRetry: ref.read(sessionProvider.notifier).restore),
    ),
  );
}

/// A link that leads nowhere (M12b).
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: BackHeader('', onBack: () => context.go('/projects')),
          ),
          Expanded(
            child: ErrorView(error: const ApiError(404, 'not_found', ''), onRetry: () {}),
          ),
        ],
      ),
    ),
  );
}
