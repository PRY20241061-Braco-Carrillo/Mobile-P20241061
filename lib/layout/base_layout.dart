import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

class BaseLayout extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final PersistentTabController? tabController;

  const BaseLayout({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
