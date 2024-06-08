import "../../combos_detail.types.dart";

class ComboDetailVariantCard {
  String productVariantId;
  String detail;
  int variantOrder;
  String variantInfo;
  final Map<String, String> variants;
  final double amountPrice = 0.0;

  ComboDetailVariantCard({
    required this.productVariantId,
    required this.detail,
    required this.variantOrder,
    required this.variantInfo,
    required this.variants,
  });

  Map<String, String> getVariantsMap() {
    return variants;
  }

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "detail": detail,
        "variantOrder": variantOrder,
        "variantInfo": variantInfo,
        "variants": variants,
      };

  ProductVariantComboDetailCardData _mapVariants(
      ComboDetailVariantCard response) {
    return ProductVariantComboDetailCardData(
      productVariantId: response.productVariantId,
      detail: response.detail,
      variantOrder: response.variantOrder,
      variantInfo: response.variantInfo,
    );
  }
}
