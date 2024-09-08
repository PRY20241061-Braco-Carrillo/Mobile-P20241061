class ProductDetailVariantCard {
  final String productVariantId;
  final double amountPrice;
  final String currencyPrice;
  final String? variantInfo;
  final double variantOrder;
  final Map<String, String> variants;

  ProductDetailVariantCard({
    required this.productVariantId,
    required this.amountPrice,
    required this.currencyPrice,
    this.variantInfo,
    required this.variantOrder,
    required this.variants,
  });

  Map<String, String> getVariantsMap() {
    return variants;
  }

  Map<String, dynamic> toJson() {
    return {
      "productVariantId": productVariantId,
      "amountPrice": amountPrice,
      "currencyPrice": currencyPrice,
      "variantInfo": variantInfo ?? "",
      "variantOrder": variantOrder,
      "variants": variants,
    };
  }
}
