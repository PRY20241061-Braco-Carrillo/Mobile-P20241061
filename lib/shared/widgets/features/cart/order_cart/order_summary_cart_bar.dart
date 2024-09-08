import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../config/routes/routes.dart';
import '../../../../utils/constants/currency_types.dart';
import 'order_cart.notifier.dart';
import 'order_cart.types.dart';

class CartSummaryBar extends ConsumerWidget {
  const CartSummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CartItem> cartItems = ref.watch(cartProvider);
    final double total = cartItems.fold<double>(
      0,
      (double sum, CartItem current) =>
          sum + current.productInfo.getTotalPrice() * current.quantity,
    );

    // Mostrar barra si el carrito no está vacío
    return Visibility(
      visible: cartItems.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black26,
                  offset: Offset(0, -2),
                )
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Texto de resumen de total
                Text(
                  "Total: ${getCurrencySymbol(cartItems.first.productInfo.currency)} ${total.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                // Si no estamos en la página de carrito, mostramos el botón "Go to Cart"

                ElevatedButton.icon(
                  onPressed: () {
                    GoRouter.of(context).push(AppRoutes.cart);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary, // Color del botón
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(
                    "Order.labels.go_to_cart.label".tr(),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
