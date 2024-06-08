import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../order_cart/order_cart.notifier.dart';
import '../../../order_cart/selected_product_info.types.dart';
import '../../menus/menus_detail-card/menus_detail.types.dart';
import '../../menus/menus_detail-card/variants/menu/menu_detail_variant.types.dart';
import '../../menus/menus_detail-card/variants/menu/menu_variant.provider.dart';
import '../../products/product_detail-card/variants/product/product_detail_variant.types.dart';

class ButtonAddMenuVariantToCart extends ConsumerWidget {
  final String menuId;

  const ButtonAddMenuVariantToCart({
    super.key,
    required this.menuId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = 'MenuCard.buttons.ADD.label';

    final MenuDetailCardData? menuData = ref.watch(menuDetailCardDataProvider);
    final bool buttonEnabled = ref.watch(buttonEnabledProvider(menuId));

    return ElevatedButton(
      onPressed: menuData != null && buttonEnabled
          ? () {
              final initialDishVariant = ref
                  .read(selectedInitialDishesVariantsProvider)
                  .selectedVariant;
              final principalDishVariant = ref
                  .read(selectedPrincipalDishesVariantsProvider)
                  .selectedVariant;
              final drinkVariant =
                  ref.read(selectedDrinksVariantsProvider).selectedVariant;
              final dessertVariant =
                  ref.read(selectedDessertsVariantsProvider).selectedVariant;

              final List<MenuDetailVariantCard> selectedVariants = [];
              if (initialDishVariant != null)
                selectedVariants.add(initialDishVariant);
              if (principalDishVariant != null)
                selectedVariants.add(principalDishVariant);
              if (drinkVariant != null) selectedVariants.add(drinkVariant);
              if (dessertVariant != null) selectedVariants.add(dessertVariant);

              if (selectedVariants.isEmpty) {
                print('No variants selected');
                return;
              }

              print(
                  'Selected Variants: ${selectedVariants.map((e) => e.toJson()).toList()}');

              final SelectedProductInfo selectedProductInfo =
                  SelectedProductInfo(
                productId: menuId,
                productName: menuData!.name,
                price: menuData.amountPrice,
                currency: menuData.currencyPrice,
                imageUrl: menuData.urlImage,
                selectedProductVariants: <ProductDetailVariantCard>[],
                selectedMenuVariants: selectedVariants,
              );

              ref.read(cartProvider.notifier).addProduct(selectedProductInfo);
            }
          : null,
      child: Text(labelButton.tr()),
    );
  }
}
