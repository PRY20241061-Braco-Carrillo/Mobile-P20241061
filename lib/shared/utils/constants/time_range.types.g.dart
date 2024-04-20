// GENERATED CODE - DO NOT MODIFY BY HAND

part of "time_range.types.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ITimeRange _$ITimeRangeFromJson(Map<String, dynamic> json) => ITimeRange(
      min: json["min"] as num,
      max: json["max"] as num,
      scale: json["scale"] as String,
    );

Map<String, dynamic> _$ITimeRangeToJson(ITimeRange instance) =>
    <String, dynamic>{
      "min": instance.min,
      "max": instance.max,
      "scale": instance.scale,
    };
