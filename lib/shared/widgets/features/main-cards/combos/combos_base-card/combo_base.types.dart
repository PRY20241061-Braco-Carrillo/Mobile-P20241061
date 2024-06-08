class ComboByCampusCardData {
  String comboId;
  String name;
  int maxCookingTime;
  int minCookingTime;
  String unitOfTimeCookingTime;
  double amountPrice;
  String currencyPrice;
  String urlImage;
  int freeSauce;
  List<ProductByCampusCardData> products;

  ComboByCampusCardData({
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

  factory ComboByCampusCardData.fromJson(Map<String, dynamic> json) =>
      ComboByCampusCardData(
        comboId: json["comboId"],
        name: json["name"],
        maxCookingTime: json["maxCookingTime"],
        minCookingTime: json["minCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        urlImage: json["urlImage"],
        freeSauce: json["freeSauce"],
        products: List<ProductByCampusCardData>.from(
            json["products"].map((x) => ProductByCampusCardData.fromJson(x))),
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

class ProductByCampusCardData {
  String productId;
  String name;
  String description;
  String urlImage;
  int productAmount;

  ProductByCampusCardData({
    required this.productId,
    required this.name,
    required this.description,
    required this.urlImage,
    required this.productAmount,
  });

  factory ProductByCampusCardData.fromJson(Map<String, dynamic> json) =>
      ProductByCampusCardData(
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
