import "package:collection/collection.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../../../../utils/constants/variants_keys.dart";
import "../../menus_detail.types.dart";
import "menu_detail_variant.types.dart";

final StateProvider<MenuDetailCardData?> menuDetailCardDataProvider =
    StateProvider<MenuDetailCardData?>(
  (StateProviderRef<MenuDetailCardData?> ref) => null,
);

final StateProviderFamily<bool, String> allMenuVariantsSelectedProvider =
    StateProvider.family<bool, String>(
  (StateProviderRef<bool> ref, String menuId) => false,
);

final StateNotifierProviderFamily<SelectedMenuVariantsNotifier,
        Map<String, SelectedVariantsState>, String>
    selectedMenuVariantsProvider = StateNotifierProvider.family<
        SelectedMenuVariantsNotifier,
        Map<String, SelectedVariantsState>,
        String>(
  (StateNotifierProviderRef<SelectedMenuVariantsNotifier,
              Map<String, SelectedVariantsState>>
          ref,
      String menuId) {
    return SelectedMenuVariantsNotifier(menuId, ref);
  },
);

class SelectedVariantsState {
  final String? selectedSize;
  final String? selectedCookingType;
  final MenuDetailVariantCard? selectedVariant;
  final String? menuName;
  final double? price;
  final String? currency;
  final String? imageUrl;

  SelectedVariantsState({
    this.selectedSize,
    this.selectedCookingType,
    this.selectedVariant,
    this.menuName,
    this.price,
    this.currency,
    this.imageUrl,
  });

  SelectedVariantsState copyWith({
    String? selectedSize,
    String? selectedCookingType,
    MenuDetailVariantCard? selectedVariant,
    String? menuName,
    double? price,
    String? currency,
    String? imageUrl,
  }) {
    return SelectedVariantsState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedCookingType: selectedCookingType ?? this.selectedCookingType,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      menuName: menuName ?? this.menuName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class SelectedMenuVariantsNotifier
    extends StateNotifier<Map<String, SelectedVariantsState>> {
  final String menuId;
  final Ref ref;
  List<MenuDetailVariantCard> availableVariants = <MenuDetailVariantCard>[];

  SelectedMenuVariantsNotifier(this.menuId, this.ref)
      : super(<String, SelectedVariantsState>{});

  void initializeVariants(List<MenuDetailVariantCard> variants) {
    availableVariants = variants;
    print('Variants initialized for $menuId: $variants');
    if (variants.length == 1) {
      updateSelectedVariant(menuId, variants.first);
    }
  }

  void updateSelectedSize(String menuId, String? size) {
    final SelectedVariantsState stateForMenu =
        state[menuId] ?? SelectedVariantsState();
    state = <String, SelectedVariantsState>{
      ...state,
      menuId: stateForMenu.copyWith(selectedSize: size),
    };
    _updateSelectedVariant(menuId);
  }

  void updateSelectedCookingType(String menuId, String? cookingType) {
    final SelectedVariantsState stateForMenu =
        state[menuId] ?? SelectedVariantsState();
    state = <String, SelectedVariantsState>{
      ...state,
      menuId: stateForMenu.copyWith(selectedCookingType: cookingType),
    };
    _updateSelectedVariant(menuId);
  }

  void updateSelectedVariant(String menuId, MenuDetailVariantCard? variant) {
    final SelectedVariantsState stateForMenu =
        state[menuId] ?? SelectedVariantsState();

    state = <String, SelectedVariantsState>{
      ...state,
      menuId: stateForMenu.copyWith(selectedVariant: variant),
    };
    ref.read(allMenuVariantsSelectedProvider(menuId).notifier).state = true;
  }

  void updateMenuDetails(String menuId, String menuName, double price,
      String currency, String imageUrl) {
    final SelectedVariantsState stateForMenu =
        state[menuId] ?? SelectedVariantsState();

    state = <String, SelectedVariantsState>{
      ...state,
      menuId: stateForMenu.copyWith(
        menuName: menuName,
        price: price,
        currency: currency,
        imageUrl: imageUrl,
      ),
    };
  }

  void _updateSelectedVariant(String menuId) {
    final SelectedVariantsState? stateForMenu = state[menuId];
    final bool hasAllVariantsSelected = _areAllVariantsSelected(stateForMenu);
    ref.read(allMenuVariantsSelectedProvider(menuId).notifier).state =
        hasAllVariantsSelected;

    if (hasAllVariantsSelected) {
      final MenuDetailVariantCard? selectedVariant =
          _findMatchingVariant(stateForMenu!);
      state = <String, SelectedVariantsState>{
        ...state,
        menuId: stateForMenu.copyWith(selectedVariant: selectedVariant),
      };
    } else {
      state = <String, SelectedVariantsState>{
        ...state,
        menuId: stateForMenu!.copyWith(selectedVariant: null),
      };
    }
  }

  bool _areAllVariantsSelected(SelectedVariantsState? stateForMenu) {
    if (availableVariants.length == 1) return true;

    final Set<String> requiredVariantKeys = availableVariants
        .expand(
            (MenuDetailVariantCard variant) => variant.getVariantsMap().keys)
        .toSet();

    for (final String key in requiredVariantKeys) {
      if (stateForMenu?.selectedSize == null &&
          key == ProductVariantKeys.size) {
        return false;
      }
      if (stateForMenu?.selectedCookingType == null &&
          key == ProductVariantKeys.cookingType) {
        return false;
      }
    }
    return true;
  }

  MenuDetailVariantCard? _findMatchingVariant(SelectedVariantsState state) {
    return availableVariants.firstWhereOrNull((MenuDetailVariantCard variant) {
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
