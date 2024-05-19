import "package:json_annotation/json_annotation.dart";

import "../../../../shared/widgets/features/product-card/product_detail-card/product_detail.types.dart";

@JsonSerializable()
class VariantsByProductResponse {
  Product product;
  List<ProductVariant> productVariants;
  List<Complement> complements;

  VariantsByProductResponse({
    required this.product,
    required this.productVariants,
    required this.complements,
  });

  factory VariantsByProductResponse.fromJson(Map<String, dynamic> json) =>
      VariantsByProductResponse(
        product: Product.fromJson(json["product"]),
        productVariants: List<ProductVariant>.from(
            json["productVariants"].map((x) => ProductVariant.fromJson(x))),
        complements: List<Complement>.from(
            json["complements"].map((x) => Complement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "productVariants": List<dynamic>.from(
            productVariants.map((ProductVariant x) => x.toJson())),
        "complements":
            List<dynamic>.from(complements.map((Complement x) => x.toJson())),
      };
}
