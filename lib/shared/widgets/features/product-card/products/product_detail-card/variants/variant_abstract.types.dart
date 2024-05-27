abstract class Variant {
  String get productVariantId;
  String get variantInfo;
  double get variantOrder;
  double get amountPrice;
  String get currencyPrice;

  Map<String, String> getVariantsMap();

  Map<String, dynamic> toJson();
}
