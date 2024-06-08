import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../order_cart/order_cart.notifier.dart";
import "../order_cart/order_cart.types.dart";

class CartItemWidget extends ConsumerWidget {
  final CartItem item;

  const CartItemWidget({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.productInfo.imageUrl),
        ),
        title: Text(item.productInfo.productName),
        subtitle: Text(
          "Cantidad: ${item.quantity}\nPrecio unitario: ${item.productInfo.currency} ${item.productInfo.price.toStringAsFixed(2)}\nTotal: ${item.productInfo.currency} ${(item.quantity * item.productInfo.getTotalPrice()).toStringAsFixed(2)}",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => ref
              .read(cartProvider.notifier)
              .removeProduct(item.productInfo.productId),
        ),
      ),
    );
  }
}
