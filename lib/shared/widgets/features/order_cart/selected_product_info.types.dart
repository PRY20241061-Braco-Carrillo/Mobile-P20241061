import "../product-card/products/product_detail-card/product_detail.types.dart";

class SelectedProductInfo {
  final String productId;
  final String productName;
  final double price;
  final String currency;
  final String imageUrl;
  final List<ProductVariant> selectedVariants;
  final List<Complement> selectedComplements;

  SelectedProductInfo({
    required this.productId,
    required this.productName,
    required this.price,
    required this.currency,
    required this.imageUrl,
    this.selectedVariants = const <ProductVariant>[],
    this.selectedComplements = const <Complement>[],
  });

  double getTotalPrice() {
    double total = price;
    for (final ProductVariant variant in selectedVariants) {
      total += variant.amountPrice;
    }
    for (final Complement complement in selectedComplements) {
      total += complement.amountPrice;
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
      "selectedVariants":
          selectedVariants.map((ProductVariant v) => v.toJson()).toList(),
      "selectedComplements":
          selectedComplements.map((Complement c) => c.toJson()).toList(),
    };
  }
}
