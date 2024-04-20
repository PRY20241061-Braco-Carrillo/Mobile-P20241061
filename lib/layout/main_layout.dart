import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "base_layout.dart";

class MainLayout extends StatelessWidget {
  final Widget body;
  final PersistentTabController tabController;

  const MainLayout({
    super.key,
    required this.body,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      body: PersistentTabView(
        controller: tabController,
        tabs: <PersistentTabConfig>[
          PersistentTabConfig(
            screen: body,
            item: ItemConfig(
              icon: const Icon(Icons.home),
              title: "Inicio",
              activeForegroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
          PersistentTabConfig(
            screen: const Scaffold(
              body: Center(
                child: Text("Otra pantalla"),
              ),
            ),
            item: ItemConfig(
              icon: const Icon(Icons.settings),
              title: "QR Code",
              activeForegroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
          PersistentTabConfig(
            screen: const Scaffold(
              body: Center(
                child: Text("Otra pantalla"),
              ),
            ),
            item: ItemConfig(
              icon: const Icon(Icons.settings),
              title: "Configuración",
              activeForegroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
        ],
        navBarBuilder: (NavBarConfig navBarConfig) => Style4BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      tabController: tabController,
    );
  }
}
