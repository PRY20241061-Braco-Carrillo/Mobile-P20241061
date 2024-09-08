import "package:collection/collection.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../../../../utils/constants/variants_keys.dart";
import "product_detail_variant.types.dart";
import "product_variant.provider.dart";

class ProductVariantSelector extends ConsumerWidget {
  final String productId;
  final List<ProductDetailVariantCard> variants;

  const ProductVariantSelector({
    super.key,
    required this.productId,
    required this.variants,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      ref
          .read(selectedProductVariantsProvider(productId).notifier)
          .initializeVariants(variants);
    });

    final SelectedVariantsState? selectedVariantsState =
        ref.watch(selectedProductVariantsProvider(productId))[productId];

    String? primaryVariantKey;
    for (final String key in <String>[
      ProductVariantKeys.pieces,
      ProductVariantKeys.weight,
      ProductVariantKeys.volume,
      ProductVariantKeys.size,
    ]) {
      if (variants.any((ProductDetailVariantCard detail) =>
          detail.variants.containsKey(key))) {
        primaryVariantKey = key;
        break;
      }
    }

    final Map<String, List<String>> primaryVariants = groupVariantsByCode(
      variants,
      primaryVariantKey ?? ProductVariantKeys.size,
    );

    final Map<String, List<String>> cookingTypeVariants = groupVariantsByCode(
      variants,
      ProductVariantKeys.cookingType,
    );

    final String? selectedPrimaryVariant = selectedVariantsState?.selectedSize;
    final String? selectedCookingType =
        selectedVariantsState?.selectedCookingType;

    ref.listen<Map<String, SelectedVariantsState>>(
        selectedProductVariantsProvider(productId),
        (Map<String, SelectedVariantsState>? previous,
            Map<String, SelectedVariantsState> next) {
      if (previous?[productId]?.selectedSize != next[productId]?.selectedSize ||
          previous?[productId]?.selectedCookingType !=
              next[productId]?.selectedCookingType) {
        updateSelectedProductVariant(ref, variants, <String, String?>{
          ProductVariantKeys.size: next[productId]?.selectedSize,
          ProductVariantKeys.cookingType: next[productId]?.selectedCookingType,
        });
      }
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
                  ref
                      .read(selectedProductVariantsProvider(productId).notifier)
                      .updateSelectedSize(productId, selected);
                  ref
                      .read(selectedProductVariantsProvider(productId).notifier)
                      .updateSelectedCookingType(productId, null);
                },
              ),
            if (selectedPrimaryVariant != null &&
                cookingTypeVariants[selectedPrimaryVariant]?.isNotEmpty == true)
              RadioVariantGroup(
                title: variantLabel(context, ProductVariantKeys.cookingType),
                variants: cookingTypeVariants[selectedPrimaryVariant]!,
                selectedVariant: selectedCookingType,
                onChanged: (String? selected) {
                  ref
                      .read(selectedProductVariantsProvider(productId).notifier)
                      .updateSelectedCookingType(productId, selected);
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
    Map<String, String?> selectedVariants,
  ) {
    final ProductDetailVariantCard? selectedVariant =
        productDetails.firstWhereOrNull((ProductDetailVariantCard variant) {
      // Asegurarse de que variant.variantInfo no es null antes de invocar contains
      return variant.variantInfo != null &&
          selectedVariants.entries.every((MapEntry<String, String?> entry) =>
              entry.value == null ||
              variant.variantInfo!.contains("${entry.key}: ${entry.value}"));
    });

    if (selectedVariant != null) {
      ref
          .read(selectedProductVariantsProvider(productId).notifier)
          .updateSelectedVariant(productId, selectedVariant);
    } else {
      // Manejar el caso en que no se encuentra ningún variante que coincida
      // Por ejemplo, puedes resetear la selección actual o manejar de otra manera
      print("No matching variant found.");
    }
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
      case ProductVariantKeys.cookingType:
        return "Product.variants.CC01.label".tr();
      default:
        return "Unknown Variant";
    }
  }

  Map<String, List<String>> groupVariantsByCode(
    List<ProductDetailVariantCard> variants,
    String? code,
  ) {
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
            children: variants.map((String variant) {
              return RadioListTile<String>(
                title: Text(variant),
                value: variant,
                groupValue: selectedVariant,
                onChanged: (String? value) {
                  onChanged(value);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
