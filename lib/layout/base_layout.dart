import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../shared/widgets/features/order_cart/order_cart.notifier.dart";
import "../shared/widgets/features/order_cart/order_cart.types.dart";
import "../shared/widgets/features/order_cart/order_summary_cart_bar.dart";

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
      body: Column(
        children: <Widget>[
          Expanded(child: body),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final List<CartItem> cartItems = ref.watch(cartProvider);
              if (cartItems.isNotEmpty) {
                return const CartSummaryBar();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
