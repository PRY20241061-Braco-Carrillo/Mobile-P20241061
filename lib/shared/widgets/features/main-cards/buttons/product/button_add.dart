import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../campus-card/campus_card.types.dart";
import "../../../cart/order_cart/order_cart.notifier.dart";
import "../../../cart/order_cart/selected_product_info.types.dart";
import "../../menus/menus_detail-card/variants/menu/menu_detail_variant.types.dart";
import "../../products/product_detail-card/product_detail.types.dart";
import "../../products/product_detail-card/variants/product/product_detail_variant.types.dart";
import "../../products/product_detail-card/variants/product/product_variant.provider.dart";

class ButtonAddProductVariantToCart extends ConsumerWidget {
  final String productId;
  final CampusCardData campusData;

  const ButtonAddProductVariantToCart({
    super.key,
    required this.productId,
    required this.campusData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.ADD.label";

    final ProductDetailCardData? productData =
        ref.watch(productDetailCardDataProvider);
    final bool allVariantsSelected =
        ref.watch(allVariantsSelectedProvider(productId));

    return SizedBox(
      width: double.infinity, // Ajusta para ocupar todo el ancho
      child: ElevatedButton.icon(
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
        icon: const Icon(Icons.add_shopping_cart, size: 24),
        label: Text(
          labelButton.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
