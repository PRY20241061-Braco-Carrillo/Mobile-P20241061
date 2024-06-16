import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../modules/order/providers/order_in_progress.notifier.dart";
import "../shared/widgets/features/cart/order_cart/order_cart.notifier.dart";
import "../shared/widgets/features/cart/order_cart/order_cart.types.dart";
import "../shared/widgets/features/cart/order_cart/order_summary_cart_bar.dart";
import "../shared/widgets/order/order_progress/order_summary_bar.dart";

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
              final OrderInProgressState orderInProgressState =
                  ref.watch(orderInProgressProvider);

              if (orderInProgressState.inProgress) {
                return const OrderSummaryBar();
              } else if (cartItems.isNotEmpty) {
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
