class SaveOrderRequestResponse {
  String orderRequestId;
  String confirmationToken;
  dynamic totalPrice;

  SaveOrderRequestResponse({
    required this.orderRequestId,
    required this.confirmationToken,
    required this.totalPrice,
  });

  factory SaveOrderRequestResponse.fromJson(Map<String, dynamic> json) =>
      SaveOrderRequestResponse(
        orderRequestId: json["orderRequestId"],
        confirmationToken: json["confirmationToken"],
        totalPrice: json["totalPrice"],
      );

  Map<String, dynamic> toJson() => {
        "orderRequestId": orderRequestId,
        "confirmationToken": confirmationToken,
        "totalPrice": totalPrice,
      };
}
