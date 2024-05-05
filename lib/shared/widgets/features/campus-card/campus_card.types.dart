import "package:json_annotation/json_annotation.dart";

import "../../../../core/models/management/campus/campus.response.types.dart";

part "campus_card.types.g.dart";

@JsonSerializable()
class CampusCardData {
  String campusId;
  String name;
  String address;
  String phoneNumber;
  OpenHour openHour;
  bool toTakeHome;
  bool toDelivery;
  String restaurantId;
  bool isAvailable;
  String logoUrl;
  String imageUrl;

  CampusCardData({
    required this.campusId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.openHour,
    required this.toTakeHome,
    required this.toDelivery,
    required this.restaurantId,
    required this.isAvailable,
    required this.logoUrl,
    required this.imageUrl,
  });

  factory CampusCardData.fromJson(Map<String, dynamic> json) => CampusCardData(
        campusId: json["campusId"],
        name: json["name"],
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        openHour: OpenHour.fromJson(json["openHour"]),
        toTakeHome: json["toTakeHome"],
        toDelivery: json["toDelivery"],
        restaurantId: json["restaurantId"],
        isAvailable: json["isAvailable"],
        logoUrl: json["logoUrl"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "campusId": campusId,
        "name": name,
        "address": address,
        "phoneNumber": phoneNumber,
        "openHour": openHour.toJson(),
        "toTakeHome": toTakeHome,
        "toDelivery": toDelivery,
        "restaurantId": restaurantId,
        "isAvailable": isAvailable,
        "logoUrl": logoUrl,
        "imageUrl": imageUrl,
      };
}
