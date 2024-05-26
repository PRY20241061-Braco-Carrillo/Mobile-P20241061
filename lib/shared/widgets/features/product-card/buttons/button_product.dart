import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../order_cart/order_cart.notifier.dart";
import "../../order_cart/selected_product_info.types.dart";
import "../products/product_detail-card/product_detail.types.dart";
import "../products/product_detail-card/variants/variant_detail.dart";

class ButtonProduct extends ConsumerWidget {
  final String productId;
  const ButtonProduct({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.ADD.label";

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
            }
          : null,
      child: Text(labelButton.tr()),
    );
  }
}
