class SaveReservationRequest {
  String? userId;
  String? campusId;
  Order? order;

  SaveReservationRequest({
    this.userId,
    this.campusId,
    this.order,
  });

  factory SaveReservationRequest.fromJson(Map<String, dynamic> json) =>
      SaveReservationRequest(
        userId: json["userId"],
        campusId: json["campusId"],
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "campusId": campusId,
        "order": order?.toJson(),
      };
}

class Order {
  List<OrderProduct>? products;
  List<OrderComplement>? complements;
  List<ComboCombo>? combos;
  List<ComboPromotion>? comboPromotions;
  List<ProductPromotion>? productPromotions;
  List<Menu>? menus;

  Order({
    this.products,
    this.complements,
    this.combos,
    this.comboPromotions,
    this.productPromotions,
    this.menus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        products: json["products"] == null
            ? []
            : List<OrderProduct>.from(
                json["products"]!.map((x) => OrderProduct.fromJson(x))),
        complements: json["complements"] == null
            ? []
            : List<OrderComplement>.from(
                json["complements"]!.map((x) => OrderComplement.fromJson(x))),
        combos: json["combos"] == null
            ? []
            : List<ComboCombo>.from(
                json["combos"]!.map((x) => ComboCombo.fromJson(x))),
        comboPromotions: json["comboPromotions"] == null
            ? []
            : List<ComboPromotion>.from(json["comboPromotions"]!
                .map((x) => ComboPromotion.fromJson(x))),
        productPromotions: json["productPromotions"] == null
            ? []
            : List<ProductPromotion>.from(json["productPromotions"]!
                .map((x) => ProductPromotion.fromJson(x))),
        menus: json["menus"] == null
            ? []
            : List<Menu>.from(json["menus"]!.map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "complements": complements == null
            ? []
            : List<dynamic>.from(complements!.map((x) => x.toJson())),
        "combos": combos == null
            ? []
            : List<dynamic>.from(combos!.map((x) => x.toJson())),
        "comboPromotions": comboPromotions == null
            ? []
            : List<dynamic>.from(comboPromotions!.map((x) => x.toJson())),
        "productPromotions": productPromotions == null
            ? []
            : List<dynamic>.from(productPromotions!.map((x) => x.toJson())),
        "menus": menus == null
            ? []
            : List<dynamic>.from(menus!.map((x) => x.toJson())),
      };
}

class ComboPromotion {
  String? promotionId;
  int? promotionAmount;
  int? unitPrice;
  List<ComboPromotionCombo>? combos;

  ComboPromotion({
    this.promotionId,
    this.promotionAmount,
    this.unitPrice,
    this.combos,
  });

  factory ComboPromotion.fromJson(Map<String, dynamic> json) => ComboPromotion(
        promotionId: json["promotionId"],
        promotionAmount: json["promotionAmount"],
        unitPrice: json["unitPrice"],
        combos: json["combos"] == null
            ? []
            : List<ComboPromotionCombo>.from(
                json["combos"]!.map((x) => ComboPromotionCombo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "promotionAmount": promotionAmount,
        "unitPrice": unitPrice,
        "combos": combos == null
            ? []
            : List<dynamic>.from(combos!.map((x) => x.toJson())),
      };
}

class ComboPromotionCombo {
  ComboCombo? combo;

  ComboPromotionCombo({
    this.combo,
  });

  factory ComboPromotionCombo.fromJson(Map<String, dynamic> json) =>
      ComboPromotionCombo(
        combo:
            json["combo"] == null ? null : ComboCombo.fromJson(json["combo"]),
      );

  Map<String, dynamic> toJson() => {
        "combo": combo?.toJson(),
      };
}

class ComboCombo {
  String? comboId;
  int? comboAmount;
  double? unitPrice;
  List<ComboProduct>? products;
  List<ComboComplement>? complements;

  ComboCombo({
    this.comboId,
    this.comboAmount,
    this.unitPrice,
    this.products,
    this.complements,
  });

  factory ComboCombo.fromJson(Map<String, dynamic> json) => ComboCombo(
        comboId: json["comboId"],
        comboAmount: json["comboAmount"],
        unitPrice: json["unitPrice"]?.toDouble(),
        products: json["products"] == null
            ? []
            : List<ComboProduct>.from(
                json["products"]!.map((x) => ComboProduct.fromJson(x))),
        complements: json["complements"] == null
            ? []
            : List<ComboComplement>.from(
                json["complements"]!.map((x) => ComboComplement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comboId": comboId,
        "comboAmount": comboAmount,
        "unitPrice": unitPrice,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "complements": complements == null
            ? []
            : List<dynamic>.from(complements!.map((x) => x.toJson())),
      };
}

class ComboComplement {
  String? comboComplementId;
  int? complementAmount;

  ComboComplement({
    this.comboComplementId,
    this.complementAmount,
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
  String? productVariantId;
  int? productAmount;

  ComboProduct({
    this.productVariantId,
    this.productAmount,
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

class OrderComplement {
  String? complementId;
  int? complementAmount;
  int? unitPrice;

  OrderComplement({
    this.complementId,
    this.complementAmount,
    this.unitPrice,
  });

  factory OrderComplement.fromJson(Map<String, dynamic> json) =>
      OrderComplement(
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
  String? menuId;
  int? menuAmount;
  int? unitPrice;
  List<MenuProduct>? products;

  Menu({
    this.menuId,
    this.menuAmount,
    this.unitPrice,
    this.products,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuId: json["menuId"],
        menuAmount: json["menuAmount"],
        unitPrice: json["unitPrice"],
        products: json["products"] == null
            ? []
            : List<MenuProduct>.from(
                json["products"]!.map((x) => MenuProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menuId": menuId,
        "menuAmount": menuAmount,
        "unitPrice": unitPrice,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class MenuProduct {
  String? productVariantId;

  MenuProduct({
    this.productVariantId,
  });

  factory MenuProduct.fromJson(Map<String, dynamic> json) => MenuProduct(
        productVariantId: json["productVariantId"],
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
      };
}

class ProductPromotion {
  String? promotionId;
  int? promotionAmount;
  int? unitPrice;
  List<ProductPromotionComplement>? complements;
  List<MenuProduct>? products;

  ProductPromotion({
    this.promotionId,
    this.promotionAmount,
    this.unitPrice,
    this.complements,
    this.products,
  });

  factory ProductPromotion.fromJson(Map<String, dynamic> json) =>
      ProductPromotion(
        promotionId: json["promotionId"],
        promotionAmount: json["promotionAmount"],
        unitPrice: json["unitPrice"],
        complements: json["complements"] == null
            ? []
            : List<ProductPromotionComplement>.from(json["complements"]!
                .map((x) => ProductPromotionComplement.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<MenuProduct>.from(
                json["products"]!.map((x) => MenuProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "promotionAmount": promotionAmount,
        "unitPrice": unitPrice,
        "complements": complements == null
            ? []
            : List<dynamic>.from(complements!.map((x) => x.toJson())),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class ProductPromotionComplement {
  String? complementPromotionId;
  int? complementAmount;

  ProductPromotionComplement({
    this.complementPromotionId,
    this.complementAmount,
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

class OrderProduct {
  String? productVariantId;
  int? productAmount;
  double? unitPrice;

  OrderProduct({
    this.productVariantId,
    this.productAmount,
    this.unitPrice,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
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
