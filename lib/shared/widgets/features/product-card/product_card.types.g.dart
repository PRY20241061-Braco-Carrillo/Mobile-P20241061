// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_card.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PercentDiscountLabel _$PercentDiscountLabelFromJson(
        Map<String, dynamic> json) =>
    PercentDiscountLabel(
      quantity: json['quantity'] as String,
    );

Map<String, dynamic> _$PercentDiscountLabelToJson(
        PercentDiscountLabel instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
    };

CurrencyDiscountLabel _$CurrencyDiscountLabelFromJson(
        Map<String, dynamic> json) =>
    CurrencyDiscountLabel(
      quantity: json['quantity'] as String,
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
    );

Map<String, dynamic> _$CurrencyDiscountLabelToJson(
        CurrencyDiscountLabel instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'currency': _$CurrencyEnumMap[instance.currency]!,
    };

const _$CurrencyEnumMap = {
  Currency.usd: 'usd',
  Currency.pen: 'pen',
  Currency.eur: 'eur',
};

SpecialCardDiscountLabel _$SpecialCardDiscountLabelFromJson(
        Map<String, dynamic> json) =>
    SpecialCardDiscountLabel(
      card: json['card'] as String,
      quantity: json['quantity'] as String,
    );

Map<String, dynamic> _$SpecialCardDiscountLabelToJson(
        SpecialCardDiscountLabel instance) =>
    <String, dynamic>{
      'card': instance.card,
      'quantity': instance.quantity,
    };

MenuCardSizeLabel _$MenuCardSizeLabelFromJson(Map<String, dynamic> json) =>
    MenuCardSizeLabel(
      size: json['size'] as String,
    );

Map<String, dynamic> _$MenuCardSizeLabelToJson(MenuCardSizeLabel instance) =>
    <String, dynamic>{
      'size': instance.size,
    };

MenuCardPrice _$MenuCardPriceFromJson(Map<String, dynamic> json) =>
    MenuCardPrice(
      price: json['price'] as String,
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
    );

Map<String, dynamic> _$MenuCardPriceToJson(MenuCardPrice instance) =>
    <String, dynamic>{
      'price': instance.price,
      'currency': _$CurrencyEnumMap[instance.currency]!,
    };

MenuCardPrimaryImage _$MenuCardPrimaryImageFromJson(
        Map<String, dynamic> json) =>
    MenuCardPrimaryImage(
      url: json['url'] as String,
      discountLabelDynamic: json['discountLabel'] as List<dynamic>?,
      sizeLabel: json['sizeLabel'] == null
          ? null
          : MenuCardSizeLabel.fromJson(
              json['sizeLabel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuCardPrimaryImageToJson(
        MenuCardPrimaryImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'discountLabel': instance.discountLabelDynamic,
      'sizeLabel': instance.sizeLabel,
    };

MenuCardTitle _$MenuCardTitleFromJson(Map<String, dynamic> json) =>
    MenuCardTitle(
      title: json['title'] as String,
    );

Map<String, dynamic> _$MenuCardTitleToJson(MenuCardTitle instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

MenuCardClassification _$MenuCardClassificationFromJson(
        Map<String, dynamic> json) =>
    MenuCardClassification(
      max: json['max'] as num,
      min: json['min'] as num,
      current: json['current'] as num,
    );

Map<String, dynamic> _$MenuCardClassificationToJson(
        MenuCardClassification instance) =>
    <String, dynamic>{
      'max': instance.max,
      'min': instance.min,
      'current': instance.current,
    };

MenuCardHeader _$MenuCardHeaderFromJson(Map<String, dynamic> json) =>
    MenuCardHeader(
      timeRange: ITimeRange.fromJson(json['timeRange'] as Map<String, dynamic>),
      price: MenuCardPrice.fromJson(json['price'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuCardHeaderToJson(MenuCardHeader instance) =>
    <String, dynamic>{
      'timeRange': instance.timeRange,
      'price': instance.price,
    };

MenuCardData _$MenuCardDataFromJson(Map<String, dynamic> json) => MenuCardData(
      id: json['id'] as String,
      header: MenuCardHeader.fromJson(json['header'] as Map<String, dynamic>),
      primaryImage: MenuCardPrimaryImage.fromJson(
          json['primaryImage'] as Map<String, dynamic>),
      title: MenuCardTitle.fromJson(json['title'] as Map<String, dynamic>),
      classification: MenuCardClassification.fromJson(
          json['classification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuCardDataToJson(MenuCardData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'header': instance.header,
      'primaryImage': instance.primaryImage,
      'title': instance.title,
      'classification': instance.classification,
    };
