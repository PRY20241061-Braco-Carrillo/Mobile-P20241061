import "package:easy_localization/easy_localization.dart";
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../modules/home/home_screen.dart';
import '../modules/reservation/reservation_screen.dart';
import "../modules/settings/settings_screen.dart";

class TabScreen extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  TabScreen({super.key});

  List<PersistentTabConfig> _buildTabs(BuildContext context) {
    return <PersistentTabConfig>[
      PersistentTabConfig(
        screen: const HomeScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.home),
          // title: tr("TABS.HOME.label"),
        ),
      ),
      PersistentTabConfig(
        screen: const ReservationsScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.book),
          // title: tr("TABS.RESERVATIONS.label"),
        ),
      ),
      PersistentTabConfig(
        screen: const SettingScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.settings),
          // title: tr("TABS.SETTINGS.label"),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: _buildTabs(context),
      navBarBuilder: (NavBarConfig navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
