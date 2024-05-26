import "../../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../../shared/widgets/features/product-card/products/product_base-card/product_base.types.dart";

class MenuDetailNavigationData {
  final CampusCardData campusData;
  final ProductBaseCardData productData;

  MenuDetailNavigationData(
      {required this.campusData, required this.productData});
}
