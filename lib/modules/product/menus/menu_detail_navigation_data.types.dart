import "../../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../../shared/widgets/features/main-cards/menus/menu_base-card/menu_base.types.dart";

class MenuDetailNavigationData {
  final CampusCardData campusData;
  final MenuBaseCardData productData;

  MenuDetailNavigationData(
      {required this.campusData, required this.productData});
}
