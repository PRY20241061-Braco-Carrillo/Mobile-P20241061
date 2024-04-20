import "package:json_annotation/json_annotation.dart";
part "size_unit.types.g.dart";

enum SizeUnitType {
  pieces,
  weight,
  volume,
  description,
}

enum WeightUnit { kg, g }

enum VolumeUnit { l, ml, cm3, in3 }

enum SizeDescription { small, medium, large }

@JsonSerializable()
class ISizeByPieces {
  final SizeUnitType type = SizeUnitType.pieces;
  final int portion;
  final String description;

  ISizeByPieces({required this.portion, required this.description});

  factory ISizeByPieces.fromJson(Map<String, dynamic> json) =>
      _$ISizeByPiecesFromJson(json);
}

@JsonSerializable()
class ISizeByWeight {
  final SizeUnitType type = SizeUnitType.weight;
  final int weight;
  final WeightUnit unit;

  ISizeByWeight({required this.weight, required this.unit});

  factory ISizeByWeight.fromJson(Map<String, dynamic> json) =>
      _$ISizeByWeightFromJson(json);
}

@JsonSerializable()
class ISizeByVolume {
  final SizeUnitType type = SizeUnitType.volume;
  final int volume;
  final VolumeUnit unit;

  ISizeByVolume({required this.volume, required this.unit});

  factory ISizeByVolume.fromJson(Map<String, dynamic> json) =>
      _$ISizeByVolumeFromJson(json);
}

@JsonSerializable()
class ISizeByDescription {
  final SizeUnitType type = SizeUnitType.description;
  final SizeDescription description;

  ISizeByDescription({required this.description});

  factory ISizeByDescription.fromJson(Map<String, dynamic> json) =>
      _$ISizeByDescriptionFromJson(json);
}
