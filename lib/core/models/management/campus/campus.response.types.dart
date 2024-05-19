import "package:json_annotation/json_annotation.dart";

part "campus.response.types.g.dart";

@JsonSerializable()
class CampusResponse {
  String campusId;
  String name;
  String address;
  String phoneNumber;
  OpenHour openHour;
  bool toTakeHome;
  bool toDelivery;
  Restaurant restaurant;
  String regexTableCode;
  String urlImage;
  bool isAvailable;

  CampusResponse({
    required this.campusId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.openHour,
    required this.toTakeHome,
    required this.toDelivery,
    required this.restaurant,
    required this.regexTableCode,
    required this.urlImage,
    required this.isAvailable,
  });

  factory CampusResponse.fromJson(Map<String, dynamic> json) {
    return _$CampusResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CampusResponseToJson(this);
}

class Restaurant {
  String restaurantId;
  String name;
  String logoUrl;
  bool isAvailable;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.logoUrl,
    required this.isAvailable,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        restaurantId: json["restaurantId"],
        name: json["name"],
        logoUrl: json["logoUrl"],
        isAvailable: json["isAvailable"],
      );

  Map<String, dynamic> toJson() => {
        "restaurantId": restaurantId,
        "name": name,
        "logoUrl": logoUrl,
        "isAvailable": isAvailable,
      };
}

class OpenHour {
  Day? monday;

  Day? tuesday;

  Day? wednesday;

  Day? thursday;

  Day? friday;

  Day? saturday;

  Day? sunday;

  OpenHour({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory OpenHour.fromJson(Map<String, dynamic> json) {
    return OpenHour(
      monday: json["Monday"] == null ? null : Day.fromJson(json["Monday"]),
      tuesday: json["Tuesday"] == null ? null : Day.fromJson(json["Tuesday"]),
      wednesday:
          json["Wednesday"] == null ? null : Day.fromJson(json["Wednesday"]),
      thursday:
          json["Thursday"] == null ? null : Day.fromJson(json["Thursday"]),
      friday: json["Friday"] == null ? null : Day.fromJson(json["Friday"]),
      saturday:
          json["Saturday"] == null ? null : Day.fromJson(json["Saturday"]),
      sunday: json["Sunday"] == null ? null : Day.fromJson(json["Sunday"]),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "Monday": monday?.toJson(),
        "Tuesday": tuesday?.toJson(),
        "Wednesday": wednesday?.toJson(),
        "Thursday": thursday?.toJson(),
        "Friday": friday?.toJson(),
        "Saturday": saturday?.toJson(),
        "Sunday": sunday?.toJson(),
      };
}

class Day {
  Breakfast? breakfast;

  Breakfast? lunch;

  Breakfast? dinner;

  Day({
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      breakfast: json["breakfast"] == null
          ? null
          : Breakfast.fromJson(json["breakfast"]),
      lunch: json["lunch"] == null ? null : Breakfast.fromJson(json["lunch"]),
      dinner:
          json["dinner"] == null ? null : Breakfast.fromJson(json["dinner"]),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "breakfast": breakfast?.toJson(),
        "lunch": lunch?.toJson(),
        "dinner": dinner?.toJson(),
      };
}

class Breakfast {
  String opening;

  String closing;

  Breakfast({
    required this.opening,
    required this.closing,
  });

  factory Breakfast.fromJson(Map<String, dynamic> json) {
    return Breakfast(
      opening: json["opening"],
      closing: json["closing"],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "opening": opening,
        "closing": closing,
      };
}

@JsonSerializable()
class ListCampusResponse {
  final List<CampusResponse> campus;

  ListCampusResponse({required this.campus});

  factory ListCampusResponse.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          "The JSON argument must be of type Map<String, dynamic>");
    }
    return _$ListCampusResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ListCampusResponseToJson(this);
}
