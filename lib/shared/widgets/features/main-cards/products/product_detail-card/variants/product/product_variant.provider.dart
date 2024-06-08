import "package:collection/collection.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "../../../../../../../utils/constants/variants_keys.dart";
import "../../product_detail.types.dart";
import "product_detail_variant.types.dart";

final StateProvider<ProductDetailCardData?> productDetailCardDataProvider =
    StateProvider<ProductDetailCardData?>(
  (StateProviderRef<ProductDetailCardData?> ref) => null,
);

final StateProviderFamily<bool, String> allVariantsSelectedProvider =
    StateProvider.family<bool, String>(
  (StateProviderRef<bool> ref, String productId) => false,
);

final StateNotifierProviderFamily<SelectedProductVariantsNotifier,
        Map<String, SelectedVariantsState>, String>
    selectedProductVariantsProvider = StateNotifierProvider.family<
        SelectedProductVariantsNotifier,
        Map<String, SelectedVariantsState>,
        String>(
  (StateNotifierProviderRef<SelectedProductVariantsNotifier,
              Map<String, SelectedVariantsState>>
          ref,
      String productId) {
    return SelectedProductVariantsNotifier(productId, ref);
  },
);

class SelectedVariantsState {
  final String? selectedSize;
  final String? selectedCookingType;
  final ProductDetailVariantCard? selectedVariant;
  final String? productName;
  final double? price;
  final String? currency;
  final String? imageUrl;

  SelectedVariantsState({
    this.selectedSize,
    this.selectedCookingType,
    this.selectedVariant,
    this.productName,
    this.price,
    this.currency,
    this.imageUrl,
  });

  SelectedVariantsState copyWith({
    String? selectedSize,
    String? selectedCookingType,
    ProductDetailVariantCard? selectedVariant,
    String? productName,
    double? price,
    String? currency,
    String? imageUrl,
  }) {
    return SelectedVariantsState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedCookingType: selectedCookingType ?? this.selectedCookingType,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class SelectedProductVariantsNotifier
    extends StateNotifier<Map<String, SelectedVariantsState>> {
  final String productId;
  final Ref ref;
  List<ProductDetailVariantCard> availableVariants =
      <ProductDetailVariantCard>[];

  SelectedProductVariantsNotifier(this.productId, this.ref)
      : super(<String, SelectedVariantsState>{});

  void initializeVariants(List<ProductDetailVariantCard> variants) {
    availableVariants = variants;
    if (variants.length == 1) {
      updateSelectedVariant(productId, variants.first);
    }
  }

  void updateSelectedSize(String productId, String? size) {
    final SelectedVariantsState stateForProduct =
        state[productId] ?? SelectedVariantsState();
    state = <String, SelectedVariantsState>{
      ...state,
      productId: stateForProduct.copyWith(selectedSize: size),
    };
    _updateSelectedVariant(productId);
  }

  void updateSelectedCookingType(String productId, String? cookingType) {
    final SelectedVariantsState stateForProduct =
        state[productId] ?? SelectedVariantsState();
    state = <String, SelectedVariantsState>{
      ...state,
      productId: stateForProduct.copyWith(selectedCookingType: cookingType),
    };
    _updateSelectedVariant(productId);
  }

  void updateSelectedVariant(
      String productId, ProductDetailVariantCard? variant) {
    final SelectedVariantsState stateForProduct =
        state[productId] ?? SelectedVariantsState();

    state = <String, SelectedVariantsState>{
      ...state,
      productId: stateForProduct.copyWith(selectedVariant: variant),
    };
    ref.read(allVariantsSelectedProvider(productId).notifier).state = true;
  }

  void updateProductDetails(String productId, String productName, double price,
      String currency, String imageUrl) {
    final SelectedVariantsState stateForProduct =
        state[productId] ?? SelectedVariantsState();

    state = <String, SelectedVariantsState>{
      ...state,
      productId: stateForProduct.copyWith(
        productName: productName,
        price: price,
        currency: currency,
        imageUrl: imageUrl,
      ),
    };
  }

  void _updateSelectedVariant(String productId) {
    final SelectedVariantsState? stateForProduct = state[productId];

    final bool hasAllVariantsSelected =
        _areAllVariantsSelected(stateForProduct);
    ref.read(allVariantsSelectedProvider(productId).notifier).state =
        hasAllVariantsSelected;

    if (hasAllVariantsSelected) {
      final ProductDetailVariantCard? selectedVariant =
          _findMatchingVariant(stateForProduct!);

      state = <String, SelectedVariantsState>{
        ...state,
        productId: stateForProduct.copyWith(selectedVariant: selectedVariant),
      };
    } else {
      state = <String, SelectedVariantsState>{
        ...state,
        productId: stateForProduct!.copyWith(selectedVariant: null),
      };
    }
  }

  bool _areAllVariantsSelected(SelectedVariantsState? stateForProduct) {
    if (availableVariants.length == 1) return true;

    final Set<String> requiredVariantKeys = availableVariants
        .expand(
            (ProductDetailVariantCard variant) => variant.getVariantsMap().keys)
        .toSet();

    for (final String key in requiredVariantKeys) {
      if (stateForProduct?.selectedSize == null &&
          key == ProductVariantKeys.size) {
        return false;
      }
      if (stateForProduct?.selectedCookingType == null &&
          key == ProductVariantKeys.cookingType) {
        return false;
      }
    }
    return true;
  }

  ProductDetailVariantCard? _findMatchingVariant(SelectedVariantsState state) {
    return availableVariants
        .firstWhereOrNull((ProductDetailVariantCard variant) {
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
