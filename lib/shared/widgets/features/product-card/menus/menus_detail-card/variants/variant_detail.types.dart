import "../menus_detail.types.dart";

class VariantMenuSelectorDetail {
  String productVariantId;
  String detail;
  int variantOrder;
  String variantInfo;
  Map<String, String> variants;

  VariantMenuSelectorDetail({
    required this.productVariantId,
    required this.detail,
    required this.variantOrder,
    required this.variantInfo,
    required this.variants,
  });

  factory VariantMenuSelectorDetail.fromJson(Map<String, dynamic> json) =>
      VariantMenuSelectorDetail(
        productVariantId: json["productVariantId"],
        detail: json["detail"],
        variantOrder: json["variantOrder"],
        variantInfo: json["variantInfo"],
        variants: Map<String, String>.from(json["variants"]),
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "detail": detail,
        "variantOrder": variantOrder,
        "variantInfo": variantInfo,
        "variants": variants,
      };

  static VariantMenuSelectorDetail fromMenuVariant(
      VariantMenuDetailCardData pv) {
    return VariantMenuSelectorDetail(
      productVariantId: pv.productVariantId,
      detail: pv.detail,
      variantOrder: pv.variantOrder.toInt(),
      variantInfo: pv.variantInfo,
      variants: pv.variants,
    );
  }
}
