import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../order_cart/order_cart.notifier.dart";
import "../../order_cart/selected_product_info.types.dart";
import "../products/product_detail-card/variants/selected_provider.dart";
import "../products/product_detail-card/variants/variant_abstract.types.dart";

class ButtonAddProductToCart extends ConsumerWidget {
  final String productId;
  final String type;

  const ButtonAddProductToCart({
    super.key,
    required this.productId,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.ADD.label";

    final productData = ref.watch(getDetailProvider(type));
    print("Product data from provider: $productData"); // Agrega este print
    final SelectedVariantsState? selectedVariantsState =
        ref.watch(getSelectedVariantsProvider(type)(productId))[productId];
    final Variant? selectedVariant = selectedVariantsState?.selectedVariant;

    print("Dentro de ButtonAddProductToCart");
    print("Product data: $productData");
    print("Selected variants state: $selectedVariantsState");
    print("Selected variant: $selectedVariant");

    return ElevatedButton(
      onPressed: productData != null && selectedVariant != null
          ? () {
              final SelectedProductInfo selectedProductInfo =
                  SelectedProductInfo(
                productId: productId,
                productName: productData!.product
                    .name, // Asegúrate de acceder correctamente a los datos
                price: selectedVariant.amountPrice,
                currency: selectedVariant.currencyPrice,
                imageUrl: productData.product.urlImage,
                selectedVariants: [selectedVariant],
                selectedComplements: productData.complements,
              );

              print("Adding product to cart: $selectedProductInfo");
              ref.read(cartProvider.notifier).addProduct(selectedProductInfo);
            }
          : null,
      child: Text(labelButton.tr()),
    );
  }
}
