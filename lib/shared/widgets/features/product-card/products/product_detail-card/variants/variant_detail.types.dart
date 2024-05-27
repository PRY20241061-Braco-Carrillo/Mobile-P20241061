import "variant_abstract.types.dart";

class ProductDetailVariantCard {
  final String productVariantId;
  final double amountPrice;
  final String currencyPrice;
  final String variantInfo;
  final double variantOrder;
  final Map<String, String> variants;

  ProductDetailVariantCard({
    required this.productVariantId,
    required this.amountPrice,
    required this.currencyPrice,
    required this.variantInfo,
    required this.variantOrder,
    required this.variants,
  });

  factory ProductDetailVariantCard.fromVariant(Variant variant) {
    return ProductDetailVariantCard(
      productVariantId: variant.productVariantId,
      amountPrice: variant.amountPrice,
      currencyPrice: variant.currencyPrice,
      variantInfo: variant.variantInfo,
      variantOrder: variant.variantOrder,
      variants: variant.getVariantsMap(),
    );
  }
}
