class UpdateReservation {
  String? reservationId;
  String? status;

  UpdateReservation({
    this.reservationId,
    this.status,
  });

  factory UpdateReservation.fromJson(Map<String, dynamic> json) =>
      UpdateReservation(
        reservationId: json["reservationId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "reservationId": reservationId,
        "status": status,
      };
}
