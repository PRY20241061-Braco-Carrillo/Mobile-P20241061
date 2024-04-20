import "package:json_annotation/json_annotation.dart";

part "restaurant_dialog.types.g.dart";

enum ServiceTypes { delivery, takeAway, dineIn }

enum WeekDays { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

@JsonSerializable()
class ContactInfo {
  final String phone;
  final String mobile;
  final String whatsapp;
  final String? email;
  final String? website;
  final String? mobileCountryCode;
  final String? whatsappCountryCode;
  final String? phoneCountryCode;

  ContactInfo({
    required this.phone,
    required this.mobile,
    required this.whatsapp,
    this.email,
    this.website,
    this.mobileCountryCode,
    this.whatsappCountryCode,
    this.phoneCountryCode,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}

@JsonSerializable()
class Address {
  final String street;
  final String city;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.zipCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@JsonSerializable()
class ServiceType {
  final List<ServiceTypes> services;

  ServiceType({required this.services});

  factory ServiceType.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeFromJson(json);
}

@JsonSerializable()
class TimePeriod {
  final int hour;
  final int minute;
  final String period; // 'AM' o 'PM'

  TimePeriod({
    required this.hour,
    required this.minute,
    required this.period,
  });

  factory TimePeriod.fromJson(Map<String, dynamic> json) =>
      _$TimePeriodFromJson(json);
}

@JsonSerializable()
class TimeSlot {
  final TimePeriod open;
  final TimePeriod close;

  TimeSlot({
    required this.open,
    required this.close,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}

@JsonSerializable()
class DailySchedule {
  final List<TimeSlot> timeSlots;

  DailySchedule({
    required this.timeSlots,
  });

  factory DailySchedule.fromJson(Map<String, dynamic> json) =>
      _$DailyScheduleFromJson(json);
}

@JsonSerializable()
class RestaurantSchedule {
  final Map<WeekDays, DailySchedule> weekSchedule;

  RestaurantSchedule({
    required this.weekSchedule,
  });

  factory RestaurantSchedule.fromJson(Map<String, dynamic> json) =>
      _$RestaurantScheduleFromJson(json);
}

@JsonSerializable()
class RestaurantSocialMedia {
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? youtube;
  final String? whatsapp;

  RestaurantSocialMedia({
    this.facebook,
    this.instagram,
    this.twitter,
    this.youtube,
    this.whatsapp,
  });

  factory RestaurantSocialMedia.fromJson(Map<String, dynamic> json) =>
      _$RestaurantSocialMediaFromJson(json);
}

@JsonSerializable()
class RestaurantInfoData {
  final bool isAvailable;
  final bool isClosed;
  final String id;
  final String name;
  final Address address;
  final ServiceType serviceType;
  //final RestaurantSchedule schedule;
  final RestaurantSocialMedia socialMedia;
  final ContactInfo contact;

  RestaurantInfoData({
    required this.isAvailable,
    required this.isClosed,
    required this.id,
    required this.name,
    required this.address,
    required this.serviceType,
    //required this.schedule,
    required this.socialMedia,
    required this.contact,
  });

  factory RestaurantInfoData.fromJson(Map<String, dynamic> json) =>
      _$RestaurantInfoDataFromJson(json);
}
