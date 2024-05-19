import "selected_product_info.types.dart";

class CartItem {
  SelectedProductInfo productInfo;
  int quantity;

  CartItem({required this.productInfo, this.quantity = 1});

  void increment() {
    quantity++;
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
