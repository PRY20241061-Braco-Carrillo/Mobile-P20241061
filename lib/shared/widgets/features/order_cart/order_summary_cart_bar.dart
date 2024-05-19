import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../config/routes/routes.dart";
import "order_cart.notifier.dart";
import "order_cart.types.dart";

class CartSummaryBar extends ConsumerWidget {
  const CartSummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CartItem> cartItems = ref.watch(cartProvider);
    final double total = cartItems.fold<double>(
        0,
        (double sum, CartItem current) =>
            sum + current.productInfo.getTotalPrice() * current.quantity);

    return Visibility(
      visible: cartItems.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 4, color: Colors.black26)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                "Total: ${cartItems.first.productInfo.currency} ${total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.cart);
              },
              child: const Text("Ir al Carrito"),
            ),
          ],
        ),
      ),
    );
  }
}
