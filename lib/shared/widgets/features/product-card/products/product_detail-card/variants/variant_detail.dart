import "package:collection/collection.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../product_detail.types.dart";
import "variant_detail.types.dart";
import "variants_keys.dart";

final StateProvider<String?> selectedSizeProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);
final StateProvider<String?> selectedCookingTypeProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);

final StateProvider<ProductVariant?> selectedProductVariantProvider =
    StateProvider<ProductVariant?>(
        (StateProviderRef<ProductVariant?> ref) => null);

final StateProvider<ProductDetailCardData?> productDetailCardDataProvider =
    StateProvider<ProductDetailCardData?>(
        (StateProviderRef<ProductDetailCardData?> ref) => null);

class ProductVariantSelector extends ConsumerWidget {
  final List<ProductVariant> productVariants;
  final ProductDetailCardData data;

  const ProductVariantSelector(
      {super.key, required this.productVariants, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Product variants: $productVariants");
    print("Product details: ${data.product}");
    Future<ProductDetailCardData>.microtask(
        () => ref.read(productDetailCardDataProvider.notifier).state = data);
    final List<ProductDetailVariantCard> productDetails = productVariants
        .map(ProductDetailVariantCard.fromProductVariant)
        .toList()
      ..sort((ProductDetailVariantCard a, ProductDetailVariantCard b) =>
          a.variantOrder.compareTo(b.variantOrder));

    String? primaryVariantKey;
    for (final String key in <String>[
      ProductVariantKeys.pieces,
      ProductVariantKeys.weight,
      ProductVariantKeys.volume,
      ProductVariantKeys.size
    ]) {
      if (productDetails.any((ProductDetailVariantCard detail) =>
          detail.variants.containsKey(key))) {
        primaryVariantKey = key;
        break;
      }
    }

    final Map<String, List<String>> primaryVariants = groupVariantsByCode(
        productDetails, primaryVariantKey ?? ProductVariantKeys.size);
    final Map<String, List<String>> cookingTypeVariants =
        groupVariantsByCode(productDetails, ProductVariantKeys.cookingType);
    final String? selectedPrimaryVariant = ref.watch(selectedSizeProvider);
    final String? selectedCookingType = ref.watch(selectedCookingTypeProvider);

    // Actualización del objeto de variante seleccionado cuando hay cambios.
    ref.listen<String?>(selectedSizeProvider, (String? previous, String? next) {
      updateSelectedProductVariant(ref, productDetails, <String, String?>{
        ProductVariantKeys.size: next,
        ProductVariantKeys.cookingType: ref.read(selectedCookingTypeProvider)
      });
    });
    ref.listen<String?>(selectedCookingTypeProvider,
        (String? previous, String? next) {
      updateSelectedProductVariant(ref, productDetails, <String, String?>{
        ProductVariantKeys.size: ref.read(selectedSizeProvider),
        ProductVariantKeys.cookingType: next
      });
    });
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (primaryVariantKey != null)
              RadioVariantGroup(
                title: variantLabel(context, primaryVariantKey),
                variants: primaryVariants.keys.toList(),
                selectedVariant: selectedPrimaryVariant,
                onChanged: (String? selected) {
                  print("Selected size updated to: $selected");
                  ref.read(selectedSizeProvider.notifier).state = selected;
                  ref.read(selectedCookingTypeProvider.notifier).state = null;
                },
              ),
            if (selectedPrimaryVariant != null &&
                cookingTypeVariants[selectedPrimaryVariant]?.isNotEmpty == true)
              RadioVariantGroup(
                title: "Product.variants.CC01.label".tr(),
                variants: cookingTypeVariants[selectedPrimaryVariant]!,
                selectedVariant: selectedCookingType,
                onChanged: (String? selected) {
                  ref.read(selectedCookingTypeProvider.notifier).state =
                      selected;
                },
              ),
          ],
        ),
      ),
    );
  }

  void updateSelectedProductVariant(
      WidgetRef ref,
      List<ProductDetailVariantCard> productDetails,
      Map<String, String?> selectedVariants) {
    try {
      final ProductDetailVariantCard? selectedVariant =
          productDetails.firstWhereOrNull((ProductDetailVariantCard variant) =>
              selectedVariants.entries.every(
                  (MapEntry<String, String?> entry) => variant.variantInfo
                      .contains("${entry.key}: ${entry.value}")));

      if (selectedVariant != null) {
        final ProductVariant? productVariant =
            convertToProductVariant(selectedVariant);
        print(
            "Product variant found: ${productVariant?.productVariantId} with price ${productVariant?.amountPrice}");
        ref.read(selectedProductVariantProvider.notifier).state =
            productVariant;
      } else {
        ref.read(selectedProductVariantProvider.notifier).state = null;
      }
    } on Exception catch (e) {
      print("Failed to update selected product variant: $e");
    }
  }

  ProductVariant? convertToProductVariant(ProductDetailVariantCard card) {
    return ProductVariant(
      productVariantId: card.productVariantId,
      amountPrice: card.amountPrice,
      currencyPrice: card.currencyPrice,
      variantInfo: card.variantInfo,
      variantOrder: card.variantOrder.toDouble(),
    );
  }

  String variantLabel(BuildContext context, String key) {
    switch (key) {
      case ProductVariantKeys.pieces:
        return "Product.variants.CC02.label".tr();
      case ProductVariantKeys.weight:
        return "Product.variants.CC03.label".tr();
      case ProductVariantKeys.volume:
        return "Product.variants.CC04.label".tr();
      case ProductVariantKeys.size:
        return "Product.variants.CC05.label".tr();
      default:
        return "Unknown Variant";
    }
  }

  Map<String, List<String>> groupVariantsByCode(
      List<ProductDetailVariantCard> variants, String? code) {
    final Map<String, List<String>> grouped = <String, List<String>>{};
    for (final ProductDetailVariantCard variant in variants) {
      if (variant.variants.containsKey(code)) {
        final String key = variant.variants[code] ?? "";
        if (code == ProductVariantKeys.cookingType) {
          final String primaryKey = variant.variants.values.firstWhere(
              (String v) =>
                  v != variant.variants[ProductVariantKeys.cookingType],
              orElse: () => "");
          grouped.putIfAbsent(primaryKey, () => <String>[]).add(key);
        } else {
          grouped
              .putIfAbsent(key, () => <String>[])
              .add(variant.variants[ProductVariantKeys.cookingType] ?? "");
        }
      }
    }
    return grouped;
  }
}

class RadioVariantGroup extends StatelessWidget {
  final String title;
  final List<String> variants;
  final String? selectedVariant;
  final void Function(String?) onChanged;

  const RadioVariantGroup({
    super.key,
    required this.title,
    required this.variants,
    this.selectedVariant,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          Column(
            children: variants
                .map((String variant) => RadioListTile<String>(
                      title: Text(variant),
                      value: variant,
                      groupValue: selectedVariant,
                      onChanged: (String? value) => onChanged(value),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
