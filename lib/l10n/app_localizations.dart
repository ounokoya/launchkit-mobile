import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('fr')];

  /// No description provided for @commonNavDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get commonNavDashboard;

  /// No description provided for @commonNavProjects.
  ///
  /// In fr, this message translates to:
  /// **'Projets'**
  String get commonNavProjects;

  /// No description provided for @commonNavMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get commonNavMembers;

  /// No description provided for @commonNavBilling.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get commonNavBilling;

  /// No description provided for @commonNavSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get commonNavSettings;

  /// No description provided for @commonNavProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get commonNavProfile;

  /// No description provided for @commonSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher…'**
  String get commonSearch;

  /// No description provided for @commonLanguageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get commonLanguageLabel;

  /// No description provided for @commonLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get commonLanguageFr;

  /// No description provided for @commonLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get commonLanguageEn;

  /// No description provided for @commonPlanFree.
  ///
  /// In fr, this message translates to:
  /// **'Free'**
  String get commonPlanFree;

  /// No description provided for @commonPlanPro.
  ///
  /// In fr, this message translates to:
  /// **'Pro'**
  String get commonPlanPro;

  /// No description provided for @commonPlanLabel.
  ///
  /// In fr, this message translates to:
  /// **'Formule {plan}'**
  String commonPlanLabel(String plan);

  /// No description provided for @commonRoleOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire'**
  String get commonRoleOwner;

  /// No description provided for @commonRoleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Admin'**
  String get commonRoleAdmin;

  /// No description provided for @commonRoleMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre'**
  String get commonRoleMember;

  /// No description provided for @commonRoleAdminDesc.
  ///
  /// In fr, this message translates to:
  /// **'Gère les membres et l’abonnement'**
  String get commonRoleAdminDesc;

  /// No description provided for @commonRoleMemberDesc.
  ///
  /// In fr, this message translates to:
  /// **'Travaille sur les projets'**
  String get commonRoleMemberDesc;

  /// No description provided for @commonStatusActive.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get commonStatusActive;

  /// No description provided for @commonStatusInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get commonStatusInProgress;

  /// No description provided for @commonStatusDraft.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon'**
  String get commonStatusDraft;

  /// No description provided for @commonStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get commonStatusPending;

  /// No description provided for @commonActionSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonActionSave;

  /// No description provided for @commonActionCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonActionCancel;

  /// No description provided for @commonActionContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get commonActionContinue;

  /// No description provided for @commonActionEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get commonActionEdit;

  /// No description provided for @commonActionDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get commonActionDelete;

  /// No description provided for @commonActionClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonActionClose;

  /// No description provided for @commonActionRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonActionRetry;

  /// No description provided for @commonActionSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get commonActionSeeAll;

  /// No description provided for @commonActionBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l’accueil'**
  String get commonActionBackHome;

  /// No description provided for @commonActionBackDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Retour au tableau de bord'**
  String get commonActionBackDashboard;

  /// No description provided for @commonActionSignOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get commonActionSignOut;

  /// No description provided for @commonTimeJustNow.
  ///
  /// In fr, this message translates to:
  /// **'à l’instant'**
  String get commonTimeJustNow;

  /// No description provided for @commonTimeMinutesAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {n} min'**
  String commonTimeMinutesAgo(String n);

  /// No description provided for @commonTimeHoursAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {n} h'**
  String commonTimeHoursAgo(String n);

  /// No description provided for @commonTimeYesterday.
  ///
  /// In fr, this message translates to:
  /// **'hier'**
  String get commonTimeYesterday;

  /// No description provided for @commonTimeToday.
  ///
  /// In fr, this message translates to:
  /// **'aujourd’hui'**
  String get commonTimeToday;

  /// No description provided for @commonTimeDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {n, plural, one {{n} jour} other {{n} jours}}'**
  String commonTimeDaysAgo(int n);

  /// No description provided for @commonMetaEdited.
  ///
  /// In fr, this message translates to:
  /// **'Modifié {when}'**
  String commonMetaEdited(String when);

  /// No description provided for @commonMetaCreated.
  ///
  /// In fr, this message translates to:
  /// **'Créé {when}'**
  String commonMetaCreated(String when);

  /// No description provided for @commonDemoEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Démo : utilisez une adresse inventée, comme marie@demo.test'**
  String get commonDemoEmailHint;

  /// No description provided for @commonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get commonLoading;

  /// No description provided for @commonA11ySwitchLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Changer de langue'**
  String get commonA11ySwitchLanguage;

  /// No description provided for @commonA11ySwitchOrg.
  ///
  /// In fr, this message translates to:
  /// **'Changer d’organisation'**
  String get commonA11ySwitchOrg;

  /// No description provided for @commonA11yNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get commonA11yNotifications;

  /// No description provided for @commonA11yAccountMenu.
  ///
  /// In fr, this message translates to:
  /// **'Menu du compte'**
  String get commonA11yAccountMenu;

  /// No description provided for @commonA11yOpenMenu.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le menu'**
  String get commonA11yOpenMenu;

  /// No description provided for @homeNavFeatures.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalités'**
  String get homeNavFeatures;

  /// No description provided for @homeNavPricing.
  ///
  /// In fr, this message translates to:
  /// **'Formules'**
  String get homeNavPricing;

  /// No description provided for @homeNavMethod.
  ///
  /// In fr, this message translates to:
  /// **'Méthode'**
  String get homeNavMethod;

  /// No description provided for @homeNavSource.
  ///
  /// In fr, this message translates to:
  /// **'Code source'**
  String get homeNavSource;

  /// No description provided for @homeNavLogin.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get homeNavLogin;

  /// No description provided for @homeCtaTryDemo.
  ///
  /// In fr, this message translates to:
  /// **'Essayer la démo'**
  String get homeCtaTryDemo;

  /// No description provided for @homeCtaViewCode.
  ///
  /// In fr, this message translates to:
  /// **'Voir le code'**
  String get homeCtaViewCode;

  /// No description provided for @homeHeroBadge.
  ///
  /// In fr, this message translates to:
  /// **'Kit de démarrage SaaS · code ouvert'**
  String get homeHeroBadge;

  /// No description provided for @homeHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre MVP en 2 semaines, sur une base déjà prête'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Comptes, organisations, rôles, abonnements et back-office sont déjà en place. Je pars de ce kit pour livrer votre produit vite, au forfait.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeHeroDemoNote.
  ///
  /// In fr, this message translates to:
  /// **'Démo : inscrivez-vous avec une adresse inventée, comme marie@demo.test'**
  String get homeHeroDemoNote;

  /// No description provided for @homePreviewProject1.
  ///
  /// In fr, this message translates to:
  /// **'Site vitrine'**
  String get homePreviewProject1;

  /// No description provided for @homePreviewProject2.
  ///
  /// In fr, this message translates to:
  /// **'App mobile'**
  String get homePreviewProject2;

  /// No description provided for @homePreviewProject3.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get homePreviewProject3;

  /// No description provided for @homePreviewEditedRecently.
  ///
  /// In fr, this message translates to:
  /// **'Modifié récemment'**
  String get homePreviewEditedRecently;

  /// No description provided for @homeFeaturesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout ce qu’un SaaS demande, déjà fait'**
  String get homeFeaturesTitle;

  /// No description provided for @homeFeaturesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'On se concentre directement sur ce qui rend votre produit unique.'**
  String get homeFeaturesSubtitle;

  /// No description provided for @homeFeaturesAccountsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comptes et connexion'**
  String get homeFeaturesAccountsTitle;

  /// No description provided for @homeFeaturesAccountsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Inscription, connexion et vérification de l’e-mail.'**
  String get homeFeaturesAccountsDesc;

  /// No description provided for @homeFeaturesTenancyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Multi-entreprise'**
  String get homeFeaturesTenancyTitle;

  /// No description provided for @homeFeaturesTenancyDesc.
  ///
  /// In fr, this message translates to:
  /// **'Chaque client a son organisation et ses données.'**
  String get homeFeaturesTenancyDesc;

  /// No description provided for @homeFeaturesRolesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rôles et invitations'**
  String get homeFeaturesRolesTitle;

  /// No description provided for @homeFeaturesRolesDesc.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire, admin et membre, invitations par e-mail.'**
  String get homeFeaturesRolesDesc;

  /// No description provided for @homeFeaturesPlansTitle.
  ///
  /// In fr, this message translates to:
  /// **'Formules Free et Pro'**
  String get homeFeaturesPlansTitle;

  /// No description provided for @homeFeaturesPlansDesc.
  ///
  /// In fr, this message translates to:
  /// **'Limites par formule et paiement interchangeable.'**
  String get homeFeaturesPlansDesc;

  /// No description provided for @homeFeaturesBackofficeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Back-office'**
  String get homeFeaturesBackofficeTitle;

  /// No description provided for @homeFeaturesBackofficeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vue super-admin sur les organisations et les utilisateurs.'**
  String get homeFeaturesBackofficeDesc;

  /// No description provided for @homeFeaturesI18nTitle.
  ///
  /// In fr, this message translates to:
  /// **'Français et anglais'**
  String get homeFeaturesI18nTitle;

  /// No description provided for @homeFeaturesI18nDesc.
  ///
  /// In fr, this message translates to:
  /// **'Interface bilingue, prête pour d’autres langues.'**
  String get homeFeaturesI18nDesc;

  /// No description provided for @homeStackLabel.
  ///
  /// In fr, this message translates to:
  /// **'Stack'**
  String get homeStackLabel;

  /// No description provided for @homeStackRustWorker.
  ///
  /// In fr, this message translates to:
  /// **'Worker Rust'**
  String get homeStackRustWorker;

  /// No description provided for @homeMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma méthode, en 4 étapes'**
  String get homeMethodTitle;

  /// No description provided for @homeMethodSpecTitle.
  ///
  /// In fr, this message translates to:
  /// **'Spec'**
  String get homeMethodSpecTitle;

  /// No description provided for @homeMethodSpecDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ce qu’on construit, écrit et validé avec vous.'**
  String get homeMethodSpecDesc;

  /// No description provided for @homeMethodDecisionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Décisions'**
  String get homeMethodDecisionsTitle;

  /// No description provided for @homeMethodDecisionsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Chaque choix technique est noté et justifié.'**
  String get homeMethodDecisionsDesc;

  /// No description provided for @homeMethodTestsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tests'**
  String get homeMethodTestsTitle;

  /// No description provided for @homeMethodTestsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les tests découlent directement de la spec.'**
  String get homeMethodTestsDesc;

  /// No description provided for @homeMethodChangelogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Changelog'**
  String get homeMethodChangelogTitle;

  /// No description provided for @homeMethodChangelogDesc.
  ///
  /// In fr, this message translates to:
  /// **'Chaque livraison est versionnée et documentée.'**
  String get homeMethodChangelogDesc;

  /// No description provided for @homeFooterCta.
  ///
  /// In fr, this message translates to:
  /// **'Besoin d’un MVP ? Parlons de votre projet.'**
  String get homeFooterCta;

  /// No description provided for @homeFooterContact.
  ///
  /// In fr, this message translates to:
  /// **'Me contacter'**
  String get homeFooterContact;

  /// No description provided for @homeFooterLegal.
  ///
  /// In fr, this message translates to:
  /// **'© {year} LaunchKit · démo portfolio · FR / EN'**
  String homeFooterLegal(String year);

  /// No description provided for @homeFooterAndroid.
  ///
  /// In fr, this message translates to:
  /// **'Appli Android'**
  String get homeFooterAndroid;

  /// No description provided for @authSideSignupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lancez votre SaaS sur une base déjà prête'**
  String get authSideSignupTitle;

  /// No description provided for @authSideSignupPoint1.
  ///
  /// In fr, this message translates to:
  /// **'Comptes et organisations'**
  String get authSideSignupPoint1;

  /// No description provided for @authSideSignupPoint2.
  ///
  /// In fr, this message translates to:
  /// **'Rôles et invitations'**
  String get authSideSignupPoint2;

  /// No description provided for @authSideSignupPoint3.
  ///
  /// In fr, this message translates to:
  /// **'Formules Free et Pro'**
  String get authSideSignupPoint3;

  /// No description provided for @authSideLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour parmi nous'**
  String get authSideLoginTitle;

  /// No description provided for @authSideLoginPoint1.
  ///
  /// In fr, this message translates to:
  /// **'Reprenez là où vous en étiez'**
  String get authSideLoginPoint1;

  /// No description provided for @authSideLoginPoint2.
  ///
  /// In fr, this message translates to:
  /// **'Changez d’organisation en un clic'**
  String get authSideLoginPoint2;

  /// No description provided for @authSideLoginPoint3.
  ///
  /// In fr, this message translates to:
  /// **'Interface en français ou en anglais'**
  String get authSideLoginPoint3;

  /// No description provided for @authFieldFullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get authFieldFullName;

  /// No description provided for @authFieldEmail.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get authFieldEmail;

  /// No description provided for @authFieldPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authFieldPassword;

  /// No description provided for @authSignupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit, sans carte bancaire.'**
  String get authSignupSubtitle;

  /// No description provided for @authSignupEmailHelp.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez une adresse inventée : la démo n’envoie ses e-mails que dans une boîte de test.'**
  String get authSignupEmailHelp;

  /// No description provided for @authSignupPasswordHelp.
  ///
  /// In fr, this message translates to:
  /// **'{min} caractères minimum.'**
  String authSignupPasswordHelp(String min);

  /// No description provided for @authSignupSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get authSignupSubmit;

  /// No description provided for @authSignupHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get authSignupHaveAccount;

  /// No description provided for @authSignupGoLogin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authSignupGoLogin;

  /// No description provided for @authLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous à votre espace LaunchKit.'**
  String get authLoginSubtitle;

  /// No description provided for @authLoginSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginSubmit;

  /// No description provided for @authLoginNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get authLoginNoAccount;

  /// No description provided for @authLoginGoSignup.
  ///
  /// In fr, this message translates to:
  /// **'S’inscrire'**
  String get authLoginGoSignup;

  /// No description provided for @authVerifyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre e-mail'**
  String get authVerifyTitle;

  /// No description provided for @authVerifyText.
  ///
  /// In fr, this message translates to:
  /// **'Nous avons envoyé un lien de vérification à {email}. Cliquez dessus pour activer votre compte.'**
  String authVerifyText(String email);

  /// No description provided for @authVerifyDemoNote.
  ///
  /// In fr, this message translates to:
  /// **'Démo : l’e-mail arrive dans la boîte de test Mailpit.'**
  String get authVerifyDemoNote;

  /// No description provided for @authVerifyOpenInbox.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir la boîte de démo'**
  String get authVerifyOpenInbox;

  /// No description provided for @authVerifyResend.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer l’e-mail'**
  String get authVerifyResend;

  /// No description provided for @authVerifyResent.
  ///
  /// In fr, this message translates to:
  /// **'E-mail renvoyé à {email}.'**
  String authVerifyResent(String email);

  /// No description provided for @authVerifyVerified.
  ///
  /// In fr, this message translates to:
  /// **'Adresse vérifiée. Bienvenue !'**
  String get authVerifyVerified;

  /// No description provided for @authVerifyLinkExpired.
  ///
  /// In fr, this message translates to:
  /// **'Ce lien a expiré. Demandez-en un nouveau depuis l’écran de vérification.'**
  String get authVerifyLinkExpired;

  /// No description provided for @onboardingStep.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String onboardingStep(String current, String total);

  /// No description provided for @onboardingOrgTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre organisation'**
  String get onboardingOrgTitle;

  /// No description provided for @onboardingOrgText.
  ///
  /// In fr, this message translates to:
  /// **'Votre entreprise, votre équipe et vos projets au même endroit. Vous en serez le propriétaire.'**
  String get onboardingOrgText;

  /// No description provided for @onboardingOrgName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l’organisation'**
  String get onboardingOrgName;

  /// No description provided for @onboardingOrgNameHelp.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez le modifier plus tard.'**
  String get onboardingOrgNameHelp;

  /// No description provided for @onboardingDefaultPlan.
  ///
  /// In fr, this message translates to:
  /// **'Vous démarrez en formule Free : {projects} projets et {members} membres.'**
  String onboardingDefaultPlan(String members, String projects);

  /// No description provided for @onboardingSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer l’organisation'**
  String get onboardingSubmit;

  /// No description provided for @dashboardGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {firstName} 👋'**
  String dashboardGreeting(String firstName);

  /// No description provided for @dashboardIntro.
  ///
  /// In fr, this message translates to:
  /// **'Voici l’activité de votre organisation {org}.'**
  String dashboardIntro(String org);

  /// No description provided for @dashboardStatPlan.
  ///
  /// In fr, this message translates to:
  /// **'Formule'**
  String get dashboardStatPlan;

  /// No description provided for @dashboardStatProjects.
  ///
  /// In fr, this message translates to:
  /// **'Projets'**
  String get dashboardStatProjects;

  /// No description provided for @dashboardStatProjectsSub.
  ///
  /// In fr, this message translates to:
  /// **'sur {max} max'**
  String dashboardStatProjectsSub(String max);

  /// No description provided for @dashboardStatMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get dashboardStatMembers;

  /// No description provided for @dashboardStatMembersSub.
  ///
  /// In fr, this message translates to:
  /// **'actifs'**
  String get dashboardStatMembersSub;

  /// No description provided for @dashboardStatInvitations.
  ///
  /// In fr, this message translates to:
  /// **'Invitations'**
  String get dashboardStatInvitations;

  /// No description provided for @dashboardStatInvitationsSub.
  ///
  /// In fr, this message translates to:
  /// **'en attente'**
  String get dashboardStatInvitationsSub;

  /// No description provided for @dashboardRecentProjects.
  ///
  /// In fr, this message translates to:
  /// **'Projets récents'**
  String get dashboardRecentProjects;

  /// No description provided for @dashboardFreeSlot.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau projet ({remaining, plural, one {{remaining} restant} other {{remaining} restants}} sur la formule Free)'**
  String dashboardFreeSlot(int remaining);

  /// No description provided for @dashboardActivityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activité récente'**
  String get dashboardActivityTitle;

  /// No description provided for @dashboardActivityMemberJoined.
  ///
  /// In fr, this message translates to:
  /// **'{name} a rejoint {org}'**
  String dashboardActivityMemberJoined(String name, String org);

  /// No description provided for @dashboardActivityProjectCreated.
  ///
  /// In fr, this message translates to:
  /// **'{name} a créé « {project} »'**
  String dashboardActivityProjectCreated(String name, String project);

  /// No description provided for @dashboardActivityInvitationSent.
  ///
  /// In fr, this message translates to:
  /// **'Invitation envoyée à {email}'**
  String dashboardActivityInvitationSent(String email);

  /// No description provided for @dashboardActivityOrgCreated.
  ///
  /// In fr, this message translates to:
  /// **'Organisation {org} créée'**
  String dashboardActivityOrgCreated(String org);

  /// No description provided for @dashboardActivityEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité pour l’instant. Elle apparaîtra ici dès que votre équipe travaillera sur un projet.'**
  String get dashboardActivityEmpty;

  /// No description provided for @upgradeBannerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Passez en Pro pour des projets illimités'**
  String get upgradeBannerTitle;

  /// No description provided for @upgradeBannerDesc.
  ///
  /// In fr, this message translates to:
  /// **'Paiement simulé dans la démo : aucun vrai paiement n’est effectué.'**
  String get upgradeBannerDesc;

  /// No description provided for @upgradeSeePlans.
  ///
  /// In fr, this message translates to:
  /// **'Voir les formules'**
  String get upgradeSeePlans;

  /// No description provided for @upgradeButton.
  ///
  /// In fr, this message translates to:
  /// **'Passer en Pro'**
  String get upgradeButton;

  /// No description provided for @membersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Membres de l’organisation'**
  String get membersTitle;

  /// No description provided for @membersSummaryActive.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, one {{n} membre actif} other {{n} membres actifs}}'**
  String membersSummaryActive(int n);

  /// No description provided for @membersSummaryPending.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, one {{n} invitation en attente} other {{n} invitations en attente}}'**
  String membersSummaryPending(int n);

  /// No description provided for @membersSummaryLimit.
  ///
  /// In fr, this message translates to:
  /// **'formule {plan} : {max} membres maximum'**
  String membersSummaryLimit(String max, String plan);

  /// No description provided for @membersColMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre'**
  String get membersColMember;

  /// No description provided for @membersColRole.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get membersColRole;

  /// No description provided for @membersColStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get membersColStatus;

  /// No description provided for @membersInviteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inviter un membre'**
  String get membersInviteTitle;

  /// No description provided for @membersInviteDesc.
  ///
  /// In fr, this message translates to:
  /// **'Un e-mail d’invitation part dans la boîte de démo.'**
  String get membersInviteDesc;

  /// No description provided for @membersInviteRole.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get membersInviteRole;

  /// No description provided for @membersInviteSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer l’invitation'**
  String get membersInviteSubmit;

  /// No description provided for @membersRolesHelpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Qui peut faire quoi ?'**
  String get membersRolesHelpTitle;

  /// No description provided for @membersRolesHelpOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire : tout, y compris supprimer l’organisation.'**
  String get membersRolesHelpOwner;

  /// No description provided for @membersRolesHelpAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Admin : membres, invitations et abonnement.'**
  String get membersRolesHelpAdmin;

  /// No description provided for @membersRolesHelpMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre : projets uniquement, pas d’accès à l’abonnement.'**
  String get membersRolesHelpMember;

  /// No description provided for @membersEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Invitez votre équipe'**
  String get membersEmptyTitle;

  /// No description provided for @membersEmptyText.
  ///
  /// In fr, this message translates to:
  /// **'Pour l’instant, {org} ne compte qu’un membre. Invitez vos collègues pour travailler ensemble.'**
  String membersEmptyText(String org);

  /// No description provided for @membersActionChangeRole.
  ///
  /// In fr, this message translates to:
  /// **'Changer le rôle'**
  String get membersActionChangeRole;

  /// No description provided for @membersActionRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer de l’organisation'**
  String get membersActionRemove;

  /// No description provided for @membersActionResendInvite.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer l’invitation'**
  String get membersActionResendInvite;

  /// No description provided for @membersActionCancelInvite.
  ///
  /// In fr, this message translates to:
  /// **'Annuler l’invitation'**
  String get membersActionCancelInvite;

  /// No description provided for @membersConfirmRemoveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Retirer {name} ?'**
  String membersConfirmRemoveTitle(String name);

  /// No description provided for @membersConfirmRemoveText.
  ///
  /// In fr, this message translates to:
  /// **'{name} n’aura plus accès aux projets de l’organisation {org}. Vous pourrez l’inviter à nouveau plus tard.'**
  String membersConfirmRemoveText(String name, String org);

  /// No description provided for @membersConfirmRemoveConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get membersConfirmRemoveConfirm;

  /// No description provided for @membersToastInvitationSent.
  ///
  /// In fr, this message translates to:
  /// **'Invitation envoyée à {email}.'**
  String membersToastInvitationSent(String email);

  /// No description provided for @membersToastInvitationResent.
  ///
  /// In fr, this message translates to:
  /// **'Invitation renvoyée à {email}.'**
  String membersToastInvitationResent(String email);

  /// No description provided for @membersToastInvitationCanceled.
  ///
  /// In fr, this message translates to:
  /// **'Invitation annulée.'**
  String get membersToastInvitationCanceled;

  /// No description provided for @membersToastRoleChanged.
  ///
  /// In fr, this message translates to:
  /// **'{name} a maintenant le rôle {role}.'**
  String membersToastRoleChanged(String name, String role);

  /// No description provided for @membersToastRemoved.
  ///
  /// In fr, this message translates to:
  /// **'{name} ne fait plus partie de l’organisation {org}.'**
  String membersToastRemoved(String name, String org);

  /// No description provided for @membersErrorLimit.
  ///
  /// In fr, this message translates to:
  /// **'Votre formule Free compte déjà {max} membres. Passez en Pro pour en inviter d’autres.'**
  String membersErrorLimit(String max);

  /// No description provided for @membersErrorAlreadyMember.
  ///
  /// In fr, this message translates to:
  /// **'{email} fait déjà partie de l’organisation {org}.'**
  String membersErrorAlreadyMember(String email, String org);

  /// No description provided for @membersErrorAlreadyInvited.
  ///
  /// In fr, this message translates to:
  /// **'Une invitation est déjà en attente pour {email}.'**
  String membersErrorAlreadyInvited(String email);

  /// No description provided for @invitationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre {org}'**
  String invitationTitle(String org);

  /// No description provided for @invitationText.
  ///
  /// In fr, this message translates to:
  /// **'{inviter} vous invite à rejoindre l’organisation {org} sur LaunchKit.'**
  String invitationText(String inviter, String org);

  /// No description provided for @invitationProposedRole.
  ///
  /// In fr, this message translates to:
  /// **'Rôle proposé'**
  String get invitationProposedRole;

  /// No description provided for @invitationSignedInAs.
  ///
  /// In fr, this message translates to:
  /// **'Compte connecté : {email}'**
  String invitationSignedInAs(String email);

  /// No description provided for @invitationAccept.
  ///
  /// In fr, this message translates to:
  /// **'Accepter l’invitation'**
  String get invitationAccept;

  /// No description provided for @invitationDecline.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get invitationDecline;

  /// No description provided for @invitationAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans {org} !'**
  String invitationAccepted(String org);

  /// No description provided for @invitationDeclined.
  ///
  /// In fr, this message translates to:
  /// **'Invitation refusée.'**
  String get invitationDeclined;

  /// No description provided for @invitationExpired.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation a expiré. Demandez à {inviter} de vous en envoyer une nouvelle.'**
  String invitationExpired(String inviter);

  /// No description provided for @invitationWrongAccount.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation est destinée à {email}. Connectez-vous avec cette adresse pour l’accepter.'**
  String invitationWrongAccount(String email);

  /// No description provided for @billingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get billingTitle;

  /// No description provided for @billingIntro.
  ///
  /// In fr, this message translates to:
  /// **'Réservé au propriétaire et aux admins. Les paiements de la démo sont simulés.'**
  String get billingIntro;

  /// No description provided for @billingCurrentPlan.
  ///
  /// In fr, this message translates to:
  /// **'Formule actuelle'**
  String get billingCurrentPlan;

  /// No description provided for @billingLimitReached.
  ///
  /// In fr, this message translates to:
  /// **'Limite atteinte'**
  String get billingLimitReached;

  /// No description provided for @billingUsage.
  ///
  /// In fr, this message translates to:
  /// **'{used} / {max}'**
  String billingUsage(String max, String used);

  /// No description provided for @billingUnlimited.
  ///
  /// In fr, this message translates to:
  /// **'illimité'**
  String get billingUnlimited;

  /// No description provided for @billingPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'/ mois'**
  String get billingPerMonth;

  /// No description provided for @billingPerMonthSimulated.
  ///
  /// In fr, this message translates to:
  /// **'/ mois (simulé)'**
  String get billingPerMonthSimulated;

  /// No description provided for @billingRecommended.
  ///
  /// In fr, this message translates to:
  /// **'Recommandé'**
  String get billingRecommended;

  /// No description provided for @billingFreeProjects.
  ///
  /// In fr, this message translates to:
  /// **'{n} projets'**
  String billingFreeProjects(String n);

  /// No description provided for @billingFreeMembers.
  ///
  /// In fr, this message translates to:
  /// **'{n} membres'**
  String billingFreeMembers(String n);

  /// No description provided for @billingFreeSupport.
  ///
  /// In fr, this message translates to:
  /// **'Support communautaire'**
  String get billingFreeSupport;

  /// No description provided for @billingProProjects.
  ///
  /// In fr, this message translates to:
  /// **'Projets illimités'**
  String get billingProProjects;

  /// No description provided for @billingProMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres illimités'**
  String get billingProMembers;

  /// No description provided for @billingProSupport.
  ///
  /// In fr, this message translates to:
  /// **'Support prioritaire'**
  String get billingProSupport;

  /// No description provided for @billingSimulatedNote.
  ///
  /// In fr, this message translates to:
  /// **'Paiement simulé : « Passer en Pro » envoie un faux webhook, traité par le worker Rust. Aucune carte n’est demandée.'**
  String get billingSimulatedNote;

  /// No description provided for @billingConfirming.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation du paiement en cours…'**
  String get billingConfirming;

  /// No description provided for @billingProActivatedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans Pro'**
  String get billingProActivatedTitle;

  /// No description provided for @billingProActivatedText.
  ///
  /// In fr, this message translates to:
  /// **'{org} passe en Pro : projets et membres illimités. Dans cette démo, le paiement est simulé.'**
  String billingProActivatedText(String org);

  /// No description provided for @projectsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Projets'**
  String get projectsTitle;

  /// No description provided for @projectsIntro.
  ///
  /// In fr, this message translates to:
  /// **'Module d’exemple : c’est ici que se branche le métier de chaque client.'**
  String get projectsIntro;

  /// No description provided for @projectsNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau projet'**
  String get projectsNew;

  /// No description provided for @projectsLimitAlert.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez atteint la limite de la formule Free : {used} projets sur {max}. Passez en Pro pour en créer d’autres.'**
  String projectsLimitAlert(String max, String used);

  /// No description provided for @projectsLockedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Projet suivant : disponible en Pro'**
  String get projectsLockedTitle;

  /// No description provided for @projectsLockedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Passez en Pro pour créer autant de projets que nécessaire.'**
  String get projectsLockedDesc;

  /// No description provided for @projectsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun projet pour l’instant'**
  String get projectsEmptyTitle;

  /// No description provided for @projectsEmptyText.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre premier projet pour organiser le travail de votre équipe. La formule Free en compte jusqu’à {max}.'**
  String projectsEmptyText(String max);

  /// No description provided for @projectsEmptyCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer un projet'**
  String get projectsEmptyCreate;

  /// No description provided for @projectsDetailDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get projectsDetailDescription;

  /// No description provided for @projectsDetailHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get projectsDetailHistory;

  /// No description provided for @projectsDetailDetails.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get projectsDetailDetails;

  /// No description provided for @projectsDetailStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get projectsDetailStatus;

  /// No description provided for @projectsDetailLead.
  ///
  /// In fr, this message translates to:
  /// **'Responsable'**
  String get projectsDetailLead;

  /// No description provided for @projectsDetailDue.
  ///
  /// In fr, this message translates to:
  /// **'Échéance'**
  String get projectsDetailDue;

  /// No description provided for @projectsDetailCreatedOn.
  ///
  /// In fr, this message translates to:
  /// **'Créé le'**
  String get projectsDetailCreatedOn;

  /// No description provided for @projectsDetailMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres du projet'**
  String get projectsDetailMembers;

  /// No description provided for @projectsDetailEditProject.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le projet'**
  String get projectsDetailEditProject;

  /// No description provided for @projectsHistoryStatusChanged.
  ///
  /// In fr, this message translates to:
  /// **'{name} a changé le statut en « {status} »'**
  String projectsHistoryStatusChanged(String name, String status);

  /// No description provided for @projectsHistoryDescriptionChanged.
  ///
  /// In fr, this message translates to:
  /// **'{name} a modifié la description'**
  String projectsHistoryDescriptionChanged(String name);

  /// No description provided for @projectsHistoryCreated.
  ///
  /// In fr, this message translates to:
  /// **'{name} a créé le projet'**
  String projectsHistoryCreated(String name);

  /// No description provided for @projectsHistoryStatusChangedShort.
  ///
  /// In fr, this message translates to:
  /// **'Statut passé à « {status} »'**
  String projectsHistoryStatusChangedShort(String status);

  /// No description provided for @projectsHistoryDescriptionChangedShort.
  ///
  /// In fr, this message translates to:
  /// **'Description modifiée'**
  String get projectsHistoryDescriptionChangedShort;

  /// No description provided for @projectsFormName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du projet'**
  String get projectsFormName;

  /// No description provided for @projectsFormNameHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un nom court que toute l’équipe reconnaîtra.'**
  String get projectsFormNameHelp;

  /// No description provided for @projectsFormDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get projectsFormDescription;

  /// No description provided for @projectsFormCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer le projet'**
  String get projectsFormCreate;

  /// No description provided for @projectsConfirmDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer « {project} » ?'**
  String projectsConfirmDeleteTitle(String project);

  /// No description provided for @projectsConfirmDeleteText.
  ///
  /// In fr, this message translates to:
  /// **'Le projet et son historique seront supprimés définitivement.'**
  String get projectsConfirmDeleteText;

  /// No description provided for @projectsToastCreated.
  ///
  /// In fr, this message translates to:
  /// **'Projet « {project} » créé.'**
  String projectsToastCreated(String project);

  /// No description provided for @projectsToastSaved.
  ///
  /// In fr, this message translates to:
  /// **'Modifications enregistrées.'**
  String get projectsToastSaved;

  /// No description provided for @projectsToastDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Projet supprimé.'**
  String get projectsToastDeleted;

  /// No description provided for @adminArea.
  ///
  /// In fr, this message translates to:
  /// **'Back-office'**
  String get adminArea;

  /// No description provided for @adminSuperAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Super-admin'**
  String get adminSuperAdmin;

  /// No description provided for @adminNavOverview.
  ///
  /// In fr, this message translates to:
  /// **'Vue d’ensemble'**
  String get adminNavOverview;

  /// No description provided for @adminNavOrgs.
  ///
  /// In fr, this message translates to:
  /// **'Organisations'**
  String get adminNavOrgs;

  /// No description provided for @adminNavUsers.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get adminNavUsers;

  /// No description provided for @adminNavPlans.
  ///
  /// In fr, this message translates to:
  /// **'Formules'**
  String get adminNavPlans;

  /// No description provided for @adminOrgsIntro.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les organisations de la démo. Visible uniquement par le super-admin.'**
  String get adminOrgsIntro;

  /// No description provided for @adminStatOrgs.
  ///
  /// In fr, this message translates to:
  /// **'Organisations'**
  String get adminStatOrgs;

  /// No description provided for @adminStatUsers.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get adminStatUsers;

  /// No description provided for @adminStatPro.
  ///
  /// In fr, this message translates to:
  /// **'En Pro'**
  String get adminStatPro;

  /// No description provided for @adminStatProSub.
  ///
  /// In fr, this message translates to:
  /// **'simulé'**
  String get adminStatProSub;

  /// No description provided for @adminStatJobs.
  ///
  /// In fr, this message translates to:
  /// **'Tâches du worker'**
  String get adminStatJobs;

  /// No description provided for @adminStatJobsSub.
  ///
  /// In fr, this message translates to:
  /// **'en attente'**
  String get adminStatJobsSub;

  /// No description provided for @adminColOrg.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get adminColOrg;

  /// No description provided for @adminColPlan.
  ///
  /// In fr, this message translates to:
  /// **'Formule'**
  String get adminColPlan;

  /// No description provided for @adminColMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get adminColMembers;

  /// No description provided for @adminColProjects.
  ///
  /// In fr, this message translates to:
  /// **'Projets'**
  String get adminColProjects;

  /// No description provided for @adminColCreated.
  ///
  /// In fr, this message translates to:
  /// **'Créée le'**
  String get adminColCreated;

  /// No description provided for @mobileOrgsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos organisations'**
  String get mobileOrgsTitle;

  /// No description provided for @mobileOrgsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez l’espace sur lequel travailler.'**
  String get mobileOrgsSubtitle;

  /// No description provided for @mobileOrgsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Formule {plan} · {members, plural, one {{members} membre} other {{members} membres}}'**
  String mobileOrgsDesc(int members, String plan);

  /// No description provided for @mobileOrgsCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer une organisation'**
  String get mobileOrgsCreate;

  /// No description provided for @mobileOrgsContinueWith.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec {org}'**
  String mobileOrgsContinueWith(String org);

  /// No description provided for @mobileProjectsLimit.
  ///
  /// In fr, this message translates to:
  /// **'Free : {used} projets sur {max}. Passez en Pro.'**
  String mobileProjectsLimit(String max, String used);

  /// No description provided for @mobileDemoEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Démo : utilisez une adresse en @demo.test'**
  String get mobileDemoEmailHint;

  /// No description provided for @mobileBillingNote.
  ///
  /// In fr, this message translates to:
  /// **'Paiement simulé : aucune carte demandée.'**
  String get mobileBillingNote;

  /// No description provided for @mobileProfileAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get mobileProfileAccount;

  /// No description provided for @mobileProfileOrganization.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get mobileProfileOrganization;

  /// No description provided for @mobileProfileNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get mobileProfileNotifications;

  /// No description provided for @mobileProfileNotificationsOn.
  ///
  /// In fr, this message translates to:
  /// **'Activées'**
  String get mobileProfileNotificationsOn;

  /// No description provided for @mobileProfilePassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get mobileProfilePassword;

  /// No description provided for @mobileProfileChange.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get mobileProfileChange;

  /// No description provided for @validationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire.'**
  String get validationRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez une adresse e-mail valide, par exemple marie@demo.test.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordShort.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins {min} caractères.'**
  String validationPasswordShort(String min);

  /// No description provided for @validationTooLong.
  ///
  /// In fr, this message translates to:
  /// **'{max} caractères maximum.'**
  String validationTooLong(String max);

  /// No description provided for @validationEmailTaken.
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cette adresse. Connectez-vous ou utilisez une autre adresse.'**
  String get validationEmailTaken;

  /// No description provided for @validationLoginFailed.
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou mot de passe incorrect.'**
  String get validationLoginFailed;

  /// No description provided for @validationEmailNotVerified.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez d’abord votre adresse : nous vous avons envoyé un lien.'**
  String get validationEmailNotVerified;

  /// No description provided for @errorNotFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Page introuvable'**
  String get errorNotFoundTitle;

  /// No description provided for @errorNotFoundText.
  ///
  /// In fr, this message translates to:
  /// **'Cette page n’existe pas ou a été déplacée. Vérifiez l’adresse ou revenez à l’accueil.'**
  String get errorNotFoundText;

  /// No description provided for @errorForbiddenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accès refusé'**
  String get errorForbiddenTitle;

  /// No description provided for @errorForbiddenText.
  ///
  /// In fr, this message translates to:
  /// **'Votre rôle ne permet pas d’ouvrir cette page. Demandez l’accès à un administrateur de l’organisation {org}.'**
  String errorForbiddenText(String org);

  /// No description provided for @errorForbiddenAdminOnly.
  ///
  /// In fr, this message translates to:
  /// **'Cette page est réservée au super-admin de la démo.'**
  String get errorForbiddenAdminOnly;

  /// No description provided for @errorServerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un problème est survenu'**
  String get errorServerTitle;

  /// No description provided for @errorServerText.
  ///
  /// In fr, this message translates to:
  /// **'Réessayez dans un instant. Si le problème continue, rechargez la page.'**
  String get errorServerText;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Connexion impossible. Vérifiez votre réseau, puis réessayez.'**
  String get errorNetwork;

  /// No description provided for @errorSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré. Reconnectez-vous pour continuer.'**
  String get errorSessionExpired;

  /// No description provided for @errorOwnerProtected.
  ///
  /// In fr, this message translates to:
  /// **'Le rôle de propriétaire ne peut être ni modifié ni retiré.'**
  String get errorOwnerProtected;

  /// No description provided for @errorInvitationUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation n’est plus valable.'**
  String get errorInvitationUnavailable;

  /// No description provided for @errorInvalidLink.
  ///
  /// In fr, this message translates to:
  /// **'Ce lien n’est pas valable. Demandez-en un nouveau.'**
  String get errorInvalidLink;

  /// No description provided for @errorInvalidRequest.
  ///
  /// In fr, this message translates to:
  /// **'Certaines informations sont manquantes ou incorrectes.'**
  String get errorInvalidRequest;

  /// No description provided for @errorAlreadyPro.
  ///
  /// In fr, this message translates to:
  /// **'Cette organisation est déjà en formule Pro.'**
  String get errorAlreadyPro;

  /// No description provided for @emailVerifySubject.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre adresse e-mail'**
  String get emailVerifySubject;

  /// No description provided for @emailVerifyPreheader.
  ///
  /// In fr, this message translates to:
  /// **'Un clic pour activer votre compte LaunchKit.'**
  String get emailVerifyPreheader;

  /// No description provided for @emailVerifyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre adresse'**
  String get emailVerifyTitle;

  /// No description provided for @emailVerifyBody.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {firstName}, cliquez sur le bouton ci-dessous pour activer votre compte LaunchKit.'**
  String emailVerifyBody(String firstName);

  /// No description provided for @emailVerifyButton.
  ///
  /// In fr, this message translates to:
  /// **'Activer mon compte'**
  String get emailVerifyButton;

  /// No description provided for @emailVerifyExpiry.
  ///
  /// In fr, this message translates to:
  /// **'Ce lien est valable {hours} heures.'**
  String emailVerifyExpiry(String hours);

  /// No description provided for @emailVerifyIgnore.
  ///
  /// In fr, this message translates to:
  /// **'Vous n’avez pas créé de compte ? Ignorez simplement cet e-mail.'**
  String get emailVerifyIgnore;

  /// No description provided for @emailInviteSubject.
  ///
  /// In fr, this message translates to:
  /// **'{inviter} vous invite à rejoindre {org}'**
  String emailInviteSubject(String inviter, String org);

  /// No description provided for @emailInvitePreheader.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez l’équipe {org} sur LaunchKit.'**
  String emailInvitePreheader(String org);

  /// No description provided for @emailInviteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez {org}'**
  String emailInviteTitle(String org);

  /// No description provided for @emailInviteBody.
  ///
  /// In fr, this message translates to:
  /// **'{inviter} vous invite à rejoindre l’organisation {org} sur LaunchKit, avec le rôle {role}.'**
  String emailInviteBody(String inviter, String org, String role);

  /// No description provided for @emailInviteButton.
  ///
  /// In fr, this message translates to:
  /// **'Accepter l’invitation'**
  String get emailInviteButton;

  /// No description provided for @emailInviteExpiry.
  ///
  /// In fr, this message translates to:
  /// **'L’invitation est valable {days} jours.'**
  String emailInviteExpiry(String days);

  /// No description provided for @emailInviteIgnore.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne connaissez pas {inviter} ? Ignorez cet e-mail.'**
  String emailInviteIgnore(String inviter);

  /// No description provided for @emailProWelcomeSubject.
  ///
  /// In fr, this message translates to:
  /// **'{org} passe en Pro'**
  String emailProWelcomeSubject(String org);

  /// No description provided for @emailProWelcomePreheader.
  ///
  /// In fr, this message translates to:
  /// **'Projets et membres illimités, dès maintenant.'**
  String get emailProWelcomePreheader;

  /// No description provided for @emailProWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans Pro'**
  String get emailProWelcomeTitle;

  /// No description provided for @emailProWelcomeBody.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {firstName}, {org} est maintenant en formule Pro : projets et membres illimités. Dans cette démo, le paiement est simulé.'**
  String emailProWelcomeBody(String firstName, String org);

  /// No description provided for @emailProWelcomeButton.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir LaunchKit'**
  String get emailProWelcomeButton;

  /// No description provided for @emailFooter.
  ///
  /// In fr, this message translates to:
  /// **'LaunchKit · démo portfolio · e-mail envoyé dans la boîte de test Mailpit.'**
  String get emailFooter;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
