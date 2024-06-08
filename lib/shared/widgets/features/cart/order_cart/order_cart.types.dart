import "selected_product_info.types.dart";

class CartItem {
  SelectedProductInfo productInfo;
  int quantity;
  String campusId = "";

  CartItem({
    required this.productInfo,
    this.quantity = 1,
  });

  void increment() {
    quantity++;
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }

  void setCampusId(String campusId) {
    this.campusId = campusId;
  }

  String getCampusId() {
    return campusId;
  }
}
