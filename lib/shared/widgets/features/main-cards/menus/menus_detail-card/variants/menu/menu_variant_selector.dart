import "package:collection/collection.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../../../../utils/constants/variants_keys.dart";
import "menu_detail_variant.types.dart";
import "menu_variant.provider.dart";

class MenuVariantSelector extends ConsumerStatefulWidget {
  final String menuId;
  final List<MenuDetailVariantCard> variants;

  const MenuVariantSelector({
    super.key,
    required this.menuId,
    required this.variants,
  });

  @override
  MenuVariantSelectorState createState() => MenuVariantSelectorState();
}

class MenuVariantSelectorState extends ConsumerState<MenuVariantSelector> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      print('Initializing variants for menuId: ${widget.menuId}');
      ref
          .read(selectedMenuVariantsProvider(widget.menuId).notifier)
          .initializeVariants(widget.variants);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelectedVariantsState? selectedVariantsState =
        ref.watch(selectedMenuVariantsProvider(widget.menuId))[widget.menuId];
    widget.variants.forEach((variant) {
      print('Variant: $variant');
    });
    print("Building MenuVariantSelector for menuId: ${widget.menuId}");

    String? primaryVariantKey;
    for (final String key in <String>[
      ProductVariantKeys.pieces,
      ProductVariantKeys.weight,
      ProductVariantKeys.volume,
      ProductVariantKeys.size,
    ]) {
      if (widget.variants.any(
          (MenuDetailVariantCard detail) => detail.variants.containsKey(key))) {
        primaryVariantKey = key;
        break;
      }
    }

    final Map<String, List<String>> primaryVariants = groupVariantsByCode(
      widget.variants,
      primaryVariantKey ?? ProductVariantKeys.size,
    );

    final Map<String, List<String>> cookingTypeVariants = groupVariantsByCode(
      widget.variants,
      ProductVariantKeys.cookingType,
    );

    final String? selectedPrimaryVariant = selectedVariantsState?.selectedSize;
    final String? selectedCookingType =
        selectedVariantsState?.selectedCookingType;

    print("Primary variants: $primaryVariants");
    print("Cooking type variants: $cookingTypeVariants");

    ref.listen<Map<String, SelectedVariantsState>>(
        selectedMenuVariantsProvider(widget.menuId),
        (Map<String, SelectedVariantsState>? previous,
            Map<String, SelectedVariantsState> next) {
      if (previous?[widget.menuId]?.selectedSize !=
              next[widget.menuId]?.selectedSize ||
          previous?[widget.menuId]?.selectedCookingType !=
              next[widget.menuId]?.selectedCookingType) {
        updateSelectedMenuVariant(ref, widget.variants, <String, String?>{
          ProductVariantKeys.size: next[widget.menuId]?.selectedSize,
          ProductVariantKeys.cookingType:
              next[widget.menuId]?.selectedCookingType,
        });
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (primaryVariantKey != null)
          RadioVariantGroup(
            title: variantLabel(context, primaryVariantKey),
            variants: primaryVariants.keys.toList(),
            selectedVariant: selectedPrimaryVariant,
            onChanged: (String? selected) {
              print("Primary variant selected: $selected");
              ref
                  .read(selectedMenuVariantsProvider(widget.menuId).notifier)
                  .updateSelectedSize(widget.menuId, selected);
              ref
                  .read(selectedMenuVariantsProvider(widget.menuId).notifier)
                  .updateSelectedCookingType(widget.menuId, null);
            },
          ),
        if (selectedPrimaryVariant != null &&
            cookingTypeVariants[selectedPrimaryVariant]?.isNotEmpty == true)
          RadioVariantGroup(
            title: variantLabel(context, ProductVariantKeys.cookingType),
            variants: cookingTypeVariants[selectedPrimaryVariant]!,
            selectedVariant: selectedCookingType,
            onChanged: (String? selected) {
              print("Cooking type variant selected: $selected");
              ref
                  .read(selectedMenuVariantsProvider(widget.menuId).notifier)
                  .updateSelectedCookingType(widget.menuId, selected);
            },
          ),
      ],
    );
  }

  void updateSelectedMenuVariant(
    WidgetRef ref,
    List<MenuDetailVariantCard> menuDetails,
    Map<String, String?> selectedVariants,
  ) {
    final MenuDetailVariantCard? selectedVariant =
        menuDetails.firstWhereOrNull((MenuDetailVariantCard variant) {
      return selectedVariants.entries.every((MapEntry<String, String?> entry) =>
          entry.value == null ||
          variant.variantInfo.contains("${entry.key}: ${entry.value}"));
    });

    ref
        .read(selectedMenuVariantsProvider(widget.menuId).notifier)
        .updateSelectedVariant(widget.menuId, selectedVariant);
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
    List<MenuDetailVariantCard> variants,
    String? code,
  ) {
    final Map<String, List<String>> grouped = <String, List<String>>{};
    for (final MenuDetailVariantCard variant in variants) {
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
