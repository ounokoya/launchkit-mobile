// Shared building blocks of the mobile screens, drawn after the Penpot components (« 02 · Design system »).
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../format.dart' as fmt;
import 'tokens.dart';

/// Lucide icon from assets/icons (tools/mobile/icones_lucide.py).
class LkIcon extends StatelessWidget {
  const LkIcon(this.name, {super.key, this.size = 24, this.color = LkColors.textSecondary});
  final String name;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/icons/$name.svg',
    width: size,
    height: size,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    excludeFromSemantics: true,
  );
}

/// Illustration of brand/illustrations (decorative: hidden from screen readers).
class LkIllustration extends StatelessWidget {
  const LkIllustration(this.name, {super.key, this.size = 192});
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SvgPicture.asset('assets/illustrations/$name.svg', width: size, height: size),
  );
}

class LkLogo extends StatelessWidget {
  const LkLogo({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'LaunchKit',
    image: true,
    child: SvgPicture.asset('assets/logo/launchkit_horizontal.svg', height: 40),
  );
}

enum LkButtonKind { primary, secondary, danger }

class LkButton extends StatelessWidget {
  const LkButton(
    this.label, {
    super.key,
    this.onPressed,
    this.kind = LkButtonKind.primary,
    this.loading = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final LkButtonKind kind;
  final bool loading;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, side) = switch (kind) {
      LkButtonKind.primary => (LkColors.primary500, Colors.white, BorderSide.none),
      LkButtonKind.danger => (LkColors.danger600, Colors.white, BorderSide.none),
      LkButtonKind.secondary => (LkColors.bg, LkColors.text, const BorderSide(color: LkColors.border)),
    };
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: kind == LkButtonKind.secondary ? 1 : 0.45),
          disabledForegroundColor: kind == LkButtonKind.secondary ? LkColors.textMuted : Colors.white,
          side: side,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: LkText.button,
        ),
        child: loading
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: fg))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[LkIcon(icon!, color: fg, size: 20), const SizedBox(width: 8)],
                  Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
                ],
              ),
      ),
    );
  }
}

/// Label above the input, help or error below (Penpot « Champ »).
class LkField extends StatelessWidget {
  const LkField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.icon,
    this.help,
    this.error,
    this.obscure = false,
    this.keyboardType,
    this.autofillHints,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
    this.enabled = true,
    this.invalid = false,
  });
  final String label;
  final TextEditingController? controller;
  final String? hint, icon, help, error;
  final bool obscure, enabled;

  /// Red border without a message under the field (the message is in an alert above, M01c).
  final bool invalid;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final int maxLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final red = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: LkColors.danger500),
    );
    final below = error ?? help;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LkText.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          enabled: enabled,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          maxLines: maxLines,
          minLines: maxLines > 1 ? maxLines : null,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: LkText.input,
          decoration: InputDecoration(
            hintText: hint,
            // The message is written below, aligned with the label; the decoration only turns the border red.
            error: error == null ? null : const SizedBox.shrink(),
            prefixIcon: icon == null ? null : Padding(padding: const EdgeInsets.all(12), child: LkIcon(icon!)),
            prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            enabledBorder: invalid ? red : null,
            focusedBorder: invalid
                ? red.copyWith(borderSide: const BorderSide(color: LkColors.danger500, width: 2))
                : null,
          ),
        ),
        if (below != null) ...[
          const SizedBox(height: 6),
          Text(
            below,
            style: LkText.caption.copyWith(color: error != null ? LkColors.danger700 : LkColors.textSecondary),
          ),
        ],
      ],
    );
  }
}

enum LkTone { warning, danger, info }

/// Alert above a form or a list (Penpot « Alerte » : warning amber, danger red).
class LkAlert extends StatelessWidget {
  const LkAlert(this.message, {super.key, this.tone = LkTone.warning, this.icon, this.action});
  final String message;
  final LkTone tone;
  final String? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final (bg, line, fg) = switch (tone) {
      LkTone.warning => (LkColors.warning50, LkColors.warning300, LkColors.warning800),
      LkTone.danger => (LkColors.danger50, LkColors.danger500, LkColors.danger700),
      LkTone.info => (LkColors.primary50, LkColors.primary200, LkColors.primary600),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            LkIcon(
              icon ?? (tone == LkTone.danger ? 'info' : 'zap'),
              color: tone == LkTone.warning ? LkColors.warning700 : fg,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: LkText.meta.copyWith(fontWeight: FontWeight.w600, color: fg),
              ),
            ),
            if (action != null) ...[const SizedBox(width: 8), action!],
          ],
        ),
      ),
    );
  }
}

/// Grey note with an icon (« Note démo », « Note paiement »).
class LkNote extends StatelessWidget {
  const LkNote(this.message, {super.key, this.icon = 'mail'});
  final String message, icon;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 48),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: LkColors.surface,
      border: Border.all(color: LkColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        LkIcon(icon),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: LkText.caption)),
      ],
    ),
  );
}

enum LkBadgeTone { neutral, primary, success, warning, danger }

class LkBadge extends StatelessWidget {
  const LkBadge(this.text, {super.key, this.tone = LkBadgeTone.neutral});
  final String text;
  final LkBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      LkBadgeTone.neutral => (LkColors.subtle, LkColors.textSecondary),
      LkBadgeTone.primary => (LkColors.primary50, LkColors.primary500),
      LkBadgeTone.success => (LkColors.success50, LkColors.success700),
      LkBadgeTone.warning => (LkColors.warning50, LkColors.warning700),
      LkBadgeTone.danger => (LkColors.danger50, LkColors.danger700),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: LkText.badge.copyWith(color: fg)),
    );
  }
}

/// Initials on the person's stable colour (decorative: the name is always written next to it).
class LkAvatar extends StatelessWidget {
  const LkAvatar({super.key, required this.name, required this.id, this.size = 40});
  final String name, id;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: LkColors.avatars[fmt.avatarColor(id) - 1], shape: BoxShape.circle),
      child: Text(
        fmt.initials(name),
        style: TextStyle(fontFamily: 'Inter', fontSize: size * 0.4, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ),
  );
}

/// White card with a border (Penpot « Carte »), optionally tappable.
class LkCard extends StatelessWidget {
  const LkCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.color = LkColors.bg,
    this.borderColor = LkColors.border,
    this.radius = 14,
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color color, borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: borderColor),
    );
    return Material(
      color: color,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Illustration, title, text and an optional button, centred (M04b, M06b, M12…).
class LkEmptyState extends StatelessWidget {
  const LkEmptyState({super.key, required this.illustration, required this.title, required this.text, this.action});
  final String illustration, title, text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      LkIllustration(illustration),
      const SizedBox(height: 24),
      Semantics(
        header: true,
        child: Text(title, style: LkText.pageTitle, textAlign: TextAlign.center),
      ),
      const SizedBox(height: 10),
      Text(text, style: LkText.body, textAlign: TextAlign.center),
      if (action != null) ...[const SizedBox(height: 32), action!],
    ],
  );
}

/// Grey block standing for content being loaded (M14).
class LkSkeleton extends StatelessWidget {
  const LkSkeleton({super.key, required this.width, required this.height, this.radius = 6});
  final double width, height, radius;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(color: LkColors.subtle, borderRadius: BorderRadius.circular(radius)),
  );
}

/// Bottom sheet with its grip (M05c, M06c, M07b). A message still on screen would cover its buttons: it goes.
Future<T?> showLkSheet<T>(BuildContext context, WidgetBuilder builder) {
  ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: LkColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 22),
            builder(context),
          ],
        ),
      ),
    ),
  );
}
