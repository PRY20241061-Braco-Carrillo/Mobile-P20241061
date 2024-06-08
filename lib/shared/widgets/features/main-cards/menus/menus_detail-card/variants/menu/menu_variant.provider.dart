import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../menus_detail.types.dart';
import 'menu_detail_variant.types.dart';

final StateProvider<MenuDetailCardData?> menuDetailCardDataProvider =
    StateProvider<MenuDetailCardData?>(
  (StateProviderRef<MenuDetailCardData?> ref) => null,
);

// Proveedores para cada categoría
final selectedDessertsVariantsProvider =
    StateNotifierProvider<SelectedMenuVariantsNotifier, SelectedVariantsState>(
  (ref) => SelectedMenuVariantsNotifier("desserts", ref),
);

final selectedDrinksVariantsProvider =
    StateNotifierProvider<SelectedMenuVariantsNotifier, SelectedVariantsState>(
  (ref) => SelectedMenuVariantsNotifier("drinks", ref),
);

final selectedInitialDishesVariantsProvider =
    StateNotifierProvider<SelectedMenuVariantsNotifier, SelectedVariantsState>(
  (ref) => SelectedMenuVariantsNotifier("initialDishes", ref),
);

final selectedPrincipalDishesVariantsProvider =
    StateNotifierProvider<SelectedMenuVariantsNotifier, SelectedVariantsState>(
  (ref) => SelectedMenuVariantsNotifier("principalDishes", ref),
);

// Proveedor para habilitar el botón
final buttonEnabledProvider = StateProvider.family<bool, String>((ref, menuId) {
  final initialDishState = ref.watch(selectedInitialDishesVariantsProvider);
  final principalDishState = ref.watch(selectedPrincipalDishesVariantsProvider);
  final drinkState = ref.watch(selectedDrinksVariantsProvider);
  final dessertState = ref.watch(selectedDessertsVariantsProvider);

  return initialDishState.selectedVariant != null &&
      principalDishState.selectedVariant != null &&
      drinkState.selectedVariant != null &&
      dessertState.selectedVariant != null;
});

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
    extends StateNotifier<SelectedVariantsState> {
  final String menuId;
  final Ref ref;
  List<MenuDetailVariantCard> availableVariants = <MenuDetailVariantCard>[];

  SelectedMenuVariantsNotifier(this.menuId, this.ref)
      : super(SelectedVariantsState());

  void initializeVariants(List<MenuDetailVariantCard> variants) {
    availableVariants = variants;
    if (variants.length == 1 || variants.first.variantInfo == '') {
      print("Automatically selecting the only variant available for $menuId");
      updateSelectedVariant(variants.first);
    }
  }

  void resetVariants() {
    state = SelectedVariantsState();
    print("Variants reset for menuId: $menuId");
  }

  void updateSelectedSize(String? size) {
    state = state.copyWith(selectedSize: size);
    resetVariants();
  }

  void updateSelectedCookingType(String? cookingType) {
    state = state.copyWith(selectedCookingType: cookingType);
  }

  void updateSelectedVariant(MenuDetailVariantCard? variant) {
    state = state.copyWith(selectedVariant: variant);
    _updateAllVariantsSelected();
  }

  void updateMenuDetails(
      String menuName, double price, String currency, String imageUrl) {
    state = state.copyWith(
      menuName: menuName,
      price: price,
      currency: currency,
      imageUrl: imageUrl,
    );
  }

  void _updateAllVariantsSelected() {
    final allSelected =
        state.selectedSize != null && state.selectedCookingType != null;
    ref.read(buttonEnabledProvider(menuId).notifier).state = allSelected;
    if (allSelected) {
      print("All variants are selected for menuId: $menuId");
    } else {
      print("Not all variants are selected for menuId: $menuId");
    }
  }
}

final selectedMenuVariantsProvider = StateNotifierProvider.family<
    SelectedMenuVariantsNotifier, SelectedVariantsState, String>(
  (ref, menuId) {
    return SelectedMenuVariantsNotifier(menuId, ref);
  },
);
