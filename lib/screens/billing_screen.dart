// M07 Abonnement, M07b « Bienvenue dans Pro » (feuille du bas), M12 accès refusé pour un membre.
// After « Passer en Pro » the screen reads the billing again every 2 s until the worker has switched the plan.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api.dart';
import '../data/models.dart';
import '../format.dart';
import '../state/data.dart';
import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key, this.pollEvery = const Duration(seconds: 2)});
  final Duration pollEvery;
  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  Timer? _poll;
  bool _started = false, _busy = false;
  ApiError? _error;

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  /// Polls while the payment is being confirmed; « Bienvenue dans Pro » once the plan has switched (even when the
  /// worker was faster than the first check).
  void _watch(Billing billing) {
    final waiting = billing.plan == Plan.free && (billing.pendingPayment || _started);
    if (waiting) {
      _poll ??= Timer.periodic(widget.pollEvery, (_) => ref.invalidate(billingProvider));
      return;
    }
    final wasWaiting = _poll != null || _started;
    _poll?.cancel();
    _poll = null;
    if (billing.plan == Plan.pro && wasWaiting) _welcome();
  }

  Future<void> _welcome() async {
    _started = false;
    await ref.read(sessionProvider.notifier).refresh();
    if (!mounted) return;
    refreshOrgData(ref);
    final t = context.t;
    final org = ref.read(sessionProvider).org?.name ?? '';
    await showLkSheet<void>(
      context,
      (sheet) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: LkIllustration('pro', size: 160)),
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(
              t.billingProActivatedTitle,
              style: LkText.pageTitle.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Text(t.billingProActivatedText(org), style: LkText.body, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          LkButton(t.commonActionContinue, onPressed: () => Navigator.pop(sheet)),
        ],
      ),
    );
  }

  Future<void> _checkout() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(apiProvider).checkout(ref.read(sessionProvider).orgId!);
      _started = true;
      ref.invalidate(billingProvider);
    } on ApiError catch (e) {
      _error = e;
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final billing = ref.watch(billingProvider);
    ref.listen(billingProvider, (_, next) {
      if (next.value case final b?) _watch(b);
    });
    final b = billing.value;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabHeader(t.billingTitle),
          Expanded(
            child: b == null
                ? (billing.hasError
                      ? ErrorView(error: billing.error!, onRetry: () => ref.invalidate(billingProvider))
                      : const Center(child: CircularProgressIndicator()))
                : RefreshIndicator(
                    onRefresh: () async => ref.invalidate(billingProvider),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      children: [
                        if (billing.hasError && billing.error is ApiError && (billing.error as ApiError).isNetwork) ...[
                          OfflineBanner(onRetry: () => ref.invalidate(billingProvider)),
                          const SizedBox(height: 16),
                        ],
                        _CurrentPlan(b),
                        const SizedBox(height: 20),
                        if (_error != null) ...[
                          LkAlert(errorText(t, _error!), tone: LkTone.danger),
                          const SizedBox(height: 16),
                        ],
                        if (b.plan == Plan.free && (b.pendingPayment || _started)) ...[
                          LkAlert(t.billingConfirming, tone: LkTone.info, icon: 'refresh-cw'),
                          const SizedBox(height: 16),
                        ],
                        if (b.plan == Plan.free)
                          _ProCard(b, busy: _busy || b.pendingPayment || _started, onUpgrade: _checkout),
                        const SizedBox(height: 20),
                        LkNote(t.mobileBillingNote, icon: 'lock'),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CurrentPlan extends StatelessWidget {
  const _CurrentPlan(this.b);
  final Billing b;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final full = [
      (b.usage.projects, b.limits.projects),
      (b.usage.members, b.limits.members),
    ].any((u) => u.$2 != null && u.$1 >= u.$2!);
    Widget gauge(String label, int used, int? max) {
      final ratio = max == null ? 1.0 : (used / max).clamp(0.0, 1.0);
      final atMax = max != null && used >= max;
      return Semantics(
        label: label,
        value: max == null ? '$used / ${t.billingUnlimited}' : t.billingUsage('$max', '$used'),
        excludeSemantics: true,
        child: Row(
          children: [
            SizedBox(
              width: 76,
              child: Text(
                label,
                style: LkText.metaStrong.copyWith(fontWeight: FontWeight.w600, color: LkColors.text),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: LkColors.subtle,
                  color: atMax ? LkColors.danger500 : LkColors.primary500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              max == null ? '$used / ${t.billingUnlimited}' : t.billingUsage('$max', '$used'),
              style: LkText.metaStrong,
            ),
          ],
        ),
      );
    }

    return LkCard(
      radius: 16,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.billingCurrentPlan, style: LkText.metaStrong),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(planLabel(t, b.plan), style: LkText.screenTitle.copyWith(fontSize: 26))),
              if (b.plan == Plan.free && full) LkBadge(t.billingLimitReached, tone: LkBadgeTone.danger),
            ],
          ),
          const SizedBox(height: 16),
          gauge(t.commonNavProjects, b.usage.projects, b.limits.projects),
          const SizedBox(height: 14),
          gauge(t.commonNavMembers, b.usage.members, b.limits.members),
        ],
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard(this.b, {required this.busy, required this.onUpgrade});
  final Billing b;
  final bool busy;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final locale = Localizations.localeOf(context).languageCode;
    return LkCard(
      radius: 16,
      borderColor: LkColors.primary500,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(t.commonPlanPro, style: LkText.pageTitle.copyWith(fontSize: 18))),
              LkBadge(t.billingRecommended, tone: LkBadgeTone.primary),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price(b.proPrice, b.currency, locale), style: LkText.screenTitle.copyWith(fontSize: 32)),
              const SizedBox(width: 8),
              Text(t.billingPerMonthSimulated, style: LkText.meta),
            ],
          ),
          const SizedBox(height: 16),
          for (final feature in [t.billingProProjects, t.billingProMembers, t.billingProSupport]) ...[
            Row(
              children: [
                const LkIcon('check', color: LkColors.success700),
                const SizedBox(width: 8),
                Text(feature, style: LkText.label.copyWith(fontWeight: FontWeight.w400)),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          LkButton(t.upgradeButton, onPressed: onUpgrade, loading: busy),
        ],
      ),
    );
  }
}
