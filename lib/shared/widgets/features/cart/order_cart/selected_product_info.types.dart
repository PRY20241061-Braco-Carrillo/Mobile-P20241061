import "../../main-cards/combos/combos_detail-card/variants/combo/combo_detail.variant.types.dart";
import "../../main-cards/menus/menus_detail-card/variants/menu/menu_detail_variant.types.dart";
import "../../main-cards/products/product_detail-card/variants/product/product_detail_variant.types.dart";

class SelectedProductInfo {
  final String productId;
  final String productName;
  final double price;
  final String currency;
  final String imageUrl;
  final List<ProductDetailVariantCard> selectedProductVariants;
  final List<MenuDetailVariantCard> selectedMenuVariants;
  final List<ComboDetailVariantCard> selectedComboVariants;

  SelectedProductInfo({
    required this.productId,
    required this.productName,
    required this.price,
    required this.currency,
    required this.imageUrl,
    this.selectedProductVariants = const <ProductDetailVariantCard>[],
    this.selectedMenuVariants = const <MenuDetailVariantCard>[],
    this.selectedComboVariants = const <ComboDetailVariantCard>[],
    //this.selectedComplements = const <Complement>[],
  });

  double getTotalPrice() {
    double total = price;
    for (final variant in selectedProductVariants) {
      total += variant.amountPrice;
    }
    for (final variant in selectedMenuVariants) {
      total += variant.amountPrice;
    }
    for (final variant in selectedComboVariants) {
      total += variant.amountPrice;
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "productId": productId,
      "productName": productName,
      "price": price,
      "currency": currency,
      "imageUrl": imageUrl,
      "selectedProductVariants":
          selectedProductVariants.map((v) => v.toJson()).toList(),
      "selectedMenuVariants":
          selectedMenuVariants.map((v) => v.toJson()).toList(),
      "selectedComboVariants":
          selectedComboVariants.map((v) => v.toJson()).toList(),
    };
  }
}
