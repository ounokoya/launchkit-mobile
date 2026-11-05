# LaunchKit · mobile

Android and iOS app of **LaunchKit**, a SaaS starter kit used as a portfolio demo. Flutter, same API as the web app
([launchkit-server](https://github.com/ounokoya/launchkit-server)), in French and English. **Demo APK** (Android):
[latest release](https://github.com/ounokoya/launchkit-mobile/releases/latest), connected to https://saas.koyad.com. Sign-up and e-mail check, several organizations, members and
invitations, simulated Pro plan, projects.

## What is inside

| Screens (Penpot « 04 · Mobile ») | Route |
|---|---|
| Sign-in (session expired, wrong password), sign-up, e-mail check (expired link) | `/login`, `/signup`, `/verify-email` |
| Choose or create an organization | `/orgs`, `/onboarding` |
| Invitation link (accept, expired, wrong account) | `/invitations/:token` |
| Projects (empty, offline, loading), project, project form, deletion | `/projects`, `/projects/:id`, `/projects/new` |
| Members (alone, invite), billing (welcome to Pro, access denied), profile and language | `/members`, `/billing`, `/profile` |

- **Talks to the API directly.** The session token is kept in the system's secure storage (Android Keystore, iOS
  Keychain) and sent as a bearer token; a refused session sends back to sign-in, then to the same screen.
- **Links of the e-mails open the app** (`/verify-email?token=…`, `/invitations/…`), otherwise the web site.
- **Same design, texts and icons as the web.** Colours from the Penpot library (WCAG AA), Inter embedded, texts
  generated from the shared source (`app_fr.arb`, `app_en.arb`), Lucide icons generated from the web's version.
- **Works badly connected.** Data already loaded stays on screen with « Connexion impossible · Réessayer ».
- **Accessible.** Touch targets of 48 dp, every button labelled, text contrast checked by the tests.

Riverpod 3 (state), go_router 18 (navigation, links), dio 5 (HTTP), flutter_secure_storage, flutter_svg, url_launcher.

## Run it

Start the server stack first (repository [launchkit-server](https://github.com/ounokoya/launchkit-server):
`docker compose up --build`), then:

```bash
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:5080 --dart-define=MAILPIT_URL=http://10.0.2.2:8025
```

`10.0.2.2` is the host machine seen from the Android emulator (`localhost` on a desktop target or with
`adb reverse`). Sign up with a made-up `@demo.test` address: the verification e-mail is in Mailpit.

| Setting (`--dart-define`) | Default | Role |
|---|---|---|
| `API_URL` | `http://localhost:5080` | LaunchKit API |
| `WEB_URL` | `http://localhost:5173` | web site |
| `MAILPIT_URL` | `http://localhost:8025` | « Open the demo inbox » |

The host whose links open the app is set at build time: `flutter build apk -PwebHost=demo.example` (Android App
Links also need the site's `/.well-known/assetlinks.json`, served by the web app with the fingerprint of the signing
certificate; iOS Universal Links, the Associated Domains entitlement). The demo APK is built with
`--dart-define=API_URL=https://saas.koyad.com --dart-define=WEB_URL=https://saas.koyad.com
--dart-define=MAILPIT_URL=https://saas.koyad.com/mail/ -PwebHost=saas.koyad.com`; until a release key is chosen (v1.0.0,
stores) it is signed with the build machine's debug key.
HTTP without TLS is only allowed for the local demo (`10.0.2.2`, `localhost`, `127.0.0.1`).

## Tests

| Check | Command |
|---|---|
| Analysis and format | `flutter analyze`, `dart format --set-exit-if-changed lib test integration_test` |
| Unit and screen tests, accessibility, coverage ≥ 80 % (generated code excluded) | `flutter test --coverage && python3 tool/coverage.py` |
| Reference captures of every screen and state, 390 × 844 (`test/goldens/`) | `flutter test test/goldens_test.dart` |
| Scenario A / B on the real stack (API, Rust worker, Mailpit) | `xvfb-run flutter test integration_test -d linux` |

The screen tests run the real app (router, texts, theme) on an in-memory API. The scenario signs up A, opens the
link of the Mailpit e-mail, creates an organization and three projects, checks that the fourth is refused on Free,
invites B, lets B sign up from the invitation link and accept, checks that B cannot open billing, upgrades A to Pro
through the Rust worker (« Bienvenue dans Pro »), then creates the fourth project. On Linux it needs
`libgtk-3-dev` and `libsecret-1-dev`; the Linux window has the size of a phone (390 × 844), as it only runs the tests.
If clang picks a GCC whose C++ library is missing (« cannot find -lstdc++ »), point it to an installed one for the
command: `CCC_OVERRIDE_OPTIONS=+--gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13`.

GitHub Actions runs all of it on every push and builds the Android demo APK and the iOS app (`.github/workflows/ci.yml`).

## Generated files

| Files | Source | Command |
|---|---|---|
| `lib/l10n/app_fr.arb`, `app_en.arb` | `brand/textes/textes.json` | `python3 tools/textes/exporter_textes.py`, then `flutter gen-l10n` |
| `assets/icons/*.svg` | `@lucide/svelte` of the web | `python3 tools/mobile/icones_lucide.py` |
| launcher icons, splash images | `brand/logo/final` | `python3 tools/mobile/icones_appli.py` |

(The scripts live in the private design repository; the generated files are committed.)
