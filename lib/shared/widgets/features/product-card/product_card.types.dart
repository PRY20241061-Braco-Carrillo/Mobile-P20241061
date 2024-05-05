/*import "package:json_annotation/json_annotation.dart";
import "../../../utils/constants/currency_types.dart";
import "../../../utils/constants/time_range.types.dart";
part "product_card.types.g.dart";

enum MenuCardFooterButtonTypes { add, ar, view, promotionDetail }

enum MenuDiscountLabels { percent, currency, especialCard }

abstract class MenuCardDiscount {
  String getType();
}

@JsonSerializable()
class PercentDiscountLabel extends MenuCardDiscount {
  final String type = MenuDiscountLabels.percent.toString();
  final String quantity;

  PercentDiscountLabel({required this.quantity});

  @override
  String getType() => type;

  factory PercentDiscountLabel.fromJson(Map<String, dynamic> json) =>
      _$PercentDiscountLabelFromJson(json);

  Map<String, dynamic> toJson() => _$PercentDiscountLabelToJson(this);
}

@JsonSerializable()
class CurrencyDiscountLabel extends MenuCardDiscount {
  final String type = MenuDiscountLabels.currency.toString();
  final String quantity;
  final Currency currency;

  CurrencyDiscountLabel({required this.quantity, required this.currency});

  @override
  String getType() => type;

  factory CurrencyDiscountLabel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDiscountLabelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyDiscountLabelToJson(this);
}

@JsonSerializable()
class SpecialCardDiscountLabel extends MenuCardDiscount {
  final String type = MenuDiscountLabels.especialCard.toString();
  final String card;
  final String quantity;

  SpecialCardDiscountLabel({required this.card, required this.quantity});

  @override
  String getType() => type;

  factory SpecialCardDiscountLabel.fromJson(Map<String, dynamic> json) =>
      _$SpecialCardDiscountLabelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialCardDiscountLabelToJson(this);
}

@JsonSerializable()
class MenuCardSizeLabel {
  final String size;

  MenuCardSizeLabel({required this.size});

  factory MenuCardSizeLabel.fromJson(Map<String, dynamic> json) =>
      _$MenuCardSizeLabelFromJson(json);
}

@JsonSerializable()
class MenuCardPrice {
  final String price;
  final Currency currency;

  MenuCardPrice({required this.price, required this.currency});

  factory MenuCardPrice.fromJson(Map<String, dynamic> json) =>
      _$MenuCardPriceFromJson(json);
}

@JsonSerializable()
class MenuCardPrimaryImage {
  final String url;
  @JsonKey(name: "discountLabel")
  final List<dynamic>? discountLabelDynamic;
  final MenuCardSizeLabel? sizeLabel;

  List<MenuCardDiscount>? get discountLabel =>
      _convertDiscountLabels(discountLabelDynamic ?? <List<dynamic>>[]);

  MenuCardPrimaryImage(
      {required this.url, this.discountLabelDynamic, this.sizeLabel});

  factory MenuCardPrimaryImage.fromJson(Map<String, dynamic> json) =>
      _$MenuCardPrimaryImageFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCardPrimaryImageToJson(this);
}

List<MenuCardDiscount> _convertDiscountLabels(List<dynamic> discountJson) {
  // ignore: always_specify_types
  return discountJson.map<MenuCardDiscount>((item) {
    // ignore: always_specify_types, avoid_dynamic_calls
    final type = item["type"];
    switch (type) {
      case "percent":
        return PercentDiscountLabel.fromJson(item);
      case "currency":
        return CurrencyDiscountLabel.fromJson(item);
      case "especial_card":
        return SpecialCardDiscountLabel.fromJson(item);
      default:
        throw Exception("Unknown MenuCardDiscount type: $type");
    }
  }).toList();
}

@JsonSerializable()
class MenuCardTitle {
  final String title;

  MenuCardTitle({required this.title});

  factory MenuCardTitle.fromJson(Map<String, dynamic> json) =>
      _$MenuCardTitleFromJson(json);
}

@JsonSerializable()
class MenuCardClassification {
  final num max;
  final num min;
  final num current;

  MenuCardClassification(
      {required this.max, required this.min, required this.current});

  factory MenuCardClassification.fromJson(Map<String, dynamic> json) =>
      _$MenuCardClassificationFromJson(json);
}

@JsonSerializable()
class MenuCardHeader {
  final ITimeRange timeRange;
  final MenuCardPrice price;

  MenuCardHeader({required this.timeRange, required this.price});

  factory MenuCardHeader.fromJson(Map<String, dynamic> json) =>
      _$MenuCardHeaderFromJson(json);
}

@JsonSerializable()
class MenuCardData {
  final String id;
  final MenuCardHeader header;
  final MenuCardPrimaryImage primaryImage;
  final MenuCardTitle title;
  final MenuCardClassification? classification;

  factory MenuCardData.fromJson(Map<String, dynamic> json) =>
      _$MenuCardDataFromJson(json);

  MenuCardData({
    required this.id,
    required this.header,
    required this.primaryImage,
    required this.title,
    this.classification,
  });
}
*/