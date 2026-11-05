// Starts the real app (router, theme, texts) on a fake API, at the size of the Penpot screens (390 × 844).
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:launchkit/app.dart';
import 'package:launchkit/router.dart';
import 'package:launchkit/state/session.dart';

import 'fake_api.dart';

bool _fontsLoaded = false;
ProviderContainer? _previous;

/// Inter, so that the captures look like the design (otherwise the test font draws boxes).
Future<void> loadFonts() async {
  if (_fontsLoaded) return;
  final loader = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(rootBundle.load('assets/fonts/Inter-$weight.ttf'));
  }
  await loader.load();
  await initializeDateFormatting();
  _fontsLoaded = true;
}

class Harness {
  Harness(this.container, this.api, this.store);
  final ProviderContainer container;
  final FakeApi api;
  final MemorySecretStore store;
  GoRouter get router => container.read(routerProvider);
  SessionState get session => container.read(sessionProvider);
}

/// [signedIn]: a token is stored, so the session is restored with GET /me (Marie, Acme).
Future<Harness> pumpApp(
  WidgetTester tester, {
  FakeApi? api,
  bool signedIn = true,
  String? location,
  Map<String, String>? stored,
  String locale = 'fr',
}) async {
  await loadFonts();
  if (_previous != null) {
    // A second app in the same test: unmount the first one and let its providers go before starting again.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    _previous!.dispose();
    _previous = null;
  }
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final fake = api ?? FakeApi();
  final store = MemorySecretStore({if (signedIn) 'session_token': 'tok', 'locale': locale, ...?stored});
  final container = ProviderContainer(
    overrides: [apiProvider.overrideWithValue(fake), secretStoreProvider.overrideWithValue(store)],
    retry: (_, _) => null,
  );
  _previous = container;
  addTearDown(() {
    if (_previous == container) _previous = null;
    container.dispose();
  });
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const LaunchKitApp()));
  await settle(tester);
  if (location != null) {
    container.read(routerProvider).go(location);
    await settle(tester);
  }
  return Harness(container, fake, store);
}

/// Lets the futures (fake API, SVG decoding) finish, then the animations (page, sheet) — at most 1.5 s of test time,
/// so that an endless spinner does not run the clock (and the 2 s polling of the billing) for minutes.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump(const Duration(milliseconds: 100));
  }
  for (var i = 0; i < 10 && tester.binding.hasScheduledFrame; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
