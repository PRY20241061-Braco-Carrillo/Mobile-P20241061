import "package:collection/collection.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../menus/menus_detail-card/menus_detail.types.dart";
import "../product_detail.types.dart";
import "variant_abstract.types.dart";
import "variants_keys.dart";

// Provider para los detalles del producto
final StateProvider<ProductDetailCardData?> productDetailCardDataProvider =
    StateProvider<ProductDetailCardData?>(
  (StateProviderRef<ProductDetailCardData?> ref) => null,
);

// Provider para los detalles del menú
final StateProvider<MenuDetailCardData?> menuDetailCardDataProvider =
    StateProvider<MenuDetailCardData?>(
  (StateProviderRef<MenuDetailCardData?> ref) => null,
);

final StateNotifierProviderFamily<SelectedVariantsNotifier,
        Map<String, SelectedVariantsState>, String>
    selectedProductVariantsProvider = StateNotifierProvider.family<
        SelectedVariantsNotifier, Map<String, SelectedVariantsState>, String>(
  (StateNotifierProviderRef<SelectedVariantsNotifier,
              Map<String, SelectedVariantsState>>
          ref,
      String productId) {
    return SelectedVariantsNotifier(productId);
  },
);

final StateNotifierProviderFamily<SelectedVariantsNotifier,
        Map<String, SelectedVariantsState>, String>
    selectedMenuVariantsProvider = StateNotifierProvider.family<
        SelectedVariantsNotifier, Map<String, SelectedVariantsState>, String>(
  (StateNotifierProviderRef<SelectedVariantsNotifier,
              Map<String, SelectedVariantsState>>
          ref,
      String menuId) {
    return SelectedVariantsNotifier(menuId);
  },
);

StateNotifierProviderFamily<
    SelectedVariantsNotifier,
    Map<String, SelectedVariantsState>,
    String> getSelectedVariantsProvider(String type) {
  return type == "product"
      ? selectedProductVariantsProvider
      : selectedMenuVariantsProvider;
}

StateProvider<dynamic> getDetailProvider(String type) {
  return type == "product"
      ? productDetailCardDataProvider
      : menuDetailCardDataProvider;
}

class SelectedVariantsState {
  final String? selectedSize;
  final String? selectedCookingType;
  final Variant? selectedVariant;

  SelectedVariantsState({
    this.selectedSize,
    this.selectedCookingType,
    this.selectedVariant,
  });

  SelectedVariantsState copyWith({
    String? selectedSize,
    String? selectedCookingType,
    Variant? selectedVariant,
  }) {
    return SelectedVariantsState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedCookingType: selectedCookingType ?? this.selectedCookingType,
      selectedVariant: selectedVariant ?? this.selectedVariant,
    );
  }
}

class SelectedVariantsNotifier
    extends StateNotifier<Map<String, SelectedVariantsState>> {
  final String id;
  List<Variant> availableVariants = [];

  SelectedVariantsNotifier(this.id) : super({});

  void initializeVariants(List<Variant> variants) {
    availableVariants = variants;
    print('Variants initialized for $id: $variants');
  }

  void updateSelectedSize(String productId, String? size) {
    final SelectedVariantsState stateForProduct =
        state[productId] ?? SelectedVariantsState();
    print('Updating selected size for $productId to $size');
    state = {
      ...state,
      productId: stateForProduct.copyWith(selectedSize: size),
    };
    _updateSelectedVariant(productId);
  }

  void updateSelectedCookingType(String productId, String? cookingType) {
    final SelectedVariantsState stateForProduct =
        state[productId] ?? SelectedVariantsState();
    print('Updating selected cooking type for $productId to $cookingType');
    state = {
      ...state,
      productId: stateForProduct.copyWith(selectedCookingType: cookingType),
    };
    _updateSelectedVariant(productId);
  }

  void updateSelectedVariant(String productId, Variant? variant) {
    final SelectedVariantsState stateForProduct =
        state[productId] ?? SelectedVariantsState();
    print(
        'Updating selected variant for $productId to ${variant?.productVariantId}');
    state = {
      ...state,
      productId: stateForProduct.copyWith(selectedVariant: variant),
    };
  }

  void _updateSelectedVariant(String productId) {
    final SelectedVariantsState? stateForProduct = state[productId];
    print('Current state for $productId: $stateForProduct');
    if (stateForProduct?.selectedSize != null &&
        stateForProduct?.selectedCookingType != null) {
      final Variant? selectedVariant = _findMatchingVariant(stateForProduct!);
      print(
          'Selected variant after matching: ${selectedVariant?.productVariantId}');
      state = {
        ...state,
        productId: stateForProduct.copyWith(selectedVariant: selectedVariant),
      };
    } else {
      print('Not all variants selected for $productId');
      state = {
        ...state,
        productId: stateForProduct!.copyWith(selectedVariant: null),
      };
    }
  }

  Variant? _findMatchingVariant(SelectedVariantsState state) {
    return availableVariants.firstWhereOrNull((variant) {
      final Map<String, String> variantMap = variant.getVariantsMap();
      return variantMap[ProductVariantKeys.size] == state.selectedSize &&
          variantMap[ProductVariantKeys.cookingType] ==
              state.selectedCookingType;
    });
  }
}
