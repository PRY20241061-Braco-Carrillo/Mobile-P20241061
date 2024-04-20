// GENERATED CODE - DO NOT MODIFY BY HAND

part of "restaurant_dialog.types.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      phone: json["phone"] as String,
      mobile: json["mobile"] as String,
      whatsapp: json["whatsapp"] as String,
      email: json["email"] as String?,
      website: json["website"] as String?,
      mobileCountryCode: json["mobileCountryCode"] as String?,
      whatsappCountryCode: json["whatsappCountryCode"] as String?,
      phoneCountryCode: json["phoneCountryCode"] as String?,
    );

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      "phone": instance.phone,
      "mobile": instance.mobile,
      "whatsapp": instance.whatsapp,
      "email": instance.email,
      "website": instance.website,
      "mobileCountryCode": instance.mobileCountryCode,
      "whatsappCountryCode": instance.whatsappCountryCode,
      "phoneCountryCode": instance.phoneCountryCode,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      street: json["street"] as String,
      city: json["city"] as String,
      zipCode: json["zipCode"] as String,
      country: json["country"] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      "street": instance.street,
      "city": instance.city,
      "zipCode": instance.zipCode,
      "country": instance.country,
    };

ServiceType _$ServiceTypeFromJson(Map<String, dynamic> json) => ServiceType(
      services: (json["services"] as List<dynamic>)
          .map((e) => $enumDecode(_$ServiceTypesEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$ServiceTypeToJson(ServiceType instance) =>
    <String, dynamic>{
      "services":
          instance.services.map((ServiceTypes e) => _$ServiceTypesEnumMap[e]!).toList(),
    };

const Map<ServiceTypes, String> _$ServiceTypesEnumMap = <ServiceTypes, String>{
  ServiceTypes.delivery: "delivery",
  ServiceTypes.takeAway: "takeAway",
  ServiceTypes.dineIn: "dineIn",
};

TimePeriod _$TimePeriodFromJson(Map<String, dynamic> json) => TimePeriod(
      hour: json["hour"] as int,
      minute: json["minute"] as int,
      period: json["period"] as String,
    );

Map<String, dynamic> _$TimePeriodToJson(TimePeriod instance) =>
    <String, dynamic>{
      "hour": instance.hour,
      "minute": instance.minute,
      "period": instance.period,
    };

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      open: TimePeriod.fromJson(json["open"] as Map<String, dynamic>),
      close: TimePeriod.fromJson(json["close"] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      "open": instance.open,
      "close": instance.close,
    };

DailySchedule _$DailyScheduleFromJson(Map<String, dynamic> json) =>
    DailySchedule(
      timeSlots: (json["timeSlots"] as List<dynamic>)
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyScheduleToJson(DailySchedule instance) =>
    <String, dynamic>{
      "timeSlots": instance.timeSlots,
    };

RestaurantSchedule _$RestaurantScheduleFromJson(Map<String, dynamic> json) =>
    RestaurantSchedule(
      weekSchedule: (json["weekSchedule"] as Map<String, dynamic>).map(
        (String k, e) => MapEntry($enumDecode(_$WeekDaysEnumMap, k),
            DailySchedule.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$RestaurantScheduleToJson(RestaurantSchedule instance) =>
    <String, dynamic>{
      "weekSchedule": instance.weekSchedule
          .map((WeekDays k, DailySchedule e) => MapEntry(_$WeekDaysEnumMap[k]!, e)),
    };

const Map<WeekDays, String> _$WeekDaysEnumMap = <WeekDays, String>{
  WeekDays.sunday: "sunday",
  WeekDays.monday: "monday",
  WeekDays.tuesday: "tuesday",
  WeekDays.wednesday: "wednesday",
  WeekDays.thursday: "thursday",
  WeekDays.friday: "friday",
  WeekDays.saturday: "saturday",
};

RestaurantSocialMedia _$RestaurantSocialMediaFromJson(
        Map<String, dynamic> json) =>
    RestaurantSocialMedia(
      facebook: json["facebook"] as String?,
      instagram: json["instagram"] as String?,
      twitter: json["twitter"] as String?,
      youtube: json["youtube"] as String?,
      whatsapp: json["whatsapp"] as String?,
    );

Map<String, dynamic> _$RestaurantSocialMediaToJson(
        RestaurantSocialMedia instance) =>
    <String, dynamic>{
      "facebook": instance.facebook,
      "instagram": instance.instagram,
      "twitter": instance.twitter,
      "youtube": instance.youtube,
      "whatsapp": instance.whatsapp,
    };

RestaurantInfoData _$RestaurantInfoDataFromJson(Map<String, dynamic> json) =>
    RestaurantInfoData(
      isAvailable: json["isAvailable"] as bool,
      isClosed: json["isClosed"] as bool,
      id: json["id"] as String,
      name: json["name"] as String,
      address: Address.fromJson(json["address"] as Map<String, dynamic>),
      serviceType:
          ServiceType.fromJson(json["serviceType"] as Map<String, dynamic>),
      socialMedia: RestaurantSocialMedia.fromJson(
          json["socialMedia"] as Map<String, dynamic>),
      contact: ContactInfo.fromJson(json["contact"] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RestaurantInfoDataToJson(RestaurantInfoData instance) =>
    <String, dynamic>{
      "isAvailable": instance.isAvailable,
      "isClosed": instance.isClosed,
      "id": instance.id,
      "name": instance.name,
      "address": instance.address,
      "serviceType": instance.serviceType,
      "socialMedia": instance.socialMedia,
      "contact": instance.contact,
    };
