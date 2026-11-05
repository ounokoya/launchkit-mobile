// Material theme built on the LaunchKit tokens (Penpot « 02 · Design system »). No dark theme in v0.1 (H6).
import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData launchKitTheme() {
  OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: width),
  );
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: LkColors.primary500,
      primary: LkColors.primary500,
      onPrimary: Colors.white,
      surface: LkColors.bg,
      onSurface: LkColors.text,
      error: LkColors.danger700,
    ),
    scaffoldBackgroundColor: LkColors.bg,
  );
  return base.copyWith(
    dividerColor: LkColors.border,
    dividerTheme: const DividerThemeData(color: LkColors.border, thickness: 1, space: 1),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: LkColors.primary500),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: LkColors.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), // 48 px: minimum touch target
      hintStyle: LkText.input.copyWith(color: LkColors.textMuted),
      border: border(LkColors.border),
      enabledBorder: border(LkColors.border),
      focusedBorder: border(LkColors.primary500, 2),
      errorBorder: border(LkColors.danger500),
      focusedErrorBorder: border(LkColors.danger500, 2),
      errorStyle: LkText.caption.copyWith(color: LkColors.danger700),
      errorMaxLines: 3,
      prefixIconColor: LkColors.textSecondary,
      suffixIconColor: LkColors.textSecondary,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: LkColors.bg,
      surfaceTintColor: Colors.transparent,
      indicatorColor: LkColors.primary50,
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? LkText.nav.copyWith(fontWeight: FontWeight.w600, color: LkColors.primary500)
            : LkText.nav,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: LkColors.bg,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: Color(0x800F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      // Above the action button at the bottom of the screens (48 px + 16 px), never over it.
      insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      backgroundColor: LkColors.text,
      contentTextStyle: LkText.label.copyWith(color: Colors.white),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: LkColors.primary500),
  );
}
