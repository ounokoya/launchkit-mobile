// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonNavDashboard => 'Dashboard';

  @override
  String get commonNavProjects => 'Projects';

  @override
  String get commonNavMembers => 'Members';

  @override
  String get commonNavBilling => 'Billing';

  @override
  String get commonNavSettings => 'Settings';

  @override
  String get commonNavProfile => 'Profile';

  @override
  String get commonSearch => 'Search…';

  @override
  String get commonLanguageLabel => 'Language';

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
    return '$plan plan';
  }

  @override
  String get commonRoleOwner => 'Owner';

  @override
  String get commonRoleAdmin => 'Admin';

  @override
  String get commonRoleMember => 'Member';

  @override
  String get commonRoleAdminDesc => 'Manages members and billing';

  @override
  String get commonRoleMemberDesc => 'Works on projects';

  @override
  String get commonStatusActive => 'Active';

  @override
  String get commonStatusInProgress => 'In progress';

  @override
  String get commonStatusDraft => 'Draft';

  @override
  String get commonStatusPending => 'Pending';

  @override
  String get commonActionSave => 'Save';

  @override
  String get commonActionCancel => 'Cancel';

  @override
  String get commonActionContinue => 'Continue';

  @override
  String get commonActionEdit => 'Edit';

  @override
  String get commonActionDelete => 'Delete';

  @override
  String get commonActionClose => 'Close';

  @override
  String get commonActionRetry => 'Try again';

  @override
  String get commonActionSeeAll => 'See all';

  @override
  String get commonActionBackHome => 'Back to home';

  @override
  String get commonActionBackDashboard => 'Back to dashboard';

  @override
  String get commonActionSignOut => 'Sign out';

  @override
  String get commonTimeJustNow => 'just now';

  @override
  String commonTimeMinutesAgo(String n) {
    return '$n min ago';
  }

  @override
  String commonTimeHoursAgo(String n) {
    return '$n h ago';
  }

  @override
  String get commonTimeYesterday => 'yesterday';

  @override
  String get commonTimeToday => 'today';

  @override
  String commonTimeDaysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n days', one: '$n day');
    return '$_temp0 ago';
  }

  @override
  String commonMetaEdited(String when) {
    return 'Edited $when';
  }

  @override
  String commonMetaCreated(String when) {
    return 'Created $when';
  }

  @override
  String get commonDemoEmailHint => 'Demo: use a made-up address, like marie@demo.test';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonA11ySwitchLanguage => 'Change language';

  @override
  String get commonA11ySwitchOrg => 'Switch organization';

  @override
  String get commonA11yNotifications => 'Notifications';

  @override
  String get commonA11yAccountMenu => 'Account menu';

  @override
  String get commonA11yOpenMenu => 'Open menu';

  @override
  String get homeNavFeatures => 'Features';

  @override
  String get homeNavPricing => 'Pricing';

  @override
  String get homeNavMethod => 'Method';

  @override
  String get homeNavSource => 'Source code';

  @override
  String get homeNavLogin => 'Sign in';

  @override
  String get homeCtaTryDemo => 'Try the demo';

  @override
  String get homeCtaViewCode => 'View the code';

  @override
  String get homeHeroBadge => 'SaaS starter kit · open source';

  @override
  String get homeHeroTitle => 'Your MVP in 2 weeks, on a ready-made foundation';

  @override
  String get homeHeroSubtitle =>
      'Accounts, organizations, roles, subscriptions and an admin back office are already in place. I start from this kit to deliver your product fast, at a fixed price.';

  @override
  String get homeHeroDemoNote => 'Demo: sign up with a made-up address, like marie@demo.test';

  @override
  String get homePreviewProject1 => 'Company website';

  @override
  String get homePreviewProject2 => 'Mobile app';

  @override
  String get homePreviewProject3 => 'Sales dashboard';

  @override
  String get homePreviewEditedRecently => 'Edited recently';

  @override
  String get homeFeaturesTitle => 'Everything a SaaS needs, already built';

  @override
  String get homeFeaturesSubtitle => 'We go straight to what makes your product unique.';

  @override
  String get homeFeaturesAccountsTitle => 'Accounts and sign-in';

  @override
  String get homeFeaturesAccountsDesc => 'Sign-up, sign-in and email verification.';

  @override
  String get homeFeaturesTenancyTitle => 'Multi-tenant';

  @override
  String get homeFeaturesTenancyDesc => 'Each customer gets its own organization and data.';

  @override
  String get homeFeaturesRolesTitle => 'Roles and invitations';

  @override
  String get homeFeaturesRolesDesc => 'Owner, admin and member, with email invitations.';

  @override
  String get homeFeaturesPlansTitle => 'Free and Pro plans';

  @override
  String get homeFeaturesPlansDesc => 'Per-plan limits and a swappable payment provider.';

  @override
  String get homeFeaturesBackofficeTitle => 'Admin back office';

  @override
  String get homeFeaturesBackofficeDesc => 'Super admin view of organizations and users.';

  @override
  String get homeFeaturesI18nTitle => 'French and English';

  @override
  String get homeFeaturesI18nDesc => 'Bilingual interface, ready for more languages.';

  @override
  String get homeStackLabel => 'Stack';

  @override
  String get homeStackRustWorker => 'Rust worker';

  @override
  String get homeMethodTitle => 'My method, in 4 steps';

  @override
  String get homeMethodSpecTitle => 'Spec';

  @override
  String get homeMethodSpecDesc => 'What we build, written down and approved with you.';

  @override
  String get homeMethodDecisionsTitle => 'Decisions';

  @override
  String get homeMethodDecisionsDesc => 'Every technical choice is recorded and explained.';

  @override
  String get homeMethodTestsTitle => 'Tests';

  @override
  String get homeMethodTestsDesc => 'Tests come straight from the spec.';

  @override
  String get homeMethodChangelogTitle => 'Changelog';

  @override
  String get homeMethodChangelogDesc => 'Every release is versioned and documented.';

  @override
  String get homeFooterCta => 'Need an MVP? Let’s talk about your project.';

  @override
  String get homeFooterContact => 'Contact me';

  @override
  String homeFooterLegal(String year) {
    return '© $year LaunchKit · portfolio demo · FR / EN';
  }

  @override
  String get homeFooterAndroid => 'Android app';

  @override
  String get authSideSignupTitle => 'Launch your SaaS on a ready-made foundation';

  @override
  String get authSideSignupPoint1 => 'Accounts and organizations';

  @override
  String get authSideSignupPoint2 => 'Roles and invitations';

  @override
  String get authSideSignupPoint3 => 'Free and Pro plans';

  @override
  String get authSideLoginTitle => 'Welcome back';

  @override
  String get authSideLoginPoint1 => 'Pick up where you left off';

  @override
  String get authSideLoginPoint2 => 'Switch organizations in one click';

  @override
  String get authSideLoginPoint3 => 'Interface in French or English';

  @override
  String get authFieldFullName => 'Full name';

  @override
  String get authFieldEmail => 'Email';

  @override
  String get authFieldPassword => 'Password';

  @override
  String get authSignupTitle => 'Create an account';

  @override
  String get authSignupSubtitle => 'Free, no credit card needed.';

  @override
  String get authSignupEmailHelp => 'Use a made-up address: the demo only sends emails to a test inbox.';

  @override
  String authSignupPasswordHelp(String min) {
    return 'At least $min characters.';
  }

  @override
  String get authSignupSubmit => 'Create my account';

  @override
  String get authSignupHaveAccount => 'Already have an account?';

  @override
  String get authSignupGoLogin => 'Sign in';

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authLoginSubtitle => 'Sign in to your LaunchKit workspace.';

  @override
  String get authLoginSubmit => 'Sign in';

  @override
  String get authLoginNoAccount => 'No account yet?';

  @override
  String get authLoginGoSignup => 'Sign up';

  @override
  String get authVerifyTitle => 'Check your email';

  @override
  String authVerifyText(String email) {
    return 'We sent a verification link to $email. Click it to activate your account.';
  }

  @override
  String get authVerifyDemoNote => 'Demo: the email lands in the Mailpit test inbox.';

  @override
  String get authVerifyOpenInbox => 'Open the demo inbox';

  @override
  String get authVerifyResend => 'Resend the email';

  @override
  String authVerifyResent(String email) {
    return 'Email sent again to $email.';
  }

  @override
  String get authVerifyVerified => 'Email verified. Welcome!';

  @override
  String get authVerifyLinkExpired => 'This link has expired. Request a new one from the verification screen.';

  @override
  String onboardingStep(String current, String total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingOrgTitle => 'Create your organization';

  @override
  String get onboardingOrgText => 'Your company, your team and your projects in one place. You will be its owner.';

  @override
  String get onboardingOrgName => 'Organization name';

  @override
  String get onboardingOrgNameHelp => 'You can change it later.';

  @override
  String onboardingDefaultPlan(String members, String projects) {
    return 'You start on the Free plan: $projects projects and $members members.';
  }

  @override
  String get onboardingSubmit => 'Create the organization';

  @override
  String dashboardGreeting(String firstName) {
    return 'Hello $firstName 👋';
  }

  @override
  String dashboardIntro(String org) {
    return 'Here’s what’s happening in $org.';
  }

  @override
  String get dashboardStatPlan => 'Plan';

  @override
  String get dashboardStatProjects => 'Projects';

  @override
  String dashboardStatProjectsSub(String max) {
    return 'of $max max';
  }

  @override
  String get dashboardStatMembers => 'Members';

  @override
  String get dashboardStatMembersSub => 'active';

  @override
  String get dashboardStatInvitations => 'Invitations';

  @override
  String get dashboardStatInvitationsSub => 'pending';

  @override
  String get dashboardRecentProjects => 'Recent projects';

  @override
  String dashboardFreeSlot(int remaining) {
    return 'New project ($remaining left on the Free plan)';
  }

  @override
  String get dashboardActivityTitle => 'Recent activity';

  @override
  String dashboardActivityMemberJoined(String name, String org) {
    return '$name joined $org';
  }

  @override
  String dashboardActivityProjectCreated(String name, String project) {
    return '$name created “$project”';
  }

  @override
  String dashboardActivityInvitationSent(String email) {
    return 'Invitation sent to $email';
  }

  @override
  String dashboardActivityOrgCreated(String org) {
    return 'Organization $org created';
  }

  @override
  String get dashboardActivityEmpty => 'No activity yet. It will show up here as soon as your team works on a project.';

  @override
  String get upgradeBannerTitle => 'Upgrade to Pro for unlimited projects';

  @override
  String get upgradeBannerDesc => 'Payment is simulated in the demo: no real charge is made.';

  @override
  String get upgradeSeePlans => 'See plans';

  @override
  String get upgradeButton => 'Upgrade to Pro';

  @override
  String get membersTitle => 'Organization members';

  @override
  String membersSummaryActive(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n active members', one: '$n active member');
    return '$_temp0';
  }

  @override
  String membersSummaryPending(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pending invitations',
      one: '$n pending invitation',
    );
    return '$_temp0';
  }

  @override
  String membersSummaryLimit(String max, String plan) {
    return '$plan plan: up to $max members';
  }

  @override
  String get membersColMember => 'Member';

  @override
  String get membersColRole => 'Role';

  @override
  String get membersColStatus => 'Status';

  @override
  String get membersInviteTitle => 'Invite a member';

  @override
  String get membersInviteDesc => 'An invitation email goes to the demo inbox.';

  @override
  String get membersInviteRole => 'Role';

  @override
  String get membersInviteSubmit => 'Send invitation';

  @override
  String get membersRolesHelpTitle => 'Who can do what?';

  @override
  String get membersRolesHelpOwner => 'Owner: everything, including deleting the organization.';

  @override
  String get membersRolesHelpAdmin => 'Admin: members, invitations and billing.';

  @override
  String get membersRolesHelpMember => 'Member: projects only, no access to billing.';

  @override
  String get membersEmptyTitle => 'Invite your team';

  @override
  String membersEmptyText(String org) {
    return 'For now, $org has only one member. Invite your colleagues to work together.';
  }

  @override
  String get membersActionChangeRole => 'Change role';

  @override
  String get membersActionRemove => 'Remove from organization';

  @override
  String get membersActionResendInvite => 'Resend invitation';

  @override
  String get membersActionCancelInvite => 'Cancel invitation';

  @override
  String membersConfirmRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String membersConfirmRemoveText(String name, String org) {
    return '$name will lose access to $org’s projects. You can invite them again later.';
  }

  @override
  String get membersConfirmRemoveConfirm => 'Remove';

  @override
  String membersToastInvitationSent(String email) {
    return 'Invitation sent to $email.';
  }

  @override
  String membersToastInvitationResent(String email) {
    return 'Invitation sent again to $email.';
  }

  @override
  String get membersToastInvitationCanceled => 'Invitation canceled.';

  @override
  String membersToastRoleChanged(String name, String role) {
    return '$name is now $role.';
  }

  @override
  String membersToastRemoved(String name, String org) {
    return '$name is no longer part of $org.';
  }

  @override
  String membersErrorLimit(String max) {
    return 'Your Free plan already has $max members. Upgrade to Pro to invite more.';
  }

  @override
  String membersErrorAlreadyMember(String email, String org) {
    return '$email is already a member of $org.';
  }

  @override
  String membersErrorAlreadyInvited(String email) {
    return 'An invitation is already pending for $email.';
  }

  @override
  String invitationTitle(String org) {
    return 'Join $org';
  }

  @override
  String invitationText(String inviter, String org) {
    return '$inviter invited you to join the $org organization on LaunchKit.';
  }

  @override
  String get invitationProposedRole => 'Proposed role';

  @override
  String invitationSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get invitationAccept => 'Accept invitation';

  @override
  String get invitationDecline => 'Decline';

  @override
  String invitationAccepted(String org) {
    return 'Welcome to $org!';
  }

  @override
  String get invitationDeclined => 'Invitation declined.';

  @override
  String invitationExpired(String inviter) {
    return 'This invitation has expired. Ask $inviter to send you a new one.';
  }

  @override
  String invitationWrongAccount(String email) {
    return 'This invitation is for $email. Sign in with that address to accept it.';
  }

  @override
  String get billingTitle => 'Billing';

  @override
  String get billingIntro => 'For the owner and admins only. Payments in the demo are simulated.';

  @override
  String get billingCurrentPlan => 'Current plan';

  @override
  String get billingLimitReached => 'Limit reached';

  @override
  String billingUsage(String max, String used) {
    return '$used / $max';
  }

  @override
  String get billingUnlimited => 'unlimited';

  @override
  String get billingPerMonth => '/ month';

  @override
  String get billingPerMonthSimulated => '/ month (simulated)';

  @override
  String get billingRecommended => 'Recommended';

  @override
  String billingFreeProjects(String n) {
    return '$n projects';
  }

  @override
  String billingFreeMembers(String n) {
    return '$n members';
  }

  @override
  String get billingFreeSupport => 'Community support';

  @override
  String get billingProProjects => 'Unlimited projects';

  @override
  String get billingProMembers => 'Unlimited members';

  @override
  String get billingProSupport => 'Priority support';

  @override
  String get billingSimulatedNote =>
      'Simulated payment: “Upgrade to Pro” sends a fake webhook, processed by the Rust worker. No card is required.';

  @override
  String get billingConfirming => 'Confirming payment…';

  @override
  String get billingProActivatedTitle => 'Welcome to Pro';

  @override
  String billingProActivatedText(String org) {
    return '$org is now on Pro: unlimited projects and members. In this demo, payment is simulated.';
  }

  @override
  String get projectsTitle => 'Projects';

  @override
  String get projectsIntro => 'Sample module: this is where each customer’s business logic plugs in.';

  @override
  String get projectsNew => 'New project';

  @override
  String projectsLimitAlert(String max, String used) {
    return 'You’ve reached the Free plan limit: $used of $max projects. Upgrade to Pro to create more.';
  }

  @override
  String get projectsLockedTitle => 'Next project: available on Pro';

  @override
  String get projectsLockedDesc => 'Upgrade to Pro to create as many projects as you need.';

  @override
  String get projectsEmptyTitle => 'No projects yet';

  @override
  String projectsEmptyText(String max) {
    return 'Create your first project to organize your team’s work. The Free plan includes up to $max.';
  }

  @override
  String get projectsEmptyCreate => 'Create a project';

  @override
  String get projectsDetailDescription => 'Description';

  @override
  String get projectsDetailHistory => 'History';

  @override
  String get projectsDetailDetails => 'Details';

  @override
  String get projectsDetailStatus => 'Status';

  @override
  String get projectsDetailLead => 'Lead';

  @override
  String get projectsDetailDue => 'Due date';

  @override
  String get projectsDetailCreatedOn => 'Created on';

  @override
  String get projectsDetailMembers => 'Project members';

  @override
  String get projectsDetailEditProject => 'Edit project';

  @override
  String projectsHistoryStatusChanged(String name, String status) {
    return '$name changed the status to “$status”';
  }

  @override
  String projectsHistoryDescriptionChanged(String name) {
    return '$name edited the description';
  }

  @override
  String projectsHistoryCreated(String name) {
    return '$name created the project';
  }

  @override
  String projectsHistoryStatusChangedShort(String status) {
    return 'Status changed to “$status”';
  }

  @override
  String get projectsHistoryDescriptionChangedShort => 'Description edited';

  @override
  String get projectsFormName => 'Project name';

  @override
  String get projectsFormNameHelp => 'A short name your whole team will recognize.';

  @override
  String get projectsFormNameExample => 'Company website';

  @override
  String get projectsFormDescription => 'Description';

  @override
  String get projectsFormDescriptionExample => 'Redesign of the agency website…';

  @override
  String get projectsFormCreate => 'Create project';

  @override
  String projectsConfirmDeleteTitle(String project) {
    return 'Delete “$project”?';
  }

  @override
  String get projectsConfirmDeleteText => 'The project and its history will be permanently deleted.';

  @override
  String projectsToastCreated(String project) {
    return 'Project “$project” created.';
  }

  @override
  String get projectsToastSaved => 'Changes saved.';

  @override
  String get projectsToastDeleted => 'Project deleted.';

  @override
  String get adminArea => 'Back office';

  @override
  String get adminSuperAdmin => 'Super admin';

  @override
  String get adminNavOverview => 'Overview';

  @override
  String get adminNavOrgs => 'Organizations';

  @override
  String get adminNavUsers => 'Users';

  @override
  String get adminNavPlans => 'Plans';

  @override
  String get adminOrgsIntro => 'Every organization in the demo. Visible to the super admin only.';

  @override
  String get adminStatOrgs => 'Organizations';

  @override
  String get adminStatUsers => 'Users';

  @override
  String get adminStatPro => 'On Pro';

  @override
  String get adminStatProSub => 'simulated';

  @override
  String get adminStatJobs => 'Worker jobs';

  @override
  String get adminStatJobsSub => 'pending';

  @override
  String get adminColOrg => 'Organization';

  @override
  String get adminColPlan => 'Plan';

  @override
  String get adminColMembers => 'Members';

  @override
  String get adminColProjects => 'Projects';

  @override
  String get adminColCreated => 'Created';

  @override
  String get mobileOrgsTitle => 'Your organizations';

  @override
  String get mobileOrgsSubtitle => 'Choose the workspace to work in.';

  @override
  String mobileOrgsDesc(int members, String plan) {
    String _temp0 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members members',
      one: '$members member',
    );
    return '$plan plan · $_temp0';
  }

  @override
  String get mobileOrgsCreate => 'Create an organization';

  @override
  String mobileOrgsContinueWith(String org) {
    return 'Continue with $org';
  }

  @override
  String mobileProjectsLimit(String max, String used) {
    return 'Free: $used of $max projects. Upgrade to Pro.';
  }

  @override
  String get mobileDemoEmailHint => 'Demo: use an @demo.test address';

  @override
  String get mobileBillingNote => 'Simulated payment: no card required.';

  @override
  String get mobileProfileAccount => 'Account';

  @override
  String get mobileProfileOrganization => 'Organization';

  @override
  String get mobileProfileNotifications => 'Notifications';

  @override
  String get mobileProfileNotificationsOn => 'On';

  @override
  String get mobileProfilePassword => 'Password';

  @override
  String get mobileProfileChange => 'Change';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationEmailInvalid => 'Enter a valid email address, for example marie@demo.test.';

  @override
  String validationPasswordShort(String min) {
    return 'Password must be at least $min characters.';
  }

  @override
  String validationTooLong(String max) {
    return '$max characters maximum.';
  }

  @override
  String get validationEmailTaken => 'An account already exists with this email. Sign in or use another address.';

  @override
  String get validationLoginFailed => 'Incorrect email or password.';

  @override
  String get validationEmailNotVerified => 'Verify your email first: we sent you a link.';

  @override
  String get errorNotFoundTitle => 'Page not found';

  @override
  String get errorNotFoundText =>
      'This page doesn’t exist or has moved. Check the address or go back to the home page.';

  @override
  String get errorForbiddenTitle => 'Access denied';

  @override
  String errorForbiddenText(String org) {
    return 'Your role doesn’t allow you to open this page. Ask an admin of $org for access.';
  }

  @override
  String get errorForbiddenAdminOnly => 'This page is only for the demo’s super admin.';

  @override
  String get errorServerTitle => 'Something went wrong';

  @override
  String get errorServerText => 'Try again in a moment. If the problem persists, reload the page.';

  @override
  String get errorNetwork => 'Can’t connect. Check your network, then try again.';

  @override
  String get errorSessionExpired => 'Your session has expired. Sign in again to continue.';

  @override
  String get errorOwnerProtected => 'The owner role can’t be changed or removed.';

  @override
  String get errorInvitationUnavailable => 'This invitation is no longer valid.';

  @override
  String get errorInvalidLink => 'This link isn’t valid. Request a new one.';

  @override
  String get errorInvalidRequest => 'Some information is missing or incorrect.';

  @override
  String get errorAlreadyPro => 'This organization is already on the Pro plan.';

  @override
  String get emailVerifySubject => 'Confirm your email address';

  @override
  String get emailVerifyPreheader => 'One click to activate your LaunchKit account.';

  @override
  String get emailVerifyTitle => 'Confirm your email';

  @override
  String emailVerifyBody(String firstName) {
    return 'Hi $firstName, click the button below to activate your LaunchKit account.';
  }

  @override
  String get emailVerifyButton => 'Activate my account';

  @override
  String emailVerifyExpiry(String hours) {
    return 'This link is valid for $hours hours.';
  }

  @override
  String get emailVerifyIgnore => 'Didn’t create an account? Just ignore this email.';

  @override
  String emailInviteSubject(String inviter, String org) {
    return '$inviter invited you to join $org';
  }

  @override
  String emailInvitePreheader(String org) {
    return 'Join the $org team on LaunchKit.';
  }

  @override
  String emailInviteTitle(String org) {
    return 'Join $org';
  }

  @override
  String emailInviteBody(String inviter, String org, String role) {
    return '$inviter invited you to join the $org organization on LaunchKit as $role.';
  }

  @override
  String get emailInviteButton => 'Accept invitation';

  @override
  String emailInviteExpiry(String days) {
    return 'The invitation is valid for $days days.';
  }

  @override
  String emailInviteIgnore(String inviter) {
    return 'Don’t know $inviter? Ignore this email.';
  }

  @override
  String emailProWelcomeSubject(String org) {
    return '$org is now on Pro';
  }

  @override
  String get emailProWelcomePreheader => 'Unlimited projects and members, starting now.';

  @override
  String get emailProWelcomeTitle => 'Welcome to Pro';

  @override
  String emailProWelcomeBody(String firstName, String org) {
    return 'Hi $firstName, $org is now on the Pro plan: unlimited projects and members. In this demo, payment is simulated.';
  }

  @override
  String get emailProWelcomeButton => 'Open LaunchKit';

  @override
  String get emailFooter => 'LaunchKit · portfolio demo · sent to the Mailpit test inbox.';
}
