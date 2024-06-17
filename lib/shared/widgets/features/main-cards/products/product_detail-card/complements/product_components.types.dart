class ProductComplement {
  String? complementId;
  String? name;
  int? freeAmount;
  double? amountPrice;
  String? currencyPrice;
  bool? isSauce;

  ProductComplement({
    this.complementId,
    this.name,
    this.freeAmount,
    this.amountPrice,
    this.currencyPrice,
    this.isSauce,
  });

  factory ProductComplement.fromJson(Map<String, dynamic> json) =>
      ProductComplement(
        complementId: json["complementId"],
        name: json["name"],
        freeAmount: json["freeAmount"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        isSauce: json["isSauce"],
      );

  Map<String, dynamic> toJson() => {
        "complementId": complementId,
        "name": name,
        "freeAmount": freeAmount,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "isSauce": isSauce,
      };
}
