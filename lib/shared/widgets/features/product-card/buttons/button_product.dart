import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../order_cart/order_cart.notifier.dart";
import "../../order_cart/selected_product_info.types.dart";
import "../product_detail-card/product_detail.types.dart";
import "../product_detail-card/variants/variant_detail.dart";

class ButtonProduct extends ConsumerWidget {
  final String productId;
  const ButtonProduct({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProductDetailCardData? productData =
        ref.watch(productDetailCardDataProvider);

    final ProductVariant? selectedVariant =
        ref.watch(selectedProductVariantProvider);

    return ElevatedButton(
      onPressed: productData != null && selectedVariant != null
          ? () {
              final SelectedProductInfo selectedProductInfo =
                  SelectedProductInfo(
                productId: productId,
                productName: productData.product.name,
                price: selectedVariant.amountPrice,
                currency: selectedVariant.currencyPrice,
                imageUrl: productData.product.urlImage,
                selectedVariants: <ProductVariant>[selectedVariant],
                selectedComplements: productData.complements,
              );

              ref.read(cartProvider.notifier).addProduct(selectedProductInfo);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Producto añadido al carrito"),
                duration: Duration(seconds: 2),
              ));
            }
          : null,
      child: const Text("Agregar al Carrito"),
    );
  }
}
