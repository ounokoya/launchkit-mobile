// Routes ↔ screens (spec mobile.md) and the redirection rules, kept in one pure function for the tests.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/auth_screens.dart';
import 'screens/billing_screen.dart';
import 'screens/common.dart';
import 'screens/home_shell.dart';
import 'screens/invitation_screen.dart';
import 'screens/members_screen.dart';
import 'screens/orgs_screens.dart';
import 'screens/profile_screen.dart';
import 'screens/project_screens.dart';
import 'state/session.dart';

const _public = {'/login', '/signup', '/verify-email'};

String? _safe(String? path) => path != null && path.startsWith('/') && !path.startsWith('//') ? path : null;

/// Where to go instead of [uri] for this session, or null to stay.
String? redirectFor(SessionState s, Uri uri) {
  final path = uri.path;
  if (path == '/splash') return s.ready ? (_safe(uri.queryParameters['from']) ?? '/projects') : null;
  if (!s.ready) return '/splash?from=${Uri.encodeComponent(uri.toString())}';
  if (s.unavailable) return path == '/unavailable' ? null : '/unavailable';
  if (path == '/unavailable') return '/projects';

  final invitation = path.startsWith('/invitations/');
  if (!s.signedIn) {
    if (_public.contains(path) || invitation) return null; // the invitation screen sends to sign-in itself
    return path == '/projects' ? '/login' : '/login?next=${Uri.encodeComponent(uri.toString())}';
  }
  if (path == '/verify-email' && uri.queryParameters.containsKey('token')) return null;
  if (_public.contains(path)) return _safe(uri.queryParameters['next']) ?? '/projects';
  if (invitation) return null;
  if (s.organizations.isEmpty) return path == '/onboarding' ? null : '/onboarding';
  if (s.org == null && path != '/orgs' && path != '/onboarding') return '/orgs';
  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(sessionProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/projects',
    refreshListenable: refresh,
    redirect: (context, state) => redirectFor(ref.read(sessionProvider), state.uri),
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/unavailable', builder: (_, _) => const UnavailableScreen()),
      GoRoute(
        path: '/login',
        builder: (_, s) => LoginScreen(next: _safe(s.uri.queryParameters['next'])),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, s) => SignupScreen(next: _safe(s.uri.queryParameters['next'])),
      ),
      GoRoute(
        path: '/verify-email',
        // A new screen for each link: the app may already show « Vérifiez votre e-mail » when the link opens it.
        builder: (_, s) => VerifyEmailScreen(
          key: ValueKey(s.uri.toString()),
          token: s.uri.queryParameters['token'],
          email: s.uri.queryParameters['email'],
        ),
      ),
      GoRoute(path: '/orgs', builder: (_, _) => const OrgsScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(
        path: '/invitations/:token',
        builder: (_, s) => InvitationScreen(token: s.pathParameters['token']!),
      ),
      GoRoute(path: '/projects/new', builder: (_, _) => const ProjectFormScreen()),
      GoRoute(
        path: '/projects/:id',
        builder: (_, s) => ProjectScreen(id: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, s) => ProjectFormScreen(id: s.pathParameters['id']),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/projects', builder: (_, _) => const ProjectsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/members', builder: (_, _) => const MembersScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/billing', builder: (_, _) => const BillingScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen())],
          ),
        ],
      ),
    ],
  );
});
