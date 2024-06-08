import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_base-card/promotion_base.types.dart";

class PromotionDetailNavigationData {
  final CampusCardData campusData;
  final PromotionByCampusCardData productData;

  PromotionDetailNavigationData(
      {required this.campusData, required this.productData});
}
