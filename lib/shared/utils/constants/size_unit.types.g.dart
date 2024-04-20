// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_unit.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ISizeByPieces _$ISizeByPiecesFromJson(Map<String, dynamic> json) =>
    ISizeByPieces(
      portion: json['portion'] as int,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ISizeByPiecesToJson(ISizeByPieces instance) =>
    <String, dynamic>{
      'portion': instance.portion,
      'description': instance.description,
    };

ISizeByWeight _$ISizeByWeightFromJson(Map<String, dynamic> json) =>
    ISizeByWeight(
      weight: json['weight'] as int,
      unit: $enumDecode(_$WeightUnitEnumMap, json['unit']),
    );

Map<String, dynamic> _$ISizeByWeightToJson(ISizeByWeight instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'unit': _$WeightUnitEnumMap[instance.unit]!,
    };

const _$WeightUnitEnumMap = {
  WeightUnit.kg: 'kg',
  WeightUnit.g: 'g',
};

ISizeByVolume _$ISizeByVolumeFromJson(Map<String, dynamic> json) =>
    ISizeByVolume(
      volume: json['volume'] as int,
      unit: $enumDecode(_$VolumeUnitEnumMap, json['unit']),
    );

Map<String, dynamic> _$ISizeByVolumeToJson(ISizeByVolume instance) =>
    <String, dynamic>{
      'volume': instance.volume,
      'unit': _$VolumeUnitEnumMap[instance.unit]!,
    };

const _$VolumeUnitEnumMap = {
  VolumeUnit.l: 'l',
  VolumeUnit.ml: 'ml',
  VolumeUnit.cm3: 'cm3',
  VolumeUnit.in3: 'in3',
};

ISizeByDescription _$ISizeByDescriptionFromJson(Map<String, dynamic> json) =>
    ISizeByDescription(
      description: $enumDecode(_$SizeDescriptionEnumMap, json['description']),
    );

Map<String, dynamic> _$ISizeByDescriptionToJson(ISizeByDescription instance) =>
    <String, dynamic>{
      'description': _$SizeDescriptionEnumMap[instance.description]!,
    };

const _$SizeDescriptionEnumMap = {
  SizeDescription.small: 'small',
  SizeDescription.medium: 'medium',
  SizeDescription.large: 'large',
};
