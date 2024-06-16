import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../shared/widgets/features/cart/order_cart/order_cart.notifier.dart";
import "../../../shared/widgets/features/cart/order_cart/order_cart.types.dart";

class OrderInProgressScreen extends ConsumerWidget {
  const OrderInProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CartItem> cartItems = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order In Progress"),
      ),
      body: Center(
        child: Text(
          "Su orden está en progreso.",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline4!.fontSize,
          ),
        ),
      ),
    );
  }
}
