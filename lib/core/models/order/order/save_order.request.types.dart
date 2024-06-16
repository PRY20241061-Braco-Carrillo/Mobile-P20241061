class SaveOrderRequest {
  String? tableNumber;
  bool forTable;
  String userId;
  String orderRequestId;
  String campusId;
  OrderRequest orderRequest;

  SaveOrderRequest({
    required this.tableNumber,
    required this.forTable,
    required this.userId,
    required this.orderRequestId,
    required this.campusId,
    required this.orderRequest,
  });

  factory SaveOrderRequest.fromJson(Map<String, dynamic> json) =>
      SaveOrderRequest(
        tableNumber: json["tableNumber"],
        forTable: json["forTable"],
        userId: json["userId"],
        orderRequestId: json["orderRequestId"],
        campusId: json["campusId"],
        orderRequest: OrderRequest.fromJson(json["orderRequest"]),
      );

  Map<String, dynamic> toJson() => {
        "tableNumber": tableNumber,
        "forTable": forTable,
        "userId": userId,
        "orderRequestId": orderRequestId,
        "campusId": campusId,
        "orderRequest": orderRequest.toJson(),
      };
}

class OrderRequest {
  List<OrderRequestProduct> products;
  List<OrderRequestComplement> complements;
  List<ComboCombo> combos;
  List<ComboPromotion> comboPromotions;
  List<ProductPromotion> productPromotions;
  List<Menu> menus;

  OrderRequest({
    required this.products,
    required this.complements,
    required this.combos,
    required this.comboPromotions,
    required this.productPromotions,
    required this.menus,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        products: json["products"] == null
            ? []
            : List<OrderRequestProduct>.from(
                json["products"].map((x) => OrderRequestProduct.fromJson(x))),
        complements: json["complements"] == null
            ? []
            : List<OrderRequestComplement>.from(json["complements"]
                .map((x) => OrderRequestComplement.fromJson(x))),
        combos: json["combos"] == null
            ? []
            : List<ComboCombo>.from(
                json["combos"].map((x) => ComboCombo.fromJson(x))),
        comboPromotions: json["comboPromotions"] == null
            ? []
            : List<ComboPromotion>.from(
                json["comboPromotions"].map((x) => ComboPromotion.fromJson(x))),
        productPromotions: json["productPromotions"] == null
            ? []
            : List<ProductPromotion>.from(json["productPromotions"]
                .map((x) => ProductPromotion.fromJson(x))),
        menus: json["menus"] == null
            ? []
            : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "complements": List<dynamic>.from(complements.map((x) => x.toJson())),
        "combos": List<dynamic>.from(combos.map((x) => x.toJson())),
        "comboPromotions":
            List<dynamic>.from(comboPromotions.map((x) => x.toJson())),
        "productPromotions":
            List<dynamic>.from(productPromotions.map((x) => x.toJson())),
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
      };
}

class ComboPromotion {
  String promotionId;
  int promotionAmount;
  int unitPrice;
  List<ComboPromotionCombo> combos;

  ComboPromotion({
    required this.promotionId,
    required this.promotionAmount,
    required this.unitPrice,
    required this.combos,
  });

  factory ComboPromotion.fromJson(Map<String, dynamic> json) => ComboPromotion(
        promotionId: json["promotionId"],
        promotionAmount: json["promotionAmount"],
        unitPrice: json["unitPrice"],
        combos: json["combos"] == null
            ? []
            : List<ComboPromotionCombo>.from(
                json["combos"].map((x) => ComboPromotionCombo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "promotionAmount": promotionAmount,
        "unitPrice": unitPrice,
        "combos": List<dynamic>.from(combos.map((x) => x.toJson())),
      };
}

class ComboPromotionCombo {
  ComboCombo combo;

  ComboPromotionCombo({
    required this.combo,
  });

  factory ComboPromotionCombo.fromJson(Map<String, dynamic> json) =>
      ComboPromotionCombo(
        combo: ComboCombo.fromJson(json["combo"]),
      );

  Map<String, dynamic> toJson() => {
        "combo": combo.toJson(),
      };
}

class ComboCombo {
  String comboId;
  int comboAmount;
  double unitPrice;
  List<ComboProduct> products;
  List<ComboComplement> complements;

  ComboCombo({
    required this.comboId,
    required this.comboAmount,
    required this.unitPrice,
    required this.products,
    required this.complements,
  });

  factory ComboCombo.fromJson(Map<String, dynamic> json) => ComboCombo(
        comboId: json["comboId"],
        comboAmount: json["comboAmount"],
        unitPrice: json["unitPrice"]?.toDouble(),
        products: json["products"] == null
            ? []
            : List<ComboProduct>.from(
                json["products"].map((x) => ComboProduct.fromJson(x))),
        complements: json["complements"] == null
            ? []
            : List<ComboComplement>.from(
                json["complements"].map((x) => ComboComplement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comboId": comboId,
        "comboAmount": comboAmount,
        "unitPrice": unitPrice,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "complements": List<dynamic>.from(complements.map((x) => x.toJson())),
      };
}

// Define other classes similarly to handle empty lists as in ComboCombo

class ComboComplement {
  String comboComplementId;
  int complementAmount;

  ComboComplement({
    required this.comboComplementId,
    required this.complementAmount,
  });

  factory ComboComplement.fromJson(Map<String, dynamic> json) =>
      ComboComplement(
        comboComplementId: json["comboComplementId"],
        complementAmount: json["complementAmount"],
      );

  Map<String, dynamic> toJson() => {
        "comboComplementId": comboComplementId,
        "complementAmount": complementAmount,
      };
}

class ComboProduct {
  String productVariantId;
  int productAmount;

  ComboProduct({
    required this.productVariantId,
    required this.productAmount,
  });

  factory ComboProduct.fromJson(Map<String, dynamic> json) => ComboProduct(
        productVariantId: json["productVariantId"],
        productAmount: json["productAmount"],
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "productAmount": productAmount,
      };
}

class OrderRequestComplement {
  String complementId;
  int complementAmount;
  int unitPrice;

  OrderRequestComplement({
    required this.complementId,
    required this.complementAmount,
    required this.unitPrice,
  });

  factory OrderRequestComplement.fromJson(Map<String, dynamic> json) =>
      OrderRequestComplement(
        complementId: json["complementId"],
        complementAmount: json["complementAmount"],
        unitPrice: json["unitPrice"],
      );

  Map<String, dynamic> toJson() => {
        "complementId": complementId,
        "complementAmount": complementAmount,
        "unitPrice": unitPrice,
      };
}

class Menu {
  String menuId;
  int menuAmount;
  int unitPrice;
  List<MenuProduct> products;

  Menu({
    required this.menuId,
    required this.menuAmount,
    required this.unitPrice,
    required this.products,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuId: json["menuId"],
        menuAmount: json["menuAmount"],
        unitPrice: json["unitPrice"],
        products: json["products"] == null
            ? []
            : List<MenuProduct>.from(
                json["products"].map((x) => MenuProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menuId": menuId,
        "menuAmount": menuAmount,
        "unitPrice": unitPrice,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class MenuProduct {
  String productVariantId;

  MenuProduct({
    required this.productVariantId,
  });

  factory MenuProduct.fromJson(Map<String, dynamic> json) => MenuProduct(
        productVariantId: json["productVariantId"],
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
      };
}

class ProductPromotion {
  String promotionId;
  int promotionAmount;
  int unitPrice;
  List<ProductPromotionComplement> complements;
  List<MenuProduct> products;

  ProductPromotion({
    required this.promotionId,
    required this.promotionAmount,
    required this.unitPrice,
    required this.complements,
    required this.products,
  });

  factory ProductPromotion.fromJson(Map<String, dynamic> json) =>
      ProductPromotion(
        promotionId: json["promotionId"],
        promotionAmount: json["promotionAmount"],
        unitPrice: json["unitPrice"],
        complements: json["complements"] == null
            ? []
            : List<ProductPromotionComplement>.from(json["complements"]
                .map((x) => ProductPromotionComplement.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<MenuProduct>.from(
                json["products"].map((x) => MenuProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "promotionAmount": promotionAmount,
        "unitPrice": unitPrice,
        "complements": List<dynamic>.from(complements.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductPromotionComplement {
  String complementPromotionId;
  int complementAmount;

  ProductPromotionComplement({
    required this.complementPromotionId,
    required this.complementAmount,
  });

  factory ProductPromotionComplement.fromJson(Map<String, dynamic> json) =>
      ProductPromotionComplement(
        complementPromotionId: json["complementPromotionId"],
        complementAmount: json["complementAmount"],
      );

  Map<String, dynamic> toJson() => {
        "complementPromotionId": complementPromotionId,
        "complementAmount": complementAmount,
      };
}

class OrderRequestProduct {
  String productVariantId;
  int productAmount;
  double unitPrice;

  OrderRequestProduct({
    required this.productVariantId,
    required this.productAmount,
    required this.unitPrice,
  });

  factory OrderRequestProduct.fromJson(Map<String, dynamic> json) =>
      OrderRequestProduct(
        productVariantId: json["productVariantId"],
        productAmount: json["productAmount"],
        unitPrice: json["unitPrice"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "productAmount": productAmount,
        "unitPrice": unitPrice,
      };
}
