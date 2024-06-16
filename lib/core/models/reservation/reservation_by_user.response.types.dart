class ReservationsResponseByUserId {
  String? reservationId;
  String? reservationStatus;
  DateTime? reservationDate;
  dynamic message;
  String? userQualification;
  String? orderRequestId;

  ReservationsResponseByUserId({
    this.reservationId,
    this.reservationStatus,
    this.reservationDate,
    this.message,
    this.userQualification,
    this.orderRequestId,
  });

  factory ReservationsResponseByUserId.fromJson(Map<String, dynamic> json) =>
      ReservationsResponseByUserId(
        reservationId: json["reservationId"],
        reservationStatus: json["reservationStatus"],
        reservationDate: json["reservationDate"] == null
            ? null
            : DateTime.parse(json["reservationDate"]),
        message: json["message"],
        userQualification: json["userQualification"],
        orderRequestId: json["orderRequestId"],
      );

  Map<String, dynamic> toJson() => {
        "reservationId": reservationId,
        "reservationStatus": reservationStatus,
        "reservationDate": reservationDate?.toIso8601String(),
        "message": message,
        "userQualification": userQualification,
        "orderRequestId": orderRequestId,
      };
}
