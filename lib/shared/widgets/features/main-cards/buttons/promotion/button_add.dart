import "../../promotions/promotions_detail-card/variants/promotions/promotion_variant.provider.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../campus-card/campus_card.types.dart";
import "../../../cart/order_cart/order_cart.notifier.dart";
import "../../../cart/order_cart/selected_product_info.types.dart";
import "../../menus/menus_detail-card/variants/menu/menu_detail_variant.types.dart";
import "../../products/product_detail-card/variants/product/product_detail_variant.types.dart";
import "../../promotions/promotions_detail-card/variants/promotions/promotion_detail.variant.types.dart";

class ButtonAddProductPromotionVariantToCart extends ConsumerWidget {
  final String productId;
  final CampusCardData campusData;

  const ButtonAddProductPromotionVariantToCart({
    super.key,
    required this.productId,
    required this.campusData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.ADD.label";

    final bool allVariantsSelected = ref.watch(allVariantsSelectedProvider);

    return ElevatedButton(
      onPressed: allVariantsSelected
          ? () {
              final PromotionDetailVariantCard? selectedVariant =
                  ref.read(selectedPromotionProductVariantProvider);

              if (selectedVariant == null) return;

              final SelectedProductInfo selectedProductInfo =
                  SelectedProductInfo(
                productId: productId,
                productName: selectedVariant.name!,
                price: selectedVariant.amountPrice,
                currency: selectedVariant.currencyPrice!,
                imageUrl: '',
                selectedProductVariants: <ProductDetailVariantCard>[],
                selectedMenuVariants: <MenuDetailVariantCard>[],
                selectedPromotionVariants: <PromotionDetailVariantCard>[
                  selectedVariant
                ],
              );

              // Add the selected product to the cart
              ref.read(cartProvider.notifier).addProduct(selectedProductInfo);
            }
          : null,
      child: Text(labelButton.tr()),
    );
  }
}
