import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../utils/constants/variants_keys.dart';
import "combo_detail.variant.types.dart";
import "combo_variant.provider.dart";

class ComboVariantSelector extends ConsumerWidget {
  final String comboId;
  final List<ComboDetailVariantCard> variants;

  const ComboVariantSelector({
    super.key,
    required this.comboId,
    required this.variants,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
        .read(selectedComboVariantsProvider(comboId).notifier)
        .initializeVariants(variants);

    final SelectedVariantsState? selectedVariantsState =
        ref.watch(selectedComboVariantsProvider(comboId))[comboId];

    String? primaryVariantKey;
    for (final String key in <String>[
      ProductVariantKeys.pieces,
      ProductVariantKeys.weight,
      ProductVariantKeys.volume,
      ProductVariantKeys.size,
    ]) {
      if (variants.any((ComboDetailVariantCard detail) =>
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
        selectedComboVariantsProvider(comboId),
        (Map<String, SelectedVariantsState>? previous,
            Map<String, SelectedVariantsState> next) {
      if (previous?[comboId]?.selectedSize != next[comboId]?.selectedSize ||
          previous?[comboId]?.selectedCookingType !=
              next[comboId]?.selectedCookingType) {
        updateSelectedComboVariant(ref, variants, {
          ProductVariantKeys.size: next[comboId]?.selectedSize,
          ProductVariantKeys.cookingType: next[comboId]?.selectedCookingType,
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
                      .read(selectedComboVariantsProvider(comboId).notifier)
                      .updateSelectedSize(comboId, selected);
                  ref
                      .read(selectedComboVariantsProvider(comboId).notifier)
                      .updateSelectedCookingType(comboId, null);
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
                      .read(selectedComboVariantsProvider(comboId).notifier)
                      .updateSelectedCookingType(comboId, selected);
                },
              ),
          ],
        ),
      ),
    );
  }

  void updateSelectedComboVariant(
    WidgetRef ref,
    List<ComboDetailVariantCard> comboDetails,
    Map<String, String?> selectedVariants,
  ) {
    final selectedVariant = comboDetails.firstWhereOrNull((variant) {
      print(
          'Checking variant info: ${variant.variantInfo} with selected variants: $selectedVariants');
      return selectedVariants.entries.every((entry) =>
          entry.value == null ||
          variant.variantInfo.contains("${entry.key}: ${entry.value}"));
    });

    ref
        .read(selectedComboVariantsProvider(comboId).notifier)
        .updateSelectedVariant(comboId, selectedVariant);
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
    List<ComboDetailVariantCard> variants,
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
                  print('Selected variant in $title: $value');
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
