import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../product_detail.types.dart';
import 'selected_provider.dart';
import 'variant_abstract.types.dart';
import 'variant_detail.types.dart';
import 'variants_keys.dart';

class ProductVariantSelector extends ConsumerWidget {
  final String productId;
  final List<Variant> variants;
  final String type;

  ProductVariantSelector({
    super.key,
    required this.productId,
    required this.variants,
    required this.type,
  }) {
    print("ProductVariantSelector initialized with variants: $variants");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ProductDetailVariantCard> productDetails =
        variants.map((Variant variant) {
      print("Mapping variant: ${variant.productVariantId}");
      return ProductDetailVariantCard.fromVariant(variant);
    }).toList()
          ..sort((a, b) => a.variantOrder.compareTo(b.variantOrder));
    print("Product details after sorting: $productDetails");

    final selectedVariantsState =
        ref.watch(getSelectedVariantsProvider(type)(productId))[productId];

    String? primaryVariantKey;
    for (final String key in <String>[
      ProductVariantKeys.pieces,
      ProductVariantKeys.weight,
      ProductVariantKeys.volume,
      ProductVariantKeys.size,
    ]) {
      if (productDetails.any((detail) => detail.variants.containsKey(key))) {
        primaryVariantKey = key;
        break;
      }
    }
    print("Primary variant key: $primaryVariantKey");

    final Map<String, List<String>> primaryVariants = groupVariantsByCode(
      productDetails,
      primaryVariantKey ?? ProductVariantKeys.size,
    );

    final Map<String, List<String>> cookingTypeVariants = groupVariantsByCode(
      productDetails,
      ProductVariantKeys.cookingType,
    );

    final String? selectedPrimaryVariant = selectedVariantsState?.selectedSize;
    final String? selectedCookingType =
        selectedVariantsState?.selectedCookingType;

    print("Primary variants: $primaryVariants");
    print("Cooking type variants: $cookingTypeVariants");

    ref.listen<Map<String, SelectedVariantsState>>(
        getSelectedVariantsProvider(type)(productId), (previous, next) {
      if (previous?[productId]?.selectedSize != next[productId]?.selectedSize ||
          previous?[productId]?.selectedCookingType !=
              next[productId]?.selectedCookingType) {
        updateSelectedProductVariant(ref, productDetails, {
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
                onChanged: (selected) {
                  ref
                      .read(
                          getSelectedVariantsProvider(type)(productId).notifier)
                      .updateSelectedSize(productId, selected);
                  ref
                      .read(
                          getSelectedVariantsProvider(type)(productId).notifier)
                      .updateSelectedCookingType(productId, null);
                },
              ),
            if (selectedPrimaryVariant != null &&
                cookingTypeVariants[selectedPrimaryVariant]?.isNotEmpty == true)
              RadioVariantGroup(
                title: variantLabel(context, ProductVariantKeys.cookingType),
                variants: cookingTypeVariants[selectedPrimaryVariant]!,
                selectedVariant: selectedCookingType,
                onChanged: (selected) {
                  ref
                      .read(
                          getSelectedVariantsProvider(type)(productId).notifier)
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
    try {
      print("Updating selected product variant with: $selectedVariants");
      final selectedVariant = productDetails.firstWhereOrNull((variant) =>
          selectedVariants.entries.every((entry) =>
              variant.variantInfo.contains("${entry.key}: ${entry.value}")));

      if (selectedVariant != null) {
        final productVariant = convertToProductVariant(selectedVariant);
        print(
            "Product variant found: ${productVariant.productVariantId} with price ${productVariant.amountPrice}");
        ref
            .read(getSelectedVariantsProvider(type)(productId).notifier)
            .updateSelectedVariant(productId, productVariant);
      } else {
        print("No matching product variant found");
        ref
            .read(getSelectedVariantsProvider(type)(productId).notifier)
            .updateSelectedVariant(productId, null);
      }
    } catch (e) {
      print("Failed to update selected product variant: $e");
    }
  }

  Variant convertToProductVariant(ProductDetailVariantCard card) {
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
    final grouped = <String, List<String>>{};
    for (final variant in variants) {
      if (variant.variants.containsKey(code)) {
        final key = variant.variants[code] ?? "";
        if (code == ProductVariantKeys.cookingType) {
          final primaryKey = variant.variants.values.firstWhere(
              (v) => v != variant.variants[ProductVariantKeys.cookingType],
              orElse: () => "");
          grouped.putIfAbsent(primaryKey, () => <String>[]).add(key);
        } else {
          grouped
              .putIfAbsent(key, () => <String>[])
              .add(variant.variants[ProductVariantKeys.cookingType] ?? "");
        }
      }
    }
    print("Grouped variants by code $code: $grouped");
    return grouped;
  }
}

class RadioVariantGroup extends StatelessWidget {
  final String title;
  final List<String> variants;
  final String? selectedVariant;
  final void Function(String?) onChanged;

  RadioVariantGroup({
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
