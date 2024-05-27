import 'package:hooks_riverpod/hooks_riverpod.dart';
import "../../../menus/menus_detail-card/menus_detail.types.dart";
import 'variant_abstract.types.dart';
import 'variant_detail.types.dart';
import '../product_detail.types.dart';

// Provider para los detalles del producto
final productDetailCardDataProvider = StateProvider<ProductDetailCardData?>(
  (ref) => null,
);

// Provider para los detalles del menú
final menuDetailCardDataProvider = StateProvider<MenuDetailCardData?>(
  (ref) => null,
);

// Define los providers para productos y menús
final selectedProductVariantsProvider = StateNotifierProvider.family<
    SelectedVariantsNotifier, Map<String, SelectedVariantsState>, String>(
  (ref, productId) => SelectedVariantsNotifier(productId),
);

final selectedMenuVariantsProvider = StateNotifierProvider.family<
    SelectedVariantsNotifier, Map<String, SelectedVariantsState>, String>(
  (ref, menuId) => SelectedVariantsNotifier(menuId),
);

// Función para seleccionar el provider adecuado según el tipo
StateNotifierProviderFamily<
    SelectedVariantsNotifier,
    Map<String, SelectedVariantsState>,
    String> getSelectedVariantsProvider(String type) {
  return type == "product"
      ? selectedProductVariantsProvider
      : selectedMenuVariantsProvider;
}

// Función para seleccionar el provider de detalles adecuado según el tipo
StateProvider<dynamic> getDetailProvider(String type) {
  return type == "product"
      ? productDetailCardDataProvider
      : menuDetailCardDataProvider;
}

// Estado que representa las variantes seleccionadas
class SelectedVariantsState {
  final String? selectedSize;
  final String? selectedCookingType;
  final Variant? selectedVariant; // Usar la interfaz Variant

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

// Notificador para gestionar el estado de las variantes seleccionadas
class SelectedVariantsNotifier
    extends StateNotifier<Map<String, SelectedVariantsState>> {
  SelectedVariantsNotifier(String id) : super({});

  void updateSelectedSize(String productId, String? size) {
    final stateForProduct = state[productId] ?? SelectedVariantsState();
    print('Updating selected size for $productId to $size');
    state = {...state, productId: stateForProduct.copyWith(selectedSize: size)};
    _updateSelectedVariant(productId);
  }

  void updateSelectedCookingType(String productId, String? cookingType) {
    final stateForProduct = state[productId] ?? SelectedVariantsState();
    print('Updating selected cooking type for $productId to $cookingType');
    state = {
      ...state,
      productId: stateForProduct.copyWith(selectedCookingType: cookingType)
    };
    _updateSelectedVariant(productId);
  }

  void updateSelectedVariant(String productId, Variant? variant) {
    final stateForProduct = state[productId] ?? SelectedVariantsState();
    print(
        'Updating selected variant for $productId to ${variant?.productVariantId}');
    state = {
      ...state,
      productId: stateForProduct.copyWith(selectedVariant: variant)
    };
  }

  void _updateSelectedVariant(String productId) {
    final stateForProduct = state[productId];
    print('Current state for $productId: $stateForProduct');
    if (stateForProduct?.selectedSize != null &&
        stateForProduct?.selectedCookingType != null) {
      // Aquí deberías obtener la variante correcta basada en las selecciones
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
    // Implementa la lógica para encontrar la variante que coincida con el estado actual
    // Aquí puedes buscar en una lista de variantes disponibles y devolver la que coincida
    return null;
  }
}
