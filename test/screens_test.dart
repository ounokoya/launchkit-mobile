// What each screen does, on the fake API: navigation, forms, errors, bottom sheets, polling, language.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchkit/data/api.dart';
import 'package:launchkit/data/models.dart';
import 'package:launchkit/state/session.dart';

import 'support/fake_api.dart';
import 'support/harness.dart';

/// Text containing [s]; a space also matches the non-breaking spaces of French typography.
Finder txt(String s) => find.textContaining(RegExp(RegExp.escape(s).replaceAll(' ', '[ \u00a0\u202f]')));

/// Taps the text [s]: an exact text first (so a message that quotes it is not taken), otherwise a text containing it.
Future<void> tapText(WidgetTester tester, String s) async {
  String norm(String? d) => (d ?? '').replaceAll('\u00a0', ' ').replaceAll('\u202f', ' ');
  final exact = find.byWidgetPredicate((w) => w is Text && norm(w.data) == s);
  final target = exact.evaluate().isNotEmpty ? exact.last : txt(s).last;
  await tester.ensureVisible(target);
  await tester.tap(target);
  await settle(tester);
}

Future<void> fill(WidgetTester tester, String label, String value) async {
  final field = find.descendant(
    of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
    matching: find.byType(TextField),
  );
  await tester.enterText(field.first, value);
}

/// Location of the screen on top, pushed screens included.
String where(Harness h) => h.router.state.uri.toString();

void main() {
  group('sign-in and sign-up', () {
    testWidgets('sign-in opens the projects and keeps the token', (tester) async {
      final h = await pumpApp(tester, signedIn: false, location: '/login');
      await fill(tester, 'E-mail', 'marie@demo.test');
      await fill(tester, 'Mot de passe', 'motdepasse-1');
      await tapText(tester, 'Se connecter');
      expect(where(h), '/projects');
      expect(h.store.values['session_token'], 'tok-login');
      expect(txt('Site vitrine'), findsOneWidget);
    });

    testWidgets('sign-in goes back to the page asked for', (tester) async {
      final h = await pumpApp(tester, signedIn: false, location: '/members');
      expect(where(h), '/login?next=%2Fmembers');
      await fill(tester, 'E-mail', 'marie@demo.test');
      await fill(tester, 'Mot de passe', 'motdepasse-1');
      await tapText(tester, 'Se connecter');
      expect(where(h), '/members');
    });

    testWidgets('address not verified: link to resend the e-mail', (tester) async {
      final h = await pumpApp(tester, signedIn: false, location: '/login');
      h.api.failures['login'] = const ApiError(403, 'email_not_verified', 'Vérifiez d’abord votre adresse.');
      await fill(tester, 'E-mail', 'awa@demo.test');
      await tapText(tester, 'Se connecter');
      expect(txt('Vérifiez d’abord votre adresse.'), findsOneWidget);
      await tapText(tester, 'Renvoyer l’e-mail');
      expect(where(h), '/verify-email?email=awa%40demo.test');
    });

    testWidgets('field errors from the API appear under their field', (tester) async {
      final h = await pumpApp(tester, signedIn: false, location: '/signup');
      h.api.failures['register'] = const ApiError(400, 'invalid_request', 'Certaines informations sont manquantes.', {
        'email': ['Saisissez une adresse e-mail valide.'],
        'password': ['Le mot de passe doit contenir au moins 8 caractères.'],
      });
      await tapText(tester, 'Créer mon compte');
      expect(txt('Saisissez une adresse e-mail valide.'), findsOneWidget);
      expect(txt('au moins 8 caractères'), findsOneWidget);
      expect(txt('Certaines informations sont manquantes.'), findsNothing);
      h.api.failures.clear();
      await fill(tester, 'Nom complet', 'Awa Traoré');
      await fill(tester, 'E-mail', 'awa@demo.test');
      await fill(tester, 'Mot de passe', 'motdepasse-1');
      await tapText(tester, 'Créer mon compte');
      expect(where(h), '/verify-email?email=awa%40demo.test');
      expect(txt('awa@demo.test'), findsOneWidget);
    });

    testWidgets('sign-up from an invitation: the link of the e-mail brings back to the invitation', (tester) async {
      final h = await pumpApp(tester, signedIn: false, location: '/invitations/tok');
      expect(where(h), '/login?next=%2Finvitations%2Ftok');
      await tapText(tester, 'S’inscrire');
      expect(where(h), '/signup?next=%2Finvitations%2Ftok');
      await fill(tester, 'Nom complet', 'Jean Diallo');
      await fill(tester, 'E-mail', 'marie@demo.test');
      await fill(tester, 'Mot de passe', 'motdepasse-1');
      await tapText(tester, 'Créer mon compte');
      h.router.go('/verify-email?token=lien');
      await settle(tester);
      expect(where(h), '/invitations/tok');
      expect(txt('Rejoindre Acme'), findsOneWidget);
    });

    testWidgets('« Renvoyer l’e-mail » on M09 and on an expired link (M09b)', (tester) async {
      final h = await pumpApp(tester, signedIn: false, location: '/verify-email?email=marie%40demo.test');
      await tapText(tester, 'Renvoyer l’e-mail');
      expect(h.api.calls, contains('resendVerification'));
      expect(txt('E-mail renvoyé à marie@demo.test.'), findsOneWidget);
      h.api.failures['verifyEmail'] = const ApiError(410, 'invalid_link', 'Ce lien n’est pas valable.');
      h.router.go('/verify-email?token=vieux');
      await settle(tester);
      expect(txt('Ce lien n’est pas valable.'), findsOneWidget);
      await fill(tester, 'E-mail', 'marie@demo.test');
      await tapText(tester, 'Renvoyer l’e-mail');
      expect(txt('Ce lien n’est pas valable.'), findsNothing);
      expect(txt('Ouvrir la boîte de démo'), findsOneWidget);
    });

    testWidgets('FR | EN on the sign-in screen', (tester) async {
      final h = await pumpApp(tester, signedIn: false, location: '/login');
      await tester.tap(find.bySemanticsLabel('English'));
      await settle(tester);
      expect(txt('Sign in'), findsWidgets);
      expect(h.store.values['locale'], 'en');
    });
  });

  group('organizations', () {
    const two = [
      MyOrganization(id: 'o-acme', name: 'Acme', plan: Plan.free, role: Role.owner, members: 3),
      MyOrganization(id: 'o-globex', name: 'Globex', plan: Plan.pro, role: Role.member, members: 2),
    ];

    testWidgets('M03: choose Globex, then create an organization', (tester) async {
      final h = await pumpApp(tester, api: FakeApi(orgs: two));
      expect(where(h), '/orgs');
      await tapText(tester, 'Globex');
      await tapText(tester, 'Continuer avec Globex');
      expect((where(h), h.session.orgId, h.store.values['current_org']), ('/projects', 'o-globex', 'o-globex'));
      await tester.tap(find.bySemanticsLabel('Globex · Pro'));
      await settle(tester);
      await tapText(tester, 'Créer une organisation');
      await fill(tester, 'Nom de l’organisation', 'Initech');
      await tapText(tester, 'Créer l’organisation');
      expect((where(h), h.session.org?.name), ('/projects', 'Initech'));
    });

    testWidgets('M11: a refused name stays on the form', (tester) async {
      final api = FakeApi(orgs: const [])
        ..failures['createOrg'] = const ApiError(400, 'invalid_request', 'x', {
          'name': ['Ce champ est obligatoire.'],
        });
      final h = await pumpApp(tester, api: api);
      expect(where(h), '/onboarding');
      await tapText(tester, 'Créer l’organisation');
      expect(txt('Ce champ est obligatoire.'), findsOneWidget);
    });
  });

  group('invitation', () {
    testWidgets('accept: the organization is joined and opened', (tester) async {
      final api = FakeApi(orgs: const [])
        ..invitationInfo = const InvitationInfo(
          orgId: 'o-acme',
          orgName: 'Acme',
          inviter: 'Marie Koné',
          role: Role.admin,
          email: 'marie@demo.test',
        );
      final h = await pumpApp(tester, api: api, location: '/invitations/tok');
      expect(txt('Admin'), findsOneWidget);
      api.orgList = const [MyOrganization(id: 'o-acme', name: 'Acme', plan: Plan.free, role: Role.admin, members: 3)];
      await tapText(tester, 'Accepter l’invitation');
      expect((where(h), h.session.orgId), ('/projects', 'o-acme'));
      expect(txt('Bienvenue dans Acme'), findsOneWidget);
    });

    testWidgets('decline, and an accept refused by the plan limit', (tester) async {
      final h = await pumpApp(tester, location: '/invitations/tok');
      h.api.failures['acceptInvitation'] = const ApiError(
        409,
        'plan_limit_reached',
        'Acme a atteint la limite de la formule Free.',
      );
      await tapText(tester, 'Accepter l’invitation');
      expect(txt('Acme a atteint la limite'), findsOneWidget);
      await tapText(tester, 'Refuser');
      expect(h.api.calls, contains('declineInvitation'));
      expect(where(h), '/projects');
    });

    testWidgets('wrong account: sign out, then back to the invitation after sign-in', (tester) async {
      final api = FakeApi()
        ..invitationInfo = const InvitationInfo(
          orgId: 'o-acme',
          orgName: 'Acme',
          inviter: 'Marie Koné',
          role: Role.member,
          email: 'awa@demo.test',
        );
      final h = await pumpApp(tester, api: api, location: '/invitations/tok');
      await tapText(tester, 'Se déconnecter');
      expect(where(h), '/login?next=%2Finvitations%2Ftok');
      expect(h.store.values['next_link'], '/invitations/tok');
    });
  });

  group('projects', () {
    testWidgets('list → detail → edit → saved', (tester) async {
      final h = await pumpApp(tester);
      await tapText(tester, 'Site vitrine');
      expect(where(h), '/projects/p1');
      expect(txt('28 nov. 2026'), findsOneWidget);
      expect(txt('Statut passé à « Actif »'), findsOneWidget);
      await tapText(tester, 'Modifier le projet');
      expect(txt('Site vitrine'), findsWidgets);
      await fill(tester, 'Nom du projet', 'Site vitrine 2027');
      await tester.tap(find.text('Actif').last);
      await settle(tester);
      await tester.tap(find.text('En cours').last);
      await settle(tester);
      await tapText(tester, 'Enregistrer');
      expect(where(h), '/projects/p1');
      expect(txt('Modifications enregistrées.'), findsOneWidget);
      expect(h.api.projectList.first.status, ProjectStatus.inProgress);
    });

    testWidgets('new project: refused name, then created; the 4th is refused on Free', (tester) async {
      final api = FakeApi(projects: const []);
      final h = await pumpApp(tester, api: api);
      await tapText(tester, 'Créer un projet');
      api.failures['createProject'] = const ApiError(400, 'invalid_request', 'x', {
        'name': ['Ce champ est obligatoire.'],
      });
      await tapText(tester, 'Créer le projet');
      expect(txt('Ce champ est obligatoire.'), findsOneWidget);
      api.failures['createProject'] = const ApiError(409, 'plan_limit_reached', 'Limite de la formule Free atteinte.');
      await tapText(tester, 'Créer le projet');
      expect(txt('Limite de la formule Free atteinte.'), findsOneWidget);
      api.failures.clear();
      await fill(tester, 'Nom du projet', 'Site vitrine');
      await tapText(tester, 'Créer le projet');
      expect(where(h), '/projects/p-new');
      expect(txt('Projet « Site vitrine » créé.'), findsOneWidget);
    });

    testWidgets('delete asks for a confirmation (M05c)', (tester) async {
      final h = await pumpApp(tester, location: '/projects/p1');
      await tester.tap(find.byTooltip('Supprimer'));
      await settle(tester);
      await tapText(tester, 'Annuler');
      expect(h.api.calls, isNot(contains('deleteProject')));
      await tester.tap(find.byTooltip('Supprimer'));
      await settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
      await settle(tester);
      expect(where(h), '/projects');
      expect(txt('Projet supprimé.'), findsOneWidget);
      expect(txt('Site vitrine'), findsNothing);
    });

    testWidgets('offline banner: « Réessayer » reloads (M13); unknown project: 404', (tester) async {
      final h = await pumpApp(tester);
      h.api.failures['projects'] = const ApiError(0, 'network', '');
      await tester.fling(find.text('Site vitrine'), const Offset(0, 400), 1000);
      await settle(tester);
      expect(txt('Connexion impossible'), findsOneWidget);
      h.api.failures.clear();
      await tapText(tester, 'Réessayer');
      expect(txt('Connexion impossible'), findsNothing);
      h.router.go('/projects/inconnu');
      await settle(tester);
      expect(txt('Page introuvable'), findsOneWidget);
      await tapText(tester, 'Retour à l’accueil');
      expect(where(h), '/projects');
    });
  });

  group('members', () {
    testWidgets('admin: change a role, remove a member, resend and cancel an invitation', (tester) async {
      final h = await pumpApp(tester, location: '/members');
      await tapText(tester, 'Jean Diallo');
      await tapText(tester, 'Changer le rôle · Admin');
      expect(h.api.calls, contains('changeRole:u-jean:admin'));
      expect(txt('Jean Diallo a maintenant le rôle Admin.'), findsOneWidget);
      await tapText(tester, 'Jean Diallo');
      await tapText(tester, 'Retirer de l’organisation');
      await tapText(tester, 'Retirer');
      expect(h.api.calls, contains('removeMember:u-jean'));
      await tapText(tester, 'awa@demo.test');
      await tapText(tester, 'Renvoyer l’invitation');
      expect(h.api.calls, contains('resendInvitation:i-awa'));
      await tapText(tester, 'awa@demo.test');
      await tapText(tester, 'Annuler l’invitation');
      expect(h.api.calls, contains('cancelInvitation:i-awa'));
    });

    testWidgets('invite (M06c): refused by the limit, then sent as admin', (tester) async {
      final h = await pumpApp(tester, location: '/members');
      await tapText(tester, 'Inviter un membre');
      h.api.failures['invite'] = const ApiError(409, 'plan_limit_reached', 'Votre formule Free compte déjà 3 membres.');
      await fill(tester, 'E-mail', 'yao@demo.test');
      await tapText(tester, 'Envoyer l’invitation');
      expect(txt('compte déjà 3 membres'), findsOneWidget);
      h.api.failures.clear();
      await tapText(tester, 'Gère les membres');
      await tapText(tester, 'Envoyer l’invitation');
      expect(h.api.invitationList.last.role, Role.admin);
      expect(txt('Invitation envoyée à yao@demo.test.'), findsOneWidget);
    });

    testWidgets('a member sees the list, without the actions', (tester) async {
      final api = FakeApi(
        orgs: const [MyOrganization(id: 'o-acme', name: 'Acme', plan: Plan.free, role: Role.member, members: 3)],
      );
      await pumpApp(tester, api: api, location: '/members');
      expect(txt('Inviter un membre'), findsNothing);
      expect(txt('awa@demo.test'), findsNothing);
      await tapText(tester, 'Marie Koné');
      expect(txt('Changer le rôle'), findsNothing);
    });
  });

  group('billing and profile', () {
    testWidgets('upgrade: the page waits for the worker, then « Bienvenue dans Pro »', (tester) async {
      final api = FakeApi()..billingReadsUntilPro = 2;
      final h = await pumpApp(tester, api: api, location: '/billing');
      await tapText(tester, 'Passer en Pro');
      expect(txt('Confirmation du paiement en cours'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await settle(tester);
      expect(txt('Bienvenue dans Pro'), findsOneWidget);
      await tapText(tester, 'Continuer');
      expect(h.session.org?.plan, Plan.pro);
      expect(txt('3 / illimité'), findsOneWidget);
    });

    testWidgets('upgrade refused: the API message', (tester) async {
      final h = await pumpApp(tester, location: '/billing');
      h.api.failures['checkout'] = const ApiError(409, 'already_pro', 'Cette organisation est déjà en formule Pro.');
      await tapText(tester, 'Passer en Pro');
      expect(txt('déjà en formule Pro'), findsOneWidget);
    });

    testWidgets('profile: language saved on the account, organization, sign-out', (tester) async {
      final h = await pumpApp(tester, location: '/profile');
      await tapText(tester, 'English');
      expect(txt('Sign out'), findsOneWidget);
      expect(h.api.calls, contains('updateMe:en'));
      await tapText(tester, 'Organization');
      expect(where(h), '/orgs');
      h.router.go('/profile');
      await settle(tester);
      await tapText(tester, 'Sign out');
      expect(where(h), '/login');
      expect(h.store.values.containsKey('session_token'), isFalse);
    });
  });

  group('session and errors', () {
    testWidgets('API down at start, then back (« Réessayer »)', (tester) async {
      final api = FakeApi()..failures['me'] = const ApiError(0, 'network', '');
      final h = await pumpApp(tester, api: api);
      expect(where(h), '/unavailable');
      api.failures.clear();
      await tapText(tester, 'Réessayer');
      expect(where(h), '/projects');
    });

    testWidgets('a 401 anywhere: sign-in with « Votre session a expiré », then back to the screen', (tester) async {
      final h = await pumpApp(tester, location: '/members');
      await h.container.read(sessionProvider.notifier).expire();
      await settle(tester);
      expect(where(h), '/login?next=%2Fmembers');
      expect(txt('Votre session a expiré'), findsOneWidget);
      await fill(tester, 'E-mail', 'marie@demo.test');
      await fill(tester, 'Mot de passe', 'motdepasse-1');
      await tapText(tester, 'Se connecter');
      expect(where(h), '/members');
    });

    testWidgets('server error on the list: « Réessayer » (M12c); 403 on billing for a member (M12)', (tester) async {
      final api = FakeApi()..failures['projects'] = const ApiError(500, 'server_error', '');
      await pumpApp(tester, api: api);
      expect(txt('Un problème est survenu'), findsOneWidget);
      api.failures.clear();
      await tapText(tester, 'Réessayer');
      expect(txt('Site vitrine'), findsOneWidget);
      final member = FakeApi(
        orgs: const [MyOrganization(id: 'o-acme', name: 'Acme', plan: Plan.free, role: Role.member, members: 3)],
      )..failures['billing'] = const ApiError(403, 'forbidden', '');
      await pumpApp(tester, api: member, location: '/billing');
      expect(txt('Accès refusé'), findsOneWidget);
      expect(txt('l’organisation Acme'), findsOneWidget);
    });
  });
}
