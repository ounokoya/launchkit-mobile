// Design tokens of LaunchKit: the same 33 colours as the Penpot library and web/src/lib/styles/tokens.css (ADR-0013).
import 'package:flutter/painting.dart';

abstract final class LkColors {
  static const primary50 = Color(0xFFEEF2FF);
  static const primary100 = Color(0xFFE0E7FF);
  static const primary200 = Color(0xFFC7D2FE);
  static const primary300 = Color(0xFFA5B4FC);
  static const primary400 = Color(0xFF818CF8);
  static const primary500 = Color(0xFF4F46E5);
  static const primary600 = Color(0xFF4338CA);

  static const text = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textMuted = Color(0xFF64748B);
  static const textOnDark = Color(0xFFCBD5E1);
  static const textMutedOnDark = Color(0xFF94A3B8);

  static const bg = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF8FAFC);
  static const subtle = Color(0xFFF1F5F9);
  static const border = Color(0xFFE2E8F0);

  static const success50 = Color(0xFFECFDF5);
  static const success500 = Color(0xFF10B981);
  static const success700 = Color(0xFF047857);
  static const warning50 = Color(0xFFFFFBEB);
  static const warning300 = Color(0xFFFCD34D);
  static const warning500 = Color(0xFFF59E0B);
  static const warning700 = Color(0xFFB45309);
  static const warning800 = Color(0xFF92400E);
  static const danger50 = Color(0xFFFEF2F2);
  static const danger500 = Color(0xFFEF4444);
  static const danger600 = Color(0xFFDC2626);
  static const danger700 = Color(0xFFB91C1C);

  /// Avatars: the 700 shade of each hue, so white initials reach 4.5:1 (index 1 to 5, see avatarColor()).
  static const avatars = [
    Color(0xFF0369A1),
    Color(0xFF047857),
    Color(0xFFB45309),
    Color(0xFF0F172A),
    Color(0xFFB91C1C),
  ];
}

/// Text styles of the mobile screens (Penpot « 04 · Mobile »), Inter.
abstract final class LkText {
  static const _inter = 'Inter';
  static TextStyle _s(double size, FontWeight weight, Color color, [double height = 1.3]) =>
      TextStyle(fontFamily: _inter, fontSize: size, fontWeight: weight, color: color, height: height);

  static final authTitle = _s(30, FontWeight.w700, LkColors.text, 1.2);
  static final screenTitle = _s(28, FontWeight.w700, LkColors.text, 1.2);
  static final pageTitle = _s(20, FontWeight.w700, LkColors.text);
  static final sectionTitle = _s(16, FontWeight.w700, LkColors.text);
  static final subtitle = _s(15, FontWeight.w400, LkColors.textSecondary, 1.45);
  static final body = _s(15, FontWeight.w400, LkColors.textSecondary, 1.45);
  static final bodyStrong = _s(15, FontWeight.w600, LkColors.text);
  static final rowTitle = _s(15, FontWeight.w600, LkColors.text);
  static final cardTitle = _s(16, FontWeight.w700, LkColors.text);
  static final label = _s(14, FontWeight.w500, LkColors.text);
  static final input = _s(15, FontWeight.w400, LkColors.text);
  static final meta = _s(13, FontWeight.w400, LkColors.textSecondary);
  static final metaStrong = _s(13, FontWeight.w500, LkColors.textSecondary);
  static final caption = _s(12, FontWeight.w500, LkColors.textSecondary, 1.4);
  static final overline = _s(12, FontWeight.w700, LkColors.textMuted);
  static final button = _s(15, FontWeight.w600, LkColors.bg);
  static final badge = _s(12, FontWeight.w600, LkColors.textSecondary);
  static final nav = _s(11, FontWeight.w500, LkColors.textSecondary);
}
