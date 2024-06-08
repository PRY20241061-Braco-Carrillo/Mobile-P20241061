class MenuDetailVariantCard {
  final String productVariantId;
  final double detail;
  final String variantInfo;
  final double variantOrder;
  final Map<String, String> variants;
  final double amountPrice = 0.0;

  MenuDetailVariantCard({
    required this.productVariantId,
    required this.detail,
    required this.variantInfo,
    required this.variantOrder,
    required this.variants,
  });

  Map<String, String> getVariantsMap() {
    return variants;
  }

  Map<String, dynamic> toJson() {
    return {
      "productVariantId": productVariantId,
      "detail": detail,
      "variantInfo": variantInfo,
      "variantOrder": variantOrder,
      "variants": variants,
    };
  }

  //Metodo toString
  @override
  String toString() {
    return 'MenuDetailVariantCard(productVariantId: $productVariantId, detail: $detail, variantInfo: $variantInfo, variantOrder: $variantOrder, variants: $variants)';
  }
}
