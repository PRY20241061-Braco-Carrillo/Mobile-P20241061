import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../modules/home/home_screen.dart';
import '../modules/reservation/reservation_screen.dart';
import "../modules/settings/settings_screen.dart";

class TabScreen extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  TabScreen({super.key});

  List<PersistentTabConfig> _buildTabs() {
    return <PersistentTabConfig>[
      PersistentTabConfig(
        screen: const HomeScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.home),
          title: "Inicio",
        ),
      ),
      PersistentTabConfig(
        screen: const ReservationsScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.book),
          title: "Reservas",
        ),
      ),
      PersistentTabConfig(
        screen: const SettingScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.settings),
          title: "Configuración",
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: _buildTabs(),
      navBarBuilder: (NavBarConfig navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
