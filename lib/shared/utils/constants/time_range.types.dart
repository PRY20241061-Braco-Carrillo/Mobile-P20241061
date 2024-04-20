import "package:json_annotation/json_annotation.dart";
part "time_range.types.g.dart";

@JsonSerializable()
class ITimeRange {
  final num min;
  final num max;
  final String scale;

  ITimeRange({
    required this.min,
    required this.max,
    required this.scale,
  });

  factory ITimeRange.fromJson(Map<String, dynamic> json) =>
      _$ITimeRangeFromJson(json);
}
