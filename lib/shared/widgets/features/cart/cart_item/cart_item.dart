import "package:cached_network_image/cached_network_image.dart";
import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
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
        leading: ClipOval(
          child: _getImageWidget(item.productInfo.imageUrl, 40,
              40), // Ajusta el tamaño como necesario
        ),
        title: Text(item.productInfo.productName),
        subtitle: Text(
          "Cantidad: ${item.quantity}\nPrecio unitario: ${item.productInfo.currency} ${item.productInfo.price.toStringAsFixed(2)}\nTotal: ${item.productInfo.currency} ${(item.quantity * item.productInfo.getTotalPrice()).toStringAsFixed(2)}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mostrar el botón "-" solo si la cantidad es mayor que 1
            if (item.quantity > 1)
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  ref.read(cartProvider.notifier).updateProductQuantity(
                        item.productInfo.productId,
                        item.quantity - 1,
                      );
                },
              ),
            // Botón de borrar el producto
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => ref
                  .read(cartProvider.notifier)
                  .removeProduct(item.productInfo.productId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImageWidget(String? url, double width, double height) {
    if (url == null) {
      return SvgPicture.asset(
        "assets/images/not_found/picture_not_found.svg",
        width: width,
        height: height,
      );
    } else if (url.endsWith(".svg")) {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        placeholderBuilder: (BuildContext context) =>
            const CircularProgressIndicator(),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (BuildContext context, String url) =>
            const CircularProgressIndicator(),
        errorWidget: (BuildContext context, String url, Object error) =>
            const Icon(Icons.error),
      );
    }
  }
}
