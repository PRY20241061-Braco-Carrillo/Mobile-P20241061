import "package:collection/collection.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../../../../utils/constants/variants_keys.dart";
import "../../combos_detail.types.dart";
import "combo_detail.variant.types.dart";

final StateProvider<ComboDetailCardData?> comboDetailCardDataProvider =
    StateProvider<ComboDetailCardData?>(
  (StateProviderRef<ComboDetailCardData?> ref) => null,
);

final StateProviderFamily<bool, String> allComboVariantsSelectedProvider =
    StateProvider.family<bool, String>(
  (StateProviderRef<bool> ref, String comboId) => false,
);

final StateNotifierProviderFamily<SelectedComboVariantsNotifier,
        Map<String, SelectedVariantsState>, String>
    selectedComboVariantsProvider = StateNotifierProvider.family<
        SelectedComboVariantsNotifier,
        Map<String, SelectedVariantsState>,
        String>(
  (StateNotifierProviderRef<SelectedComboVariantsNotifier,
              Map<String, SelectedVariantsState>>
          ref,
      String comboId) {
    return SelectedComboVariantsNotifier(comboId, ref);
  },
);

class SelectedVariantsState {
  final String? selectedSize;
  final String? selectedCookingType;
  final ComboDetailVariantCard? selectedVariant;
  final String? comboName;
  final double? price;
  final String? currency;
  final String? imageUrl;

  SelectedVariantsState({
    this.selectedSize,
    this.selectedCookingType,
    this.selectedVariant,
    this.comboName,
    this.price,
    this.currency,
    this.imageUrl,
  });

  SelectedVariantsState copyWith({
    String? selectedSize,
    String? selectedCookingType,
    ComboDetailVariantCard? selectedVariant,
    String? comboName,
    double? price,
    String? currency,
    String? imageUrl,
  }) {
    return SelectedVariantsState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedCookingType: selectedCookingType ?? this.selectedCookingType,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      comboName: comboName ?? comboName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class SelectedComboVariantsNotifier
    extends StateNotifier<Map<String, SelectedVariantsState>> {
  final String comboId;
  final Ref ref;
  List<ComboDetailVariantCard> availableVariants = <ComboDetailVariantCard>[];

  SelectedComboVariantsNotifier(this.comboId, this.ref)
      : super(<String, SelectedVariantsState>{});

  void initializeVariants(List<ComboDetailVariantCard> variants) {
    availableVariants = variants;
    if (variants.length == 1) {
      updateSelectedVariant(comboId, variants.first);
    }
  }

  void updateSelectedSize(String comboId, String? size) {
    final SelectedVariantsState stateForCombo =
        state[comboId] ?? SelectedVariantsState();
    state = <String, SelectedVariantsState>{
      ...state,
      comboId: stateForCombo.copyWith(selectedSize: size),
    };
    _updateSelectedVariant(comboId);
  }

  void updateSelectedCookingType(String comboId, String? cookingType) {
    final SelectedVariantsState stateForCombo =
        state[comboId] ?? SelectedVariantsState();
    state = <String, SelectedVariantsState>{
      ...state,
      comboId: stateForCombo.copyWith(selectedCookingType: cookingType),
    };
    _updateSelectedVariant(comboId);
  }

  void updateSelectedVariant(String comboId, ComboDetailVariantCard? variant) {
    final SelectedVariantsState stateForCombo =
        state[comboId] ?? SelectedVariantsState();

    state = <String, SelectedVariantsState>{
      ...state,
      comboId: stateForCombo.copyWith(selectedVariant: variant),
    };
    ref.read(allComboVariantsSelectedProvider(comboId).notifier).state = true;
  }

  void updateComboDetails(String comboId, String comboName, double price,
      String currency, String imageUrl) {
    final SelectedVariantsState stateForCombo =
        state[comboId] ?? SelectedVariantsState();

    state = <String, SelectedVariantsState>{
      ...state,
      comboId: stateForCombo.copyWith(
        comboName: comboName,
        price: price,
        currency: currency,
        imageUrl: imageUrl,
      ),
    };
  }

  void _updateSelectedVariant(String comboId) {
    final SelectedVariantsState? stateForCombo = state[comboId];

    final bool hasAllVariantsSelected = _areAllVariantsSelected(stateForCombo);
    ref.read(allComboVariantsSelectedProvider(comboId).notifier).state =
        hasAllVariantsSelected;

    if (hasAllVariantsSelected) {
      final ComboDetailVariantCard? selectedVariant =
          _findMatchingVariant(stateForCombo!);

      state = <String, SelectedVariantsState>{
        ...state,
        comboId: stateForCombo.copyWith(selectedVariant: selectedVariant),
      };
    } else {
      state = <String, SelectedVariantsState>{
        ...state,
        comboId: stateForCombo!.copyWith(selectedVariant: null),
      };
    }
  }

  bool _areAllVariantsSelected(SelectedVariantsState? stateForCombo) {
    if (availableVariants.length == 1) return true;

    final Set<String> requiredVariantKeys = availableVariants
        .expand(
            (ComboDetailVariantCard variant) => variant.getVariantsMap().keys)
        .toSet();

    for (final String key in requiredVariantKeys) {
      if (stateForCombo?.selectedSize == null &&
          key == ProductVariantKeys.size) {
        return false;
      }
      if (stateForCombo?.selectedCookingType == null &&
          key == ProductVariantKeys.cookingType) {
        return false;
      }
    }
    return true;
  }

  ComboDetailVariantCard? _findMatchingVariant(SelectedVariantsState state) {
    return availableVariants.firstWhereOrNull((ComboDetailVariantCard variant) {
      final Map<String, String> variantMap = variant.getVariantsMap();
      final bool sizeMatches = state.selectedSize == null ||
          variantMap[ProductVariantKeys.size] == state.selectedSize;
      final bool cookingTypeMatches = state.selectedCookingType == null ||
          variantMap[ProductVariantKeys.cookingType] ==
              state.selectedCookingType;
      return sizeMatches && cookingTypeMatches;
    });
  }
}
