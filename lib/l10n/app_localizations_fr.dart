// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonNavDashboard => 'Tableau de bord';

  @override
  String get commonNavProjects => 'Projets';

  @override
  String get commonNavMembers => 'Membres';

  @override
  String get commonNavBilling => 'Abonnement';

  @override
  String get commonNavSettings => 'Paramètres';

  @override
  String get commonNavProfile => 'Profil';

  @override
  String get commonSearch => 'Rechercher…';

  @override
  String get commonLanguageLabel => 'Langue';

  @override
  String get commonLanguageFr => 'Français';

  @override
  String get commonLanguageEn => 'English';

  @override
  String get commonPlanFree => 'Free';

  @override
  String get commonPlanPro => 'Pro';

  @override
  String commonPlanLabel(String plan) {
    return 'Formule $plan';
  }

  @override
  String get commonRoleOwner => 'Propriétaire';

  @override
  String get commonRoleAdmin => 'Admin';

  @override
  String get commonRoleMember => 'Membre';

  @override
  String get commonRoleAdminDesc => 'Gère les membres et l’abonnement';

  @override
  String get commonRoleMemberDesc => 'Travaille sur les projets';

  @override
  String get commonStatusActive => 'Actif';

  @override
  String get commonStatusInProgress => 'En cours';

  @override
  String get commonStatusDraft => 'Brouillon';

  @override
  String get commonStatusPending => 'En attente';

  @override
  String get commonActionSave => 'Enregistrer';

  @override
  String get commonActionCancel => 'Annuler';

  @override
  String get commonActionContinue => 'Continuer';

  @override
  String get commonActionEdit => 'Modifier';

  @override
  String get commonActionDelete => 'Supprimer';

  @override
  String get commonActionClose => 'Fermer';

  @override
  String get commonActionRetry => 'Réessayer';

  @override
  String get commonActionSeeAll => 'Tout voir';

  @override
  String get commonActionBackHome => 'Retour à l’accueil';

  @override
  String get commonActionBackDashboard => 'Retour au tableau de bord';

  @override
  String get commonActionSignOut => 'Se déconnecter';

  @override
  String get commonTimeJustNow => 'à l’instant';

  @override
  String commonTimeMinutesAgo(String n) {
    return 'il y a $n min';
  }

  @override
  String commonTimeHoursAgo(String n) {
    return 'il y a $n h';
  }

  @override
  String get commonTimeYesterday => 'hier';

  @override
  String get commonTimeToday => 'aujourd’hui';

  @override
  String commonTimeDaysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n jours', one: '$n jour');
    return 'il y a $_temp0';
  }

  @override
  String commonMetaEdited(String when) {
    return 'Modifié $when';
  }

  @override
  String commonMetaCreated(String when) {
    return 'Créé $when';
  }

  @override
  String get commonDemoEmailHint => 'Démo : utilisez une adresse inventée, comme marie@demo.test';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonA11ySwitchLanguage => 'Changer de langue';

  @override
  String get commonA11ySwitchOrg => 'Changer d’organisation';

  @override
  String get commonA11yNotifications => 'Notifications';

  @override
  String get commonA11yAccountMenu => 'Menu du compte';

  @override
  String get commonA11yOpenMenu => 'Ouvrir le menu';

  @override
  String get homeNavFeatures => 'Fonctionnalités';

  @override
  String get homeNavPricing => 'Formules';

  @override
  String get homeNavMethod => 'Méthode';

  @override
  String get homeNavSource => 'Code source';

  @override
  String get homeNavLogin => 'Connexion';

  @override
  String get homeCtaTryDemo => 'Essayer la démo';

  @override
  String get homeCtaViewCode => 'Voir le code';

  @override
  String get homeHeroBadge => 'Kit de démarrage SaaS · code ouvert';

  @override
  String get homeHeroTitle => 'Votre MVP en 2 semaines, sur une base déjà prête';

  @override
  String get homeHeroSubtitle =>
      'Comptes, organisations, rôles, abonnements et back-office sont déjà en place. Je pars de ce kit pour livrer votre produit vite, au forfait.';

  @override
  String get homeHeroDemoNote => 'Démo : inscrivez-vous avec une adresse inventée, comme marie@demo.test';

  @override
  String get homePreviewProject1 => 'Site vitrine';

  @override
  String get homePreviewProject2 => 'App mobile';

  @override
  String get homePreviewProject3 => 'Tableau de bord';

  @override
  String get homePreviewEditedRecently => 'Modifié récemment';

  @override
  String get homeFeaturesTitle => 'Tout ce qu’un SaaS demande, déjà fait';

  @override
  String get homeFeaturesSubtitle => 'On se concentre directement sur ce qui rend votre produit unique.';

  @override
  String get homeFeaturesAccountsTitle => 'Comptes et connexion';

  @override
  String get homeFeaturesAccountsDesc => 'Inscription, connexion et vérification de l’e-mail.';

  @override
  String get homeFeaturesTenancyTitle => 'Multi-entreprise';

  @override
  String get homeFeaturesTenancyDesc => 'Chaque client a son organisation et ses données.';

  @override
  String get homeFeaturesRolesTitle => 'Rôles et invitations';

  @override
  String get homeFeaturesRolesDesc => 'Propriétaire, admin et membre, invitations par e-mail.';

  @override
  String get homeFeaturesPlansTitle => 'Formules Free et Pro';

  @override
  String get homeFeaturesPlansDesc => 'Limites par formule et paiement interchangeable.';

  @override
  String get homeFeaturesBackofficeTitle => 'Back-office';

  @override
  String get homeFeaturesBackofficeDesc => 'Vue super-admin sur les organisations et les utilisateurs.';

  @override
  String get homeFeaturesI18nTitle => 'Français et anglais';

  @override
  String get homeFeaturesI18nDesc => 'Interface bilingue, prête pour d’autres langues.';

  @override
  String get homeStackLabel => 'Stack';

  @override
  String get homeStackRustWorker => 'Worker Rust';

  @override
  String get homeMethodTitle => 'Ma méthode, en 4 étapes';

  @override
  String get homeMethodSpecTitle => 'Spec';

  @override
  String get homeMethodSpecDesc => 'Ce qu’on construit, écrit et validé avec vous.';

  @override
  String get homeMethodDecisionsTitle => 'Décisions';

  @override
  String get homeMethodDecisionsDesc => 'Chaque choix technique est noté et justifié.';

  @override
  String get homeMethodTestsTitle => 'Tests';

  @override
  String get homeMethodTestsDesc => 'Les tests découlent directement de la spec.';

  @override
  String get homeMethodChangelogTitle => 'Changelog';

  @override
  String get homeMethodChangelogDesc => 'Chaque livraison est versionnée et documentée.';

  @override
  String get homeFooterCta => 'Besoin d’un MVP ? Parlons de votre projet.';

  @override
  String get homeFooterContact => 'Me contacter';

  @override
  String homeFooterLegal(String year) {
    return '© $year LaunchKit · démo portfolio · FR / EN';
  }

  @override
  String get homeFooterAndroid => 'Appli Android';

  @override
  String get authSideSignupTitle => 'Lancez votre SaaS sur une base déjà prête';

  @override
  String get authSideSignupPoint1 => 'Comptes et organisations';

  @override
  String get authSideSignupPoint2 => 'Rôles et invitations';

  @override
  String get authSideSignupPoint3 => 'Formules Free et Pro';

  @override
  String get authSideLoginTitle => 'Bon retour parmi nous';

  @override
  String get authSideLoginPoint1 => 'Reprenez là où vous en étiez';

  @override
  String get authSideLoginPoint2 => 'Changez d’organisation en un clic';

  @override
  String get authSideLoginPoint3 => 'Interface en français ou en anglais';

  @override
  String get authFieldFullName => 'Nom complet';

  @override
  String get authFieldEmail => 'E-mail';

  @override
  String get authFieldPassword => 'Mot de passe';

  @override
  String get authSignupTitle => 'Créer un compte';

  @override
  String get authSignupSubtitle => 'Gratuit, sans carte bancaire.';

  @override
  String get authSignupEmailHelp =>
      'Utilisez une adresse inventée : la démo n’envoie ses e-mails que dans une boîte de test.';

  @override
  String authSignupPasswordHelp(String min) {
    return '$min caractères minimum.';
  }

  @override
  String get authSignupSubmit => 'Créer mon compte';

  @override
  String get authSignupHaveAccount => 'Déjà un compte ?';

  @override
  String get authSignupGoLogin => 'Se connecter';

  @override
  String get authLoginTitle => 'Connexion';

  @override
  String get authLoginSubtitle => 'Connectez-vous à votre espace LaunchKit.';

  @override
  String get authLoginSubmit => 'Se connecter';

  @override
  String get authLoginNoAccount => 'Pas encore de compte ?';

  @override
  String get authLoginGoSignup => 'S’inscrire';

  @override
  String get authVerifyTitle => 'Vérifiez votre e-mail';

  @override
  String authVerifyText(String email) {
    return 'Nous avons envoyé un lien de vérification à $email. Cliquez dessus pour activer votre compte.';
  }

  @override
  String get authVerifyDemoNote => 'Démo : l’e-mail arrive dans la boîte de test Mailpit.';

  @override
  String get authVerifyOpenInbox => 'Ouvrir la boîte de démo';

  @override
  String get authVerifyResend => 'Renvoyer l’e-mail';

  @override
  String authVerifyResent(String email) {
    return 'E-mail renvoyé à $email.';
  }

  @override
  String get authVerifyVerified => 'Adresse vérifiée. Bienvenue !';

  @override
  String get authVerifyLinkExpired => 'Ce lien a expiré. Demandez-en un nouveau depuis l’écran de vérification.';

  @override
  String onboardingStep(String current, String total) {
    return 'Étape $current sur $total';
  }

  @override
  String get onboardingOrgTitle => 'Créez votre organisation';

  @override
  String get onboardingOrgText =>
      'Votre entreprise, votre équipe et vos projets au même endroit. Vous en serez le propriétaire.';

  @override
  String get onboardingOrgName => 'Nom de l’organisation';

  @override
  String get onboardingOrgNameHelp => 'Vous pourrez le modifier plus tard.';

  @override
  String onboardingDefaultPlan(String members, String projects) {
    return 'Vous démarrez en formule Free : $projects projets et $members membres.';
  }

  @override
  String get onboardingSubmit => 'Créer l’organisation';

  @override
  String dashboardGreeting(String firstName) {
    return 'Bonjour $firstName 👋';
  }

  @override
  String dashboardIntro(String org) {
    return 'Voici l’activité de votre organisation $org.';
  }

  @override
  String get dashboardStatPlan => 'Formule';

  @override
  String get dashboardStatProjects => 'Projets';

  @override
  String dashboardStatProjectsSub(String max) {
    return 'sur $max max';
  }

  @override
  String get dashboardStatMembers => 'Membres';

  @override
  String get dashboardStatMembersSub => 'actifs';

  @override
  String get dashboardStatInvitations => 'Invitations';

  @override
  String get dashboardStatInvitationsSub => 'en attente';

  @override
  String get dashboardRecentProjects => 'Projets récents';

  @override
  String dashboardFreeSlot(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining restants',
      one: '$remaining restant',
    );
    return 'Nouveau projet ($_temp0 sur la formule Free)';
  }

  @override
  String get dashboardActivityTitle => 'Activité récente';

  @override
  String dashboardActivityMemberJoined(String name, String org) {
    return '$name a rejoint $org';
  }

  @override
  String dashboardActivityProjectCreated(String name, String project) {
    return '$name a créé « $project »';
  }

  @override
  String dashboardActivityInvitationSent(String email) {
    return 'Invitation envoyée à $email';
  }

  @override
  String dashboardActivityOrgCreated(String org) {
    return 'Organisation $org créée';
  }

  @override
  String get dashboardActivityEmpty =>
      'Aucune activité pour l’instant. Elle apparaîtra ici dès que votre équipe travaillera sur un projet.';

  @override
  String get upgradeBannerTitle => 'Passez en Pro pour des projets illimités';

  @override
  String get upgradeBannerDesc => 'Paiement simulé dans la démo : aucun vrai paiement n’est effectué.';

  @override
  String get upgradeSeePlans => 'Voir les formules';

  @override
  String get upgradeButton => 'Passer en Pro';

  @override
  String get membersTitle => 'Membres de l’organisation';

  @override
  String membersSummaryActive(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n membres actifs', one: '$n membre actif');
    return '$_temp0';
  }

  @override
  String membersSummaryPending(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n invitations en attente',
      one: '$n invitation en attente',
    );
    return '$_temp0';
  }

  @override
  String membersSummaryLimit(String max, String plan) {
    return 'formule $plan : $max membres maximum';
  }

  @override
  String get membersColMember => 'Membre';

  @override
  String get membersColRole => 'Rôle';

  @override
  String get membersColStatus => 'Statut';

  @override
  String get membersInviteTitle => 'Inviter un membre';

  @override
  String get membersInviteDesc => 'Un e-mail d’invitation part dans la boîte de démo.';

  @override
  String get membersInviteRole => 'Rôle';

  @override
  String get membersInviteSubmit => 'Envoyer l’invitation';

  @override
  String get membersRolesHelpTitle => 'Qui peut faire quoi ?';

  @override
  String get membersRolesHelpOwner => 'Propriétaire : tout, y compris supprimer l’organisation.';

  @override
  String get membersRolesHelpAdmin => 'Admin : membres, invitations et abonnement.';

  @override
  String get membersRolesHelpMember => 'Membre : projets uniquement, pas d’accès à l’abonnement.';

  @override
  String get membersEmptyTitle => 'Invitez votre équipe';

  @override
  String membersEmptyText(String org) {
    return 'Pour l’instant, $org ne compte qu’un membre. Invitez vos collègues pour travailler ensemble.';
  }

  @override
  String get membersActionChangeRole => 'Changer le rôle';

  @override
  String get membersActionRemove => 'Retirer de l’organisation';

  @override
  String get membersActionResendInvite => 'Renvoyer l’invitation';

  @override
  String get membersActionCancelInvite => 'Annuler l’invitation';

  @override
  String membersConfirmRemoveTitle(String name) {
    return 'Retirer $name ?';
  }

  @override
  String membersConfirmRemoveText(String name, String org) {
    return '$name n’aura plus accès aux projets de l’organisation $org. Vous pourrez l’inviter à nouveau plus tard.';
  }

  @override
  String get membersConfirmRemoveConfirm => 'Retirer';

  @override
  String membersToastInvitationSent(String email) {
    return 'Invitation envoyée à $email.';
  }

  @override
  String membersToastInvitationResent(String email) {
    return 'Invitation renvoyée à $email.';
  }

  @override
  String get membersToastInvitationCanceled => 'Invitation annulée.';

  @override
  String membersToastRoleChanged(String name, String role) {
    return '$name a maintenant le rôle $role.';
  }

  @override
  String membersToastRemoved(String name, String org) {
    return '$name ne fait plus partie de l’organisation $org.';
  }

  @override
  String membersErrorLimit(String max) {
    return 'Votre formule Free compte déjà $max membres. Passez en Pro pour en inviter d’autres.';
  }

  @override
  String membersErrorAlreadyMember(String email, String org) {
    return '$email fait déjà partie de l’organisation $org.';
  }

  @override
  String membersErrorAlreadyInvited(String email) {
    return 'Une invitation est déjà en attente pour $email.';
  }

  @override
  String invitationTitle(String org) {
    return 'Rejoindre $org';
  }

  @override
  String invitationText(String inviter, String org) {
    return '$inviter vous invite à rejoindre l’organisation $org sur LaunchKit.';
  }

  @override
  String get invitationProposedRole => 'Rôle proposé';

  @override
  String invitationSignedInAs(String email) {
    return 'Compte connecté : $email';
  }

  @override
  String get invitationAccept => 'Accepter l’invitation';

  @override
  String get invitationDecline => 'Refuser';

  @override
  String invitationAccepted(String org) {
    return 'Bienvenue dans $org !';
  }

  @override
  String get invitationDeclined => 'Invitation refusée.';

  @override
  String invitationExpired(String inviter) {
    return 'Cette invitation a expiré. Demandez à $inviter de vous en envoyer une nouvelle.';
  }

  @override
  String invitationWrongAccount(String email) {
    return 'Cette invitation est destinée à $email. Connectez-vous avec cette adresse pour l’accepter.';
  }

  @override
  String get billingTitle => 'Abonnement';

  @override
  String get billingIntro => 'Réservé au propriétaire et aux admins. Les paiements de la démo sont simulés.';

  @override
  String get billingCurrentPlan => 'Formule actuelle';

  @override
  String get billingLimitReached => 'Limite atteinte';

  @override
  String billingUsage(String max, String used) {
    return '$used / $max';
  }

  @override
  String get billingUnlimited => 'illimité';

  @override
  String get billingPerMonth => '/ mois';

  @override
  String get billingPerMonthSimulated => '/ mois (simulé)';

  @override
  String get billingRecommended => 'Recommandé';

  @override
  String billingFreeProjects(String n) {
    return '$n projets';
  }

  @override
  String billingFreeMembers(String n) {
    return '$n membres';
  }

  @override
  String get billingFreeSupport => 'Support communautaire';

  @override
  String get billingProProjects => 'Projets illimités';

  @override
  String get billingProMembers => 'Membres illimités';

  @override
  String get billingProSupport => 'Support prioritaire';

  @override
  String get billingSimulatedNote =>
      'Paiement simulé : « Passer en Pro » envoie un faux webhook, traité par le worker Rust. Aucune carte n’est demandée.';

  @override
  String get billingConfirming => 'Confirmation du paiement en cours…';

  @override
  String get billingProActivatedTitle => 'Bienvenue dans Pro';

  @override
  String billingProActivatedText(String org) {
    return '$org passe en Pro : projets et membres illimités. Dans cette démo, le paiement est simulé.';
  }

  @override
  String get projectsTitle => 'Projets';

  @override
  String get projectsIntro => 'Module d’exemple : c’est ici que se branche le métier de chaque client.';

  @override
  String get projectsNew => 'Nouveau projet';

  @override
  String projectsLimitAlert(String max, String used) {
    return 'Vous avez atteint la limite de la formule Free : $used projets sur $max. Passez en Pro pour en créer d’autres.';
  }

  @override
  String get projectsLockedTitle => 'Projet suivant : disponible en Pro';

  @override
  String get projectsLockedDesc => 'Passez en Pro pour créer autant de projets que nécessaire.';

  @override
  String get projectsEmptyTitle => 'Aucun projet pour l’instant';

  @override
  String projectsEmptyText(String max) {
    return 'Créez votre premier projet pour organiser le travail de votre équipe. La formule Free en compte jusqu’à $max.';
  }

  @override
  String get projectsEmptyCreate => 'Créer un projet';

  @override
  String get projectsDetailDescription => 'Description';

  @override
  String get projectsDetailHistory => 'Historique';

  @override
  String get projectsDetailDetails => 'Informations';

  @override
  String get projectsDetailStatus => 'Statut';

  @override
  String get projectsDetailLead => 'Responsable';

  @override
  String get projectsDetailDue => 'Échéance';

  @override
  String get projectsDetailCreatedOn => 'Créé le';

  @override
  String get projectsDetailMembers => 'Membres du projet';

  @override
  String get projectsDetailEditProject => 'Modifier le projet';

  @override
  String projectsHistoryStatusChanged(String name, String status) {
    return '$name a changé le statut en « $status »';
  }

  @override
  String projectsHistoryDescriptionChanged(String name) {
    return '$name a modifié la description';
  }

  @override
  String projectsHistoryCreated(String name) {
    return '$name a créé le projet';
  }

  @override
  String projectsHistoryStatusChangedShort(String status) {
    return 'Statut passé à « $status »';
  }

  @override
  String get projectsHistoryDescriptionChangedShort => 'Description modifiée';

  @override
  String get projectsFormName => 'Nom du projet';

  @override
  String get projectsFormNameHelp => 'Un nom court que toute l’équipe reconnaîtra.';

  @override
  String get projectsFormNameExample => 'Site vitrine';

  @override
  String get projectsFormDescription => 'Description';

  @override
  String get projectsFormDescriptionExample => 'Refonte du site de l’agence…';

  @override
  String get projectsFormCreate => 'Créer le projet';

  @override
  String projectsConfirmDeleteTitle(String project) {
    return 'Supprimer « $project » ?';
  }

  @override
  String get projectsConfirmDeleteText => 'Le projet et son historique seront supprimés définitivement.';

  @override
  String projectsToastCreated(String project) {
    return 'Projet « $project » créé.';
  }

  @override
  String get projectsToastSaved => 'Modifications enregistrées.';

  @override
  String get projectsToastDeleted => 'Projet supprimé.';

  @override
  String get adminArea => 'Back-office';

  @override
  String get adminSuperAdmin => 'Super-admin';

  @override
  String get adminNavOverview => 'Vue d’ensemble';

  @override
  String get adminNavOrgs => 'Organisations';

  @override
  String get adminNavUsers => 'Utilisateurs';

  @override
  String get adminNavPlans => 'Formules';

  @override
  String get adminOrgsIntro => 'Toutes les organisations de la démo. Visible uniquement par le super-admin.';

  @override
  String get adminStatOrgs => 'Organisations';

  @override
  String get adminStatUsers => 'Utilisateurs';

  @override
  String get adminStatPro => 'En Pro';

  @override
  String get adminStatProSub => 'simulé';

  @override
  String get adminStatJobs => 'Tâches du worker';

  @override
  String get adminStatJobsSub => 'en attente';

  @override
  String get adminColOrg => 'Organisation';

  @override
  String get adminColPlan => 'Formule';

  @override
  String get adminColMembers => 'Membres';

  @override
  String get adminColProjects => 'Projets';

  @override
  String get adminColCreated => 'Créée le';

  @override
  String get mobileOrgsTitle => 'Vos organisations';

  @override
  String get mobileOrgsSubtitle => 'Choisissez l’espace sur lequel travailler.';

  @override
  String mobileOrgsDesc(int members, String plan) {
    String _temp0 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members membres',
      one: '$members membre',
    );
    return 'Formule $plan · $_temp0';
  }

  @override
  String get mobileOrgsCreate => 'Créer une organisation';

  @override
  String mobileOrgsContinueWith(String org) {
    return 'Continuer avec $org';
  }

  @override
  String mobileProjectsLimit(String max, String used) {
    return 'Free : $used projets sur $max. Passez en Pro.';
  }

  @override
  String get mobileDemoEmailHint => 'Démo : utilisez une adresse en @demo.test';

  @override
  String get mobileBillingNote => 'Paiement simulé : aucune carte demandée.';

  @override
  String get mobileProfileAccount => 'Compte';

  @override
  String get mobileProfileOrganization => 'Organisation';

  @override
  String get mobileProfileNotifications => 'Notifications';

  @override
  String get mobileProfileNotificationsOn => 'Activées';

  @override
  String get mobileProfilePassword => 'Mot de passe';

  @override
  String get mobileProfileChange => 'Modifier';

  @override
  String get validationRequired => 'Ce champ est obligatoire.';

  @override
  String get validationEmailInvalid => 'Saisissez une adresse e-mail valide, par exemple marie@demo.test.';

  @override
  String validationPasswordShort(String min) {
    return 'Le mot de passe doit contenir au moins $min caractères.';
  }

  @override
  String validationTooLong(String max) {
    return '$max caractères maximum.';
  }

  @override
  String get validationEmailTaken =>
      'Un compte existe déjà avec cette adresse. Connectez-vous ou utilisez une autre adresse.';

  @override
  String get validationLoginFailed => 'E-mail ou mot de passe incorrect.';

  @override
  String get validationEmailNotVerified => 'Vérifiez d’abord votre adresse : nous vous avons envoyé un lien.';

  @override
  String get errorNotFoundTitle => 'Page introuvable';

  @override
  String get errorNotFoundText =>
      'Cette page n’existe pas ou a été déplacée. Vérifiez l’adresse ou revenez à l’accueil.';

  @override
  String get errorForbiddenTitle => 'Accès refusé';

  @override
  String errorForbiddenText(String org) {
    return 'Votre rôle ne permet pas d’ouvrir cette page. Demandez l’accès à un administrateur de l’organisation $org.';
  }

  @override
  String get errorForbiddenAdminOnly => 'Cette page est réservée au super-admin de la démo.';

  @override
  String get errorServerTitle => 'Un problème est survenu';

  @override
  String get errorServerText => 'Réessayez dans un instant. Si le problème continue, rechargez la page.';

  @override
  String get errorNetwork => 'Connexion impossible. Vérifiez votre réseau, puis réessayez.';

  @override
  String get errorSessionExpired => 'Votre session a expiré. Reconnectez-vous pour continuer.';

  @override
  String get errorOwnerProtected => 'Le rôle de propriétaire ne peut être ni modifié ni retiré.';

  @override
  String get errorInvitationUnavailable => 'Cette invitation n’est plus valable.';

  @override
  String get errorInvalidLink => 'Ce lien n’est pas valable. Demandez-en un nouveau.';

  @override
  String get errorInvalidRequest => 'Certaines informations sont manquantes ou incorrectes.';

  @override
  String get errorAlreadyPro => 'Cette organisation est déjà en formule Pro.';

  @override
  String get emailVerifySubject => 'Confirmez votre adresse e-mail';

  @override
  String get emailVerifyPreheader => 'Un clic pour activer votre compte LaunchKit.';

  @override
  String get emailVerifyTitle => 'Confirmez votre adresse';

  @override
  String emailVerifyBody(String firstName) {
    return 'Bonjour $firstName, cliquez sur le bouton ci-dessous pour activer votre compte LaunchKit.';
  }

  @override
  String get emailVerifyButton => 'Activer mon compte';

  @override
  String emailVerifyExpiry(String hours) {
    return 'Ce lien est valable $hours heures.';
  }

  @override
  String get emailVerifyIgnore => 'Vous n’avez pas créé de compte ? Ignorez simplement cet e-mail.';

  @override
  String emailInviteSubject(String inviter, String org) {
    return '$inviter vous invite à rejoindre $org';
  }

  @override
  String emailInvitePreheader(String org) {
    return 'Rejoignez l’équipe $org sur LaunchKit.';
  }

  @override
  String emailInviteTitle(String org) {
    return 'Rejoignez $org';
  }

  @override
  String emailInviteBody(String inviter, String org, String role) {
    return '$inviter vous invite à rejoindre l’organisation $org sur LaunchKit, avec le rôle $role.';
  }

  @override
  String get emailInviteButton => 'Accepter l’invitation';

  @override
  String emailInviteExpiry(String days) {
    return 'L’invitation est valable $days jours.';
  }

  @override
  String emailInviteIgnore(String inviter) {
    return 'Vous ne connaissez pas $inviter ? Ignorez cet e-mail.';
  }

  @override
  String emailProWelcomeSubject(String org) {
    return '$org passe en Pro';
  }

  @override
  String get emailProWelcomePreheader => 'Projets et membres illimités, dès maintenant.';

  @override
  String get emailProWelcomeTitle => 'Bienvenue dans Pro';

  @override
  String emailProWelcomeBody(String firstName, String org) {
    return 'Bonjour $firstName, $org est maintenant en formule Pro : projets et membres illimités. Dans cette démo, le paiement est simulé.';
  }

  @override
  String get emailProWelcomeButton => 'Ouvrir LaunchKit';

  @override
  String get emailFooter => 'LaunchKit · démo portfolio · e-mail envoyé dans la boîte de test Mailpit.';
}
