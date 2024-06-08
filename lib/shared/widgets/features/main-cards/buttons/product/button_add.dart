import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../order_cart/order_cart.notifier.dart";
import "../../../order_cart/selected_product_info.types.dart";
import "../../menus/menus_detail-card/variants/menu/menu_detail_variant.types.dart";
import "../../products/product_detail-card/product_detail.types.dart";
import "../../products/product_detail-card/variants/product/product_detail_variant.types.dart";
import "../../products/product_detail-card/variants/product/product_variant.provider.dart";

class ButtonAddProductVariantToCart extends ConsumerWidget {
  final String productId;

  const ButtonAddProductVariantToCart({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.ADD.label";

    final ProductDetailCardData? productData =
        ref.watch(productDetailCardDataProvider);
    final bool allVariantsSelected =
        ref.watch(allVariantsSelectedProvider(productId));

    return ElevatedButton(
      onPressed: productData != null && allVariantsSelected
          ? () {
              final Map<String, SelectedVariantsState> selectedVariantsState =
                  ref.read(selectedProductVariantsProvider(productId));
              final ProductDetailVariantCard? selectedVariant =
                  selectedVariantsState[productId]?.selectedVariant;

              if (selectedVariant == null) return;

              final SelectedVariantsState? productDetails =
                  selectedVariantsState[productId];
              if (productDetails == null) return;

              final SelectedProductInfo selectedProductInfo =
                  SelectedProductInfo(
                productId: productId,
                productName: productDetails.productName!,
                price: productDetails.price!,
                currency: productDetails.currency!,
                imageUrl: productDetails.imageUrl!,
                selectedProductVariants: <ProductDetailVariantCard>[
                  selectedVariant
                ],
                selectedMenuVariants: <MenuDetailVariantCard>[],
              );

              ref.read(cartProvider.notifier).addProduct(selectedProductInfo);
            }
          : null,
      child: Text(labelButton.tr()),
    );
  }
}
