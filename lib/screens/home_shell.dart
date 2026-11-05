// The four tabs of the chosen organization (M04, M06, M07, M08).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    NavigationDestination tab(String icon, String label) => NavigationDestination(
      icon: LkIcon(icon),
      selectedIcon: LkIcon(icon, color: LkColors.primary500),
      label: label,
      tooltip: '',
    );
    return Scaffold(
      body: SafeArea(bottom: false, child: shell),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: LkColors.border)),
        ),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
          destinations: [
            tab('folder', t.commonNavProjects),
            tab('users', t.commonNavMembers),
            tab('credit-card', t.commonNavBilling),
            tab('settings', t.commonNavProfile),
          ],
        ),
      ),
    );
  }
}
