import "../product_detail.types.dart";

class ProductDetailVariantCard {
  final String productVariantId;
  final double amountPrice;
  final String currencyPrice;
  final String variantInfo;
  final Map<String, String> variants;
  final int variantOrder;

  ProductDetailVariantCard({
    required this.productVariantId,
    required this.amountPrice,
    required this.currencyPrice,
    required this.variantInfo,
    required this.variantOrder,
  }) : variants = Map.fromEntries(variantInfo
            .split(",")
            .map((String e) {
              final List<String> parts = e.trim().split(":");
              return parts.length >= 2
                  ? MapEntry(parts[0].trim(), parts[1].trim())
                  : null;
            })
            .where((MapEntry<String, String>? entry) => entry != null)
            .cast<MapEntry<String, String>>());

  static ProductDetailVariantCard fromProductVariant(ProductVariant pv) {
    return ProductDetailVariantCard(
      productVariantId: pv.productVariantId,
      amountPrice: pv.amountPrice,
      currencyPrice: pv.currencyPrice,
      variantInfo: pv.variantInfo,
      variantOrder: pv.variantOrder.toInt(),
    );
  }
}
