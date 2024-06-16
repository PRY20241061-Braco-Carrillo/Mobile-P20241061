import "package:flutter/material.dart";

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }
}
