// Accessibility of the main screens (ADR-0013, spec mobile.md): touch targets (Android 48 dp, iOS 44 pt), every
// tappable element has a label, text contrast.
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  final screens = {
    'connexion': (false, '/login'),
    'inscription': (false, '/signup'),
    'vérification': (false, '/verify-email?email=marie%40demo.test'),
    'projets': (true, '/projects'),
    'projet': (true, '/projects/p1'),
    'formulaire': (true, '/projects/new'),
    'membres': (true, '/members'),
    'abonnement': (true, '/billing'),
    'profil': (true, '/profile'),
    'invitation': (true, '/invitations/tok'),
  };
  for (final MapEntry(key: name, value: (signedIn, location)) in screens.entries) {
    testWidgets('$name : cibles, libellés, contraste', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, signedIn: signedIn, location: location);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }
}
