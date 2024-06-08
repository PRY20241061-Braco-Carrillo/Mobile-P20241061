import "../../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../../shared/widgets/features/category-button/category_button.types.dart";
import "../../../shared/widgets/features/main-cards/products/product_base-card/product_base.types.dart";

class ProductDetailNavigationData {
  final CategoryButtonData categoryData;
  final CampusCardData campusData;
  final ProductBaseCardData productData;

  ProductDetailNavigationData(
      {required this.categoryData,
      required this.campusData,
      required this.productData});
}
