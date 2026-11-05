// Presentation helpers shared by the screens: same rules as web/src/lib/format.ts (pure functions, unit tested).
import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';

/// « il y a 2 h », « hier »… from an ISO date.
String relativeTime(AppLocalizations t, String iso, {DateTime? now}) {
  final elapsed = (now ?? DateTime.now()).toUtc().difference(DateTime.parse(iso).toUtc());
  final minutes = elapsed.inMinutes < 0 ? 0 : elapsed.inMinutes;
  final hours = minutes ~/ 60;
  final days = hours ~/ 24;
  if (minutes < 1) return t.commonTimeJustNow;
  if (hours < 1) return t.commonTimeMinutesAgo('$minutes');
  if (days < 1) return t.commonTimeHoursAgo('$hours');
  if (days == 1) return t.commonTimeYesterday;
  return t.commonTimeDaysAgo(days);
}

DateTime _date(String value) =>
    value.length == 10 ? DateTime.parse('${value}T00:00:00Z') : DateTime.parse(value).toUtc();

/// « 28 novembre 2026 » / « November 28, 2026 ».
String longDate(String value, String locale) =>
    DateFormat(locale == 'fr' ? 'd MMMM y' : 'MMMM d, y', locale).format(_date(value));

/// « 28 nov. 2026 » / « Nov 28, 2026 ».
String shortDate(String value, String locale) =>
    DateFormat(locale == 'fr' ? 'd MMM y' : 'MMM d, y', locale).format(_date(value));

String initials(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return '?';
  final letters = words.length == 1
      ? words.first.substring(0, words.first.length < 2 ? words.first.length : 2)
      : words.first[0] + words.last[0];
  return letters.toUpperCase();
}

/// Stable colour (1…5) for a person or an organization, so the same id keeps the same colour (as on the web).
int avatarColor(String id) {
  var hash = 0;
  for (final unit in id.codeUnits) {
    hash = (hash * 31 + unit) & 0xFFFFFFFF;
  }
  return hash % 5 + 1;
}

String price(int cents, String currency, String locale) {
  final format = NumberFormat.simpleCurrency(
    locale: locale == 'fr' ? 'fr_FR' : 'en_US',
    name: currency,
    decimalDigits: cents % 100 == 0 ? 0 : 2,
  );
  return format.format(cents / 100);
}
