// Build-time settings (spec mobile.md): `flutter run --dart-define=API_URL=http://10.0.2.2:5080` on the Android emulator.
class Config {
  static const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5080');
  static const webUrl = String.fromEnvironment('WEB_URL', defaultValue: 'http://localhost:5173');
  static const mailpitUrl = String.fromEnvironment('MAILPIT_URL', defaultValue: 'http://localhost:8025');
}
