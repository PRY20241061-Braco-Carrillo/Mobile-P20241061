import "package:collection/collection.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "order_cart.types.dart";
import "selected_product_info.types.dart";

final StateNotifierProvider<CartNotifier, List<CartItem>> cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>(
  (StateNotifierProviderRef<CartNotifier, List<CartItem>> ref) =>
      CartNotifier(),
);

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(<CartItem>[]);

  void addProduct(SelectedProductInfo productInfo, [String campusId = ""]) {
    final CartItem? existingItem = state.firstWhereOrNull((CartItem item) =>
        item.productInfo.productId == productInfo.productId &&
        _areVariantsAndComplementsEqual(item.productInfo, productInfo));

    if (existingItem != null) {
      existingItem.increment();
    } else {
      state = <CartItem>[
        ...state,
        CartItem(
          productInfo: productInfo,
        )
      ];
    }
    state = <CartItem>[...state];
  }

  void removeProduct(String productId) {
    state = state
        .where((CartItem item) => item.productInfo.productId != productId)
        .toList();
  }

  void updateQuantity(String productId, int quantity) {
    final CartItem? item = state.firstWhereOrNull(
        (CartItem item) => item.productInfo.productId == productId);
    if (item != null) {
      if (quantity > 0) {
        item.quantity = quantity;
      } else {
        removeProduct(productId);
      }
      state = <CartItem>[...state];
    }
  }

  void resetCart() {
    state = <CartItem>[];
    state = <CartItem>[...state];
  }

  bool _areVariantsAndComplementsEqual(
      SelectedProductInfo info1, SelectedProductInfo info2) {
    return const ListEquality<dynamic>().equals(
            info1.selectedProductVariants, info2.selectedProductVariants) &&
        const ListEquality<dynamic>()
            .equals(info1.selectedMenuVariants, info2.selectedMenuVariants) &&
        const ListEquality<dynamic>()
            .equals(info1.selectedComboVariants, info2.selectedComboVariants) &&
        const ListEquality<dynamic>().equals(
            info1.selectedPromotionVariants, info2.selectedPromotionVariants);
  }
}
