import "package:collection/collection.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../menus_detail.types.dart";
import "variant_detail.types.dart";
import "variants_keys.dart";

final StateProvider<String?> selectedSizeProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);
final StateProvider<String?> selectedCookingTypeProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);

final StateProvider<VariantMenuSelectorDetail?> selectedProductVariantProvider =
    StateProvider<VariantMenuSelectorDetail?>(
        (StateProviderRef<VariantMenuSelectorDetail?> ref) => null);

final StateProvider<MenuDetailCardData?> productDetailCardDataProvider =
    StateProvider<MenuDetailCardData?>(
        (StateProviderRef<MenuDetailCardData?> ref) => null);

class ProductVariantSelector extends ConsumerWidget {
  final List<VariantMenuSelectorDetail> productVariants;
  final MenuDetailCardData data;

  const ProductVariantSelector(
      {super.key, required this.productVariants, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Product variants: $productVariants");
    print("Product details: ${data}");
    Future<MenuDetailCardData>.microtask(
        () => ref.read(productDetailCardDataProvider.notifier).state = data);
    final List<VariantMenuSelectorDetail> productDetails = productVariants ?? []
      ..sort((VariantMenuSelectorDetail a, VariantMenuSelectorDetail b) =>
          a.variantOrder.compareTo(b.variantOrder));

    String? primaryVariantKey;
    for (final String key in <String>[
      MenuVariantKeys.pieces,
      MenuVariantKeys.weight,
      MenuVariantKeys.volume,
      MenuVariantKeys.size
    ]) {
      if (productDetails.any((VariantMenuSelectorDetail detail) =>
          detail.variants.containsKey(key))) {
        primaryVariantKey = key;
        break;
      }
    }

    final Map<String, List<String>> primaryVariants = groupVariantsByCode(
        productDetails, primaryVariantKey ?? MenuVariantKeys.size);
    final Map<String, List<String>> cookingTypeVariants =
        groupVariantsByCode(productDetails, MenuVariantKeys.cookingType);
    final String? selectedPrimaryVariant = ref.watch(selectedSizeProvider);
    final String? selectedCookingType = ref.watch(selectedCookingTypeProvider);

    // Actualización del objeto de variante seleccionado cuando hay cambios.
    ref.listen<String?>(selectedSizeProvider, (String? previous, String? next) {
      updateSelectedProductVariant(ref, productDetails, <String, String?>{
        MenuVariantKeys.size: next,
        MenuVariantKeys.cookingType: ref.read(selectedCookingTypeProvider)
      });
    });
    ref.listen<String?>(selectedCookingTypeProvider,
        (String? previous, String? next) {
      updateSelectedProductVariant(ref, productDetails, <String, String?>{
        MenuVariantKeys.size: ref.read(selectedSizeProvider),
        MenuVariantKeys.cookingType: next
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
      List<VariantMenuSelectorDetail> productDetails,
      Map<String, String?> selectedVariants) {
    try {
      final VariantMenuSelectorDetail? selectedVariant =
          productDetails.firstWhereOrNull((VariantMenuSelectorDetail variant) =>
              selectedVariants.entries.every(
                  (MapEntry<String, String?> entry) => variant.variantInfo
                      .contains("${entry.key}: ${entry.value}")));

      if (selectedVariant != null) {
        final VariantMenuDetailCardData productVariant =
            convertToProductVariant(selectedVariant);
        print(
            "Product variant found: ${productVariant?.productVariantId} with price ${productVariant?.detail}");
        ref.read(selectedProductVariantProvider.notifier).state =
            selectedVariant;
      } else {
        ref.read(selectedProductVariantProvider.notifier).state = null;
      }
    } on Exception catch (e) {
      print("Failed to update selected product variant: $e");
    }
  }

  VariantMenuDetailCardData convertToProductVariant(
      VariantMenuSelectorDetail card) {
    return VariantMenuDetailCardData(
      productVariantId: card.productVariantId,
      detail: card.detail,
      variantOrder: card.variantOrder,
      variantInfo: card.variantInfo,
      variants: card.variants,
    );
  }

  String variantLabel(BuildContext context, String key) {
    switch (key) {
      case MenuVariantKeys.pieces:
        return "Product.variants.CC02.label".tr();
      case MenuVariantKeys.weight:
        return "Product.variants.CC03.label".tr();
      case MenuVariantKeys.volume:
        return "Product.variants.CC04.label".tr();
      case MenuVariantKeys.size:
        return "Product.variants.CC05.label".tr();
      default:
        return "Unknown Variant";
    }
  }

  Map<String, List<String>> groupVariantsByCode(
      List<VariantMenuSelectorDetail> variants, String? code) {
    final Map<String, List<String>> grouped = <String, List<String>>{};
    for (final VariantMenuSelectorDetail variant in variants) {
      final String? value = variant.variants[code];
      if (value != null) {
        if (!grouped.containsKey(value)) {
          grouped[value] = <String>[];
        }
        grouped[value]?.add(variant.variantInfo);
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
