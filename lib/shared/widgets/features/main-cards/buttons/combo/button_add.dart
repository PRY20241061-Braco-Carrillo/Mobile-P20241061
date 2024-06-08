import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../order_cart/order_cart.notifier.dart";
import "../../../order_cart/selected_product_info.types.dart";
import "../../combos/combos_detail-card/combos_detail.types.dart";
import "../../combos/combos_detail-card/variants/combo/combo_detail.variant.types.dart";
import "../../combos/combos_detail-card/variants/combo/combo_variant.provider.dart";
import "../../menus/menus_detail-card/variants/menu/menu_detail_variant.types.dart";

class ButtonAddComboVariantToCart extends ConsumerWidget {
  final String comboId;

  const ButtonAddComboVariantToCart({
    super.key,
    required this.comboId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.ADD.label";

    final ComboDetailCardData? comboData =
        ref.watch(comboDetailCardDataProvider);
    final bool allVariantsSelected =
        ref.watch(allComboVariantsSelectedProvider(comboId));

    return ElevatedButton(
      onPressed: comboData != null && allVariantsSelected
          ? () {
              final Map<String, SelectedVariantsState> selectedVariantsState =
                  ref.read(selectedComboVariantsProvider(comboId));
              final ComboDetailVariantCard? selectedVariant =
                  selectedVariantsState[comboId]?.selectedVariant;

              if (selectedVariant == null) return;

              final SelectedVariantsState? comboDetails =
                  selectedVariantsState[comboId];
              if (comboDetails == null) return;

              final SelectedProductInfo selectedProductInfo =
                  SelectedProductInfo(
                productId: comboId,
                productName: comboDetails.comboName!,
                price: comboDetails.price!,
                currency: comboDetails.currency!,
                imageUrl: comboDetails.imageUrl!,
                selectedComboVariants: <ComboDetailVariantCard>[
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
