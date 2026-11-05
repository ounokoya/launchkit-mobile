# Roadmap · mobile (Flutter)

Dépôt `launchkit-mobile` (GitHub ounokoya) : l'application mobile en Flutter, branchée sur la même API
que le web.

Légende : ✅ validé · 💡 proposé, à valider · 🚧 en cours

| Version | Thème | Statut |
|---|---|---|
| v0.1.0 | Les écrans et états du design, Android et iOS | 🚧 |
| v0.2.0 | Notifications et test interne sur les stores | 💡 |
| v0.3.0 | Hors ligne complet et biométrie | 💡 |
| v1.0.0 | Publication sur les stores | 💡 |

## v0.1.0 · Les écrans et états du design 🚧

**Écrans** ✅ (Penpot « 04 · Mobile », 390 × 844)
- M01 à M08 : connexion, inscription, choix de l'organisation, projets, projet, membres, abonnement, profil et
  langue.
- 19 états : session expirée, mot de passe incorrect, vérification de l'e-mail et lien expiré, invitation (expirée,
  mauvais compte), création d'organisation, listes vides, formulaire et suppression de projet, invitation d'un membre,
  « Bienvenue dans Pro », accès refusé, page introuvable, problème serveur, hors connexion, chargement.
- Pas d'accueil marketing ni de back-office sur mobile. Interface en français et en anglais. Pas de thème sombre.

**Fonctionnement** ✅
- Jeton de session dans le coffre sécurisé du téléphone, envoyé en `Authorization: Bearer`.
- Les liens des e-mails (vérification, invitation) ouvrent l'appli, sinon le site web.
- Hors connexion : les données déjà chargées restent affichées, avec « Réessayer ».
- APK Android de démonstration ; iOS compilé par la CI (macOS), sans publication.

**Qualité** ✅
- Tests unitaires et d'écrans, captures de référence de chaque écran : `flutter test`.
- Accessibilité dans les tests : cibles tactiles, libellés, contraste.
- Scénario A / B de bout en bout sur la vraie pile (API, worker, Mailpit) : `integration_test`, cible Linux en CI.
- Couverture ≥ 80 % en CI ; sécurité : osv-scanner, `flutter analyze`, aucun secret dans l'application.

## v0.2.0 · Notifications et test interne 💡

- Notifications : invitation reçue, organisation passée en Pro.
- Test interne sur le Play Store et TestFlight.

## v0.3.0 · Hors ligne complet et biométrie 💡

- Consultation et saisie des projets sans connexion, synchronisées au retour du réseau.
- Déverrouillage par empreinte ou visage.

## v1.0.0 · Publication 💡

- Publication sur le Play Store et l'App Store.
