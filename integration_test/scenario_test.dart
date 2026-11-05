// Scenario A / B (spec mobile.md) on the real stack: API, Rust worker, ArangoDB and Mailpit (server/compose.yaml).
// The links are read from the e-mails received in Mailpit and opened in the app as the system would open them.
//   xvfb-run flutter test integration_test -d linux            (Linux target, CI)
//   flutter test integration_test -d <emulator> --dart-define=API_URL=http://10.0.2.2:5080 --dart-define=MAILPIT_URL=http://10.0.2.2:8025
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:launchkit/app.dart';
import 'package:launchkit/config.dart';
import 'package:launchkit/router.dart';
import 'package:launchkit/state/session.dart';

const password = 'motdepasse-1';
final mailpit = Dio(BaseOptions(baseUrl: '${Config.mailpitUrl}/api/v1'));

Finder txt(String s) => find.textContaining(RegExp(RegExp.escape(s).replaceAll(' ', '[   ]')));

/// Real time here: waits until [finder] shows up (API, worker), at most [seconds].
Future<void> waitFor(WidgetTester tester, Finder finder, {int seconds = 30}) async {
  final end = DateTime.now().add(Duration(seconds: seconds));
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) throw TestFailure('Not shown after $seconds s: $finder');
    await tester.pump(const Duration(milliseconds: 200));
  }
  await tester.pumpAndSettle();
}

Future<void> tap(WidgetTester tester, String text) async {
  await waitFor(tester, txt(text));
  // A confirmation still on screen (4 s) must not take the tap meant for the button.
  tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger)).clearSnackBars();
  await tester.pumpAndSettle();
  await tester.ensureVisible(txt(text).last);
  await tester.tap(txt(text).last);
  await tester.pumpAndSettle();
}

Future<void> fill(WidgetTester tester, String label, String value) async {
  await waitFor(tester, find.text(label));
  final field = find.descendant(
    of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
    matching: find.byType(TextField),
  );
  await tester.enterText(field.first, value);
}

/// Path of the link of the last e-mail to [to] whose subject contains [subject] (« /verify-email?token=… »).
Future<String> linkFromMail(String to, String subject, RegExp link) async {
  final end = DateTime.now().add(const Duration(seconds: 30));
  while (DateTime.now().isBefore(end)) {
    final search = await mailpit.get<Map<String, dynamic>>('/search', queryParameters: {'query': 'to:"$to"'});
    final hit = (search.data!['messages'] as List).cast<Map<String, dynamic>>().where(
      (m) => '${m['Subject']}'.contains(subject),
    );
    if (hit.isNotEmpty) {
      final message = await mailpit.get<Map<String, dynamic>>('/message/${hit.first['ID']}');
      return link.firstMatch('${message.data!['Text']}')!.group(0)!;
    }
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
  throw TestFailure('No e-mail « $subject » for $to');
}

Future<void> signUp(WidgetTester tester, String name, String email) async {
  await fill(tester, 'Nom complet', name);
  await fill(tester, 'E-mail', email);
  await fill(tester, 'Mot de passe', password);
  await tap(tester, 'Créer mon compte');
  await waitFor(tester, txt('Vérifiez votre e-mail'));
}

Future<void> signIn(WidgetTester tester, String email) async {
  await fill(tester, 'E-mail', email);
  await fill(tester, 'Mot de passe', password);
  await tap(tester, 'Se connecter');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('A and B go through the whole journey on mobile', (tester) async {
    await initializeDateFormatting();
    final run = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final emailA = 'marie-m-$run@demo.test', emailB = 'jean-m-$run@demo.test';
    // No keyring on the Linux test target: the token is kept in memory for this run.
    final container = ProviderContainer(
      overrides: [
        secretStoreProvider.overrideWithValue(MemorySecretStore({'locale': 'fr'})),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const LaunchKitApp()));
    final router = container.read(routerProvider);
    Future<void> openLink(String path) async {
      router.go(path);
      await tester.pumpAndSettle();
    }

    // A signs up, opens the link of the e-mail: signed in, creates Acme (M02, M09, M11).
    await tap(tester, 'S’inscrire');
    await signUp(tester, 'Marie Koné', emailA);
    await openLink(await linkFromMail(emailA, 'adresse', RegExp(r'/verify-email\?token=[\w%-]+')));
    await fill(tester, 'Nom de l’organisation', 'Acme $run');
    await tap(tester, 'Créer l’organisation');
    await waitFor(tester, txt('Aucun projet pour l’instant'));

    // Three projects; the fourth is refused by the Free limit (M04b, M05b, M04).
    for (final name in ['Site vitrine', 'App mobile', 'Tableau de bord']) {
      await openLink('/projects/new');
      await fill(tester, 'Nom du projet', name);
      await tap(tester, 'Créer le projet');
      await waitFor(tester, find.text(name));
    }
    await openLink('/projects');
    await waitFor(tester, txt('Free : 3 projets sur 3'));
    await openLink('/projects/new');
    await fill(tester, 'Nom du projet', 'Quatrième');
    await tap(tester, 'Créer le projet');
    await waitFor(tester, txt('limite'));

    // A invites B, then signs out (M06c, M08).
    await openLink('/members');
    await tap(tester, 'Inviter un membre');
    await fill(tester, 'E-mail', emailB);
    await tap(tester, 'Envoyer l’invitation');
    await waitFor(tester, txt(emailB));
    final invitation = await linkFromMail(emailB, 'invite', RegExp(r'/invitations/[\w%-]+'));
    await openLink('/profile');
    await tap(tester, 'Se déconnecter');

    // B opens the invitation: sign-in asked, B signs up, the link of the e-mail brings back to the invitation (M10).
    await openLink(invitation);
    await tap(tester, 'S’inscrire');
    await signUp(tester, 'Jean Diallo', emailB);
    await openLink(await linkFromMail(emailB, 'adresse', RegExp(r'/verify-email\?token=[\w%-]+')));
    await tap(tester, 'Accepter l’invitation');
    await waitFor(tester, find.text('Site vitrine'));
    // B is a member: billing is refused (M12).
    await openLink('/billing');
    await waitFor(tester, txt('Accès refusé'));
    await openLink('/profile');
    await tap(tester, 'Se déconnecter');

    // A comes back and upgrades: the Rust worker handles the simulated payment, « Bienvenue dans Pro » (M07b).
    await signIn(tester, emailA);
    await openLink('/billing');
    await tap(tester, 'Passer en Pro');
    await waitFor(tester, txt('Bienvenue dans Pro'), seconds: 60);
    await tap(tester, 'Continuer');

    // The fourth project is now accepted.
    await openLink('/projects/new');
    await fill(tester, 'Nom du projet', 'Quatrième');
    await tap(tester, 'Créer le projet');
    await waitFor(tester, find.text('Quatrième'));
  });
}
