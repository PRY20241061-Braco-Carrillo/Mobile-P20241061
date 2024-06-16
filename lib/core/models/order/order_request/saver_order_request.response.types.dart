class SaveOrderRequestResponse {
  String orderRequestId;
  String confirmationToken;
  double? totalPrice;

  SaveOrderRequestResponse({
    required this.orderRequestId,
    required this.confirmationToken,
    required this.totalPrice,
  });

  factory SaveOrderRequestResponse.fromJson(Map<String, dynamic> json) =>
      SaveOrderRequestResponse(
        orderRequestId: json["orderRequestId"],
        confirmationToken: json["confirmationToken"],
        totalPrice:
            json["totalPrice"] == null ? null : json["totalPrice"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "orderRequestId": orderRequestId,
        "confirmationToken": confirmationToken,
        "totalPrice": totalPrice == null ? null : totalPrice,
      };
}
