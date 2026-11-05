// Reference captures of every mobile screen and state (M01 to M14), 390 × 844 with Inter, on the demo data of the
// Penpot screens. `flutter test --update-goldens test/goldens_test.dart` writes them again after a deliberate change.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchkit/data/api.dart';
import 'package:launchkit/data/models.dart';
import 'package:launchkit/state/session.dart';

import 'support/fake_api.dart';
import 'support/harness.dart';

/// The projects never arrive: the loading state stays on screen (M14).
class SlowApi extends FakeApi {
  @override
  Future<List<Project>> projects(String org) => Completer<List<Project>>().future;
}

Future<void> shot(WidgetTester tester, String name) =>
    expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));

const _twoOrgs = [
  MyOrganization(id: 'o-acme', name: 'Acme', plan: Plan.free, role: Role.owner, members: 3),
  MyOrganization(id: 'o-globex', name: 'Globex', plan: Plan.pro, role: Role.member, members: 2),
];

void main() {
  testWidgets('M01 connexion, M01b session expirée, M01c mot de passe incorrect', (tester) async {
    final h = await pumpApp(tester, signedIn: false, location: '/login');
    await shot(tester, 'm01_connexion');
    await h.container.read(sessionProvider.notifier).expire();
    await settle(tester);
    await shot(tester, 'm01b_session_expiree');
    h.api.failures['login'] = const ApiError(401, 'login_failed', 'E-mail ou mot de passe incorrect.');
    await tester.enterText(find.byType(TextField).first, 'marie@demo.test');
    await tester.enterText(find.byType(TextField).last, 'motdepasse');
    await tester.tap(find.text('Se connecter'));
    await settle(tester);
    await shot(tester, 'm01c_mot_de_passe_incorrect');
  });

  testWidgets('M02 inscription, M09 vérifiez votre e-mail, M09b lien expiré', (tester) async {
    final h = await pumpApp(tester, signedIn: false, location: '/signup');
    await shot(tester, 'm02_inscription');
    h.router.go('/verify-email?email=marie%40demo.test');
    await settle(tester);
    await shot(tester, 'm09_verifiez_email');
    h.api.failures['verifyEmail'] = const ApiError(
      410,
      'invalid_link',
      'Ce lien n’est pas valable. Demandez-en un nouveau.',
    );
    h.router.go('/verify-email?token=perime');
    await settle(tester);
    await shot(tester, 'm09b_lien_expire');
  });

  testWidgets('M03 choisir l’organisation, M11 créer son organisation', (tester) async {
    await pumpApp(tester, api: FakeApi(orgs: _twoOrgs));
    await shot(tester, 'm03_organisations');
    await pumpApp(tester, api: FakeApi(orgs: const []));
    await shot(tester, 'm11_creer_organisation');
  });

  testWidgets('M04 projets (limite Free), M04b liste vide, M13 hors connexion, M14 chargement, M12c problème serveur', (
    tester,
  ) async {
    final h = await pumpApp(tester);
    await shot(tester, 'm04_projets');
    h.api.failures['projects'] = const ApiError(0, 'network', '');
    await tester.fling(find.text('Site vitrine'), const Offset(0, 400), 1000);
    await settle(tester);
    await shot(tester, 'm13_hors_connexion');
    await pumpApp(tester, api: FakeApi(projects: const []));
    await shot(tester, 'm04b_projets_vide');
    await pumpApp(tester, api: SlowApi());
    await shot(tester, 'm14_chargement');
    await pumpApp(tester, api: FakeApi()..failures['projects'] = const ApiError(500, 'server_error', ''));
    await shot(tester, 'm12c_probleme_serveur');
  });

  testWidgets('M05 projet, M05c supprimer, M05b nouveau projet', (tester) async {
    final h = await pumpApp(tester, location: '/projects/p1');
    await shot(tester, 'm05_projet');
    await tester.tap(find.byTooltip('Supprimer'));
    await settle(tester);
    await shot(tester, 'm05c_supprimer_projet');
    h.router.go('/projects/new');
    await settle(tester);
    await shot(tester, 'm05b_nouveau_projet');
  });

  testWidgets('M06 membres, M06c inviter, M06b un seul membre', (tester) async {
    await pumpApp(tester, location: '/members');
    await shot(tester, 'm06_membres');
    await tester.tap(find.text('Inviter un membre'));
    await settle(tester);
    await shot(tester, 'm06c_inviter');
    final alone = FakeApi()
      ..memberList = const [Member(id: 'u-marie', name: 'Marie Koné', email: 'marie@demo.test', role: Role.owner)]
      ..invitationList = const [];
    await pumpApp(tester, api: alone, location: '/members');
    await shot(tester, 'm06b_un_seul_membre');
  });

  testWidgets('M07 abonnement, M07b bienvenue dans Pro, M12 accès refusé', (tester) async {
    await pumpApp(tester, location: '/billing');
    await shot(tester, 'm07_abonnement');
    await tester.tap(find.text('Passer en Pro'));
    await settle(tester);
    await tester.pump(const Duration(seconds: 2));
    await settle(tester);
    await shot(tester, 'm07b_bienvenue_pro');
    final member = FakeApi(
      orgs: const [MyOrganization(id: 'o-acme', name: 'Acme', plan: Plan.free, role: Role.member, members: 3)],
    )..failures['billing'] = const ApiError(403, 'forbidden', '');
    await pumpApp(tester, api: member, location: '/billing');
    await shot(tester, 'm12_acces_refuse');
  });

  testWidgets('M08 profil, M12b page introuvable', (tester) async {
    final h = await pumpApp(tester, location: '/profile');
    await shot(tester, 'm08_profil');
    h.router.go('/app/acme/inconnu');
    await settle(tester);
    await shot(tester, 'm12b_page_introuvable');
  });

  testWidgets('M10 invitation, M10b expirée, M10c mauvais compte', (tester) async {
    await pumpApp(tester, location: '/invitations/tok');
    await shot(tester, 'm10_invitation');
    final expired = FakeApi()
      ..failures['invitation'] = const ApiError(
        410,
        'invitation_unavailable',
        'Cette invitation a expiré. Demandez à Marie Koné de vous en envoyer une nouvelle.',
      );
    await pumpApp(tester, api: expired, location: '/invitations/tok');
    await shot(tester, 'm10b_invitation_expiree');
    final other = FakeApi()
      ..invitationInfo = const InvitationInfo(
        orgId: 'o-acme',
        orgName: 'Acme',
        inviter: 'Marie Koné',
        role: Role.member,
        email: 'awa@demo.test',
      );
    await pumpApp(tester, api: other, location: '/invitations/tok');
    await shot(tester, 'm10c_mauvais_compte');
  });
}
