import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../product_detail.types.dart";
import "variant_detail.types.dart";
import "variants_keys.dart";

final StateProvider<String?> selectedSizeProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);
final StateProvider<String?> selectedCookingTypeProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);

class ProductVariantSelector extends ConsumerWidget {
  final List<ProductVariant> productVariants;

  const ProductVariantSelector({super.key, required this.productVariants});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ProductDetailVariantCard> productDetails = productVariants
        .map(ProductDetailVariantCard.fromProductVariant)
        .toList()
      ..sort((ProductDetailVariantCard a, ProductDetailVariantCard b) =>
          a.variantOrder.compareTo(b.variantOrder));
    final Map<String, List<String>> sizeVariants =
        groupVariantsByCode(productDetails, ProductVariantKeys.size);
    final Map<String, List<String>> cookingTypeVariants =
        groupVariantsByCode(productDetails, ProductVariantKeys.cookingType);

    final String? selectedSize = ref.watch(selectedSizeProvider);
    final String? selectedCookingType = ref.watch(selectedCookingTypeProvider);
    final List<String> currentCookingTypeVariants =
        cookingTypeVariants[selectedSize] ?? <String>[];

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioVariantGroup(
              title: "Select your size:",
              variants: sizeVariants.keys.toList(),
              selectedVariant: selectedSize,
              onChanged: (String? selected) {
                ref.read(selectedSizeProvider.notifier).state = selected;
                ref.read(selectedCookingTypeProvider.notifier).state = null;
              },
            ),
            if (currentCookingTypeVariants.isNotEmpty)
              RadioVariantGroup(
                title: "Select your cooking type:",
                variants: currentCookingTypeVariants,
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

  Map<String, List<String>> groupVariantsByCode(
      List<ProductDetailVariantCard> variants, String code) {
    final Map<String, List<String>> grouped = <String, List<String>>{};
    for (final ProductDetailVariantCard variant in variants) {
      final String key = variant.variants[ProductVariantKeys.size] ?? "";
      final String value =
          variant.variants[ProductVariantKeys.cookingType] ?? "";
      if (key.isNotEmpty && value.isNotEmpty) {
        grouped.putIfAbsent(key, () => <String>[]).add(value);
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
