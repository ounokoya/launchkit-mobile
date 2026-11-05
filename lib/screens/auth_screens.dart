// M01 Connexion (M01b session expirée, M01c mot de passe incorrect), M02 Inscription, M09 Vérifiez votre e-mail
// (M09b lien expiré ; with ?token= the link of the e-mail signs in).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../data/api.dart';
import '../router.dart';
import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

/// After a sign-in: the page asked for, the invitation remembered, or the projects.
Future<void> _continue(WidgetRef ref, String? next) async {
  final remembered = await ref.read(sessionProvider.notifier).takeNext();
  ref.read(routerProvider).go(next ?? remembered ?? '/projects');
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.next});
  final String? next;
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController(), _password = TextEditingController();
  ApiError? _error;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final session = await ref.read(apiProvider).login(_email.text.trim(), _password.text);
      await ref.read(sessionProvider.notifier).signIn(session);
      await _continue(ref, widget.next);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final expired = ref.watch(sessionProvider.select((s) => s.expired));
    final error = _error;
    final signupLink = '/signup${widget.next == null ? '' : '?next=${Uri.encodeComponent(widget.next!)}'}';
    return AuthScaffold(
      bottom: LkNote(t.mobileDemoEmailHint),
      children: [
        Semantics(header: true, child: Text(t.authLoginTitle, style: LkText.authTitle)),
        const SizedBox(height: 8),
        Text(t.authLoginSubtitle, style: LkText.subtitle),
        const SizedBox(height: 24),
        if (error != null && error.code != 'invalid_request') ...[
          LkAlert(errorText(t, error), tone: LkTone.danger, icon: 'lock'),
          if (error.code == 'email_not_verified')
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.go('/verify-email?email=${Uri.encodeComponent(_email.text.trim())}'),
                child: Text(t.authVerifyResend),
              ),
            ),
          const SizedBox(height: 16),
        ] else if (expired) ...[
          LkAlert(t.errorSessionExpired, icon: 'lock'),
          const SizedBox(height: 16),
        ],
        AutofillGroup(
          child: Column(
            children: [
              LkField(
                label: t.authFieldEmail,
                controller: _email,
                icon: 'mail',
                hint: 'marie@demo.test',
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                error: error?.field('email'),
              ),
              const SizedBox(height: 16),
              LkField(
                label: t.authFieldPassword,
                controller: _password,
                icon: 'lock',
                obscure: true,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                error: error?.field('password'),
                invalid: error?.code == 'login_failed',
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        LkButton(t.authLoginSubmit, onPressed: _submit, loading: _busy),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => context.go(signupLink),
            child: Text('${t.authLoginNoAccount} ${t.authLoginGoSignup}'),
          ),
        ),
      ],
    );
  }
}

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key, this.next});
  final String? next;
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _name = TextEditingController(), _email = TextEditingController(), _password = TextEditingController();
  ApiError? _error;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    final email = _email.text.trim();
    try {
      await ref
          .read(apiProvider)
          .register(name: _name.text.trim(), email: email, password: _password.text, locale: ref.read(localeProvider));
      if (widget.next != null) await ref.read(sessionProvider.notifier).rememberNext(widget.next!);
      if (mounted) context.go('/verify-email?email=${Uri.encodeComponent(email)}');
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final error = _error;
    return AuthScaffold(
      children: [
        Semantics(header: true, child: Text(t.authSignupTitle, style: LkText.authTitle)),
        const SizedBox(height: 8),
        Text(t.authSignupSubtitle, style: LkText.subtitle),
        const SizedBox(height: 24),
        if (error != null && error.errors.isEmpty) ...[
          LkAlert(errorText(t, error), tone: LkTone.danger),
          const SizedBox(height: 16),
        ],
        AutofillGroup(
          child: Column(
            children: [
              LkField(
                label: t.authFieldFullName,
                controller: _name,
                hint: 'Marie Koné',
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                error: error?.field('name'),
              ),
              const SizedBox(height: 16),
              LkField(
                label: t.authFieldEmail,
                controller: _email,
                icon: 'mail',
                hint: 'marie@demo.test',
                help: t.authSignupEmailHelp,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                error: error?.field('email'),
              ),
              const SizedBox(height: 16),
              LkField(
                label: t.authFieldPassword,
                controller: _password,
                icon: 'lock',
                obscure: true,
                help: t.authSignupPasswordHelp('8'),
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                error: error?.field('password'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        LkButton(t.authSignupSubmit, onPressed: _submit, loading: _busy),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () =>
                context.go(widget.next == null ? '/login' : '/login?next=${Uri.encodeComponent(widget.next!)}'),
            child: Text('${t.authSignupHaveAccount} ${t.authSignupGoLogin}'),
          ),
        ),
      ],
    );
  }
}

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key, this.token, this.email});
  final String? token, email;
  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  late final _email = TextEditingController(text: widget.email ?? '');
  late bool _verifying = widget.token != null;
  ApiError? _linkError;
  String? _resentTo;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) _verify(widget.token!);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _verify(String token) async {
    try {
      final session = await ref.read(apiProvider).verifyEmail(token);
      await ref.read(sessionProvider.notifier).signIn(session);
      await _continue(ref, null);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _verifying = false;
        _linkError = e;
      });
    }
  }

  Future<void> _resend() async {
    final email = _email.text.trim();
    setState(() => _busy = true);
    try {
      await ref.read(apiProvider).resendVerification(email);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _resentTo = email;
        _linkError = null;
      });
      showMessage(context, context.t.authVerifyResent(email));
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _linkError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    if (_verifying) {
      return Scaffold(
        body: Center(
          child: Semantics(label: t.commonLoading, child: const CircularProgressIndicator()),
        ),
      );
    }
    final email = _resentTo ?? widget.email;
    final linkError = _linkError;
    return AuthScaffold(
      children: [
        const Center(child: LkIllustration('verifier-email')),
        const SizedBox(height: 24),
        Semantics(header: true, child: Text(t.authVerifyTitle, style: LkText.authTitle)),
        const SizedBox(height: 10),
        if (linkError != null || email == null) ...[
          if (linkError != null) ...[
            LkAlert(errorText(t, linkError), tone: LkTone.danger, icon: 'mail'),
            const SizedBox(height: 16),
          ],
          LkField(
            label: t.authFieldEmail,
            controller: _email,
            icon: 'mail',
            hint: 'marie@demo.test',
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (_) => _resend(),
          ),
          const SizedBox(height: 24),
          LkButton(t.authVerifyResend, onPressed: _resend, loading: _busy),
        ] else ...[
          Text(t.authVerifyText(email), style: LkText.subtitle),
          const SizedBox(height: 24),
          LkNote(t.authVerifyDemoNote),
          const SizedBox(height: 24),
          LkButton(
            t.authVerifyOpenInbox,
            onPressed: () => launchUrl(Uri.parse(Config.mailpitUrl), mode: LaunchMode.externalApplication),
          ),
          const SizedBox(height: 10),
          LkButton(t.authVerifyResend, kind: LkButtonKind.secondary, onPressed: _resend, loading: _busy),
        ],
      ],
    );
  }
}
