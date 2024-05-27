class ComboByCampusResponse {
  String comboId;
  String name;
  int maxCookingTime;
  int minCookingTime;
  String unitOfTimeCookingTime;
  double amountPrice;
  String currencyPrice;
  String urlImage;
  int freeSauce;
  List<ProductByCampusResponse> products;

  ComboByCampusResponse({
    required this.comboId,
    required this.name,
    required this.maxCookingTime,
    required this.minCookingTime,
    required this.unitOfTimeCookingTime,
    required this.amountPrice,
    required this.currencyPrice,
    required this.urlImage,
    required this.freeSauce,
    required this.products,
  });

  factory ComboByCampusResponse.fromJson(Map<String, dynamic> json) =>
      ComboByCampusResponse(
        comboId: json["comboId"],
        name: json["name"],
        maxCookingTime: json["maxCookingTime"],
        minCookingTime: json["minCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        urlImage: json["urlImage"],
        freeSauce: json["freeSauce"],
        products: List<ProductByCampusResponse>.from(
            json["products"].map((x) => ProductByCampusResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comboId": comboId,
        "name": name,
        "maxCookingTime": maxCookingTime,
        "minCookingTime": minCookingTime,
        "unitOfTimeCookingTime": unitOfTimeCookingTime,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "urlImage": urlImage,
        "freeSauce": freeSauce,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductByCampusResponse {
  String productId;
  String name;
  String description;
  String urlImage;
  int productAmount;

  ProductByCampusResponse({
    required this.productId,
    required this.name,
    required this.description,
    required this.urlImage,
    required this.productAmount,
  });

  factory ProductByCampusResponse.fromJson(Map<String, dynamic> json) =>
      ProductByCampusResponse(
        productId: json["productId"],
        name: json["name"],
        description: json["description"],
        urlImage: json["urlImage"],
        productAmount: json["productAmount"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "description": description,
        "urlImage": urlImage,
        "productAmount": productAmount,
      };
}
