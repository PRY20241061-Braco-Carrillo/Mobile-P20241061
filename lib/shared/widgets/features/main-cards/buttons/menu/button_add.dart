import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../order_cart/order_cart.notifier.dart";
import "../../../order_cart/selected_product_info.types.dart";
import "../../menus/menus_detail-card/menus_detail.types.dart";
import "../../menus/menus_detail-card/variants/menu/menu_detail_variant.types.dart";
import "../../menus/menus_detail-card/variants/menu/menu_variant.provider.dart";
import "../../products/product_detail-card/variants/product/product_detail_variant.types.dart";

class ButtonAddMenuVariantToCart extends ConsumerWidget {
  final String menuId;

  const ButtonAddMenuVariantToCart({
    super.key,
    required this.menuId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.ADD.label";

    final MenuDetailCardData? menuData = ref.watch(menuDetailCardDataProvider);
    final bool allVariantsSelected =
        ref.watch(allMenuVariantsSelectedProvider(menuId));

    return ElevatedButton(
      onPressed: menuData != null && allVariantsSelected
          ? () {
              final Map<String, SelectedVariantsState> selectedVariantsState =
                  ref.read(selectedMenuVariantsProvider(menuId));
              final MenuDetailVariantCard? selectedVariant =
                  selectedVariantsState[menuId]?.selectedVariant;

              if (selectedVariant == null) return;

              final SelectedVariantsState? menuDetails =
                  selectedVariantsState[menuId];
              if (menuDetails == null) return;

              final SelectedProductInfo selectedProductInfo =
                  SelectedProductInfo(
                productId: menuId,
                productName: menuDetails.menuName!,
                price: menuDetails.price!,
                currency: menuDetails.currency!,
                imageUrl: menuDetails.imageUrl!,
                selectedProductVariants: <ProductDetailVariantCard>[],
                selectedMenuVariants: <MenuDetailVariantCard>[selectedVariant],
              );

              ref.read(cartProvider.notifier).addProduct(selectedProductInfo);
            }
          : null,
      child: Text(labelButton.tr()),
    );
  }
}
