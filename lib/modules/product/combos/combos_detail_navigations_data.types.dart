import "../../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../../shared/widgets/features/product-card/combos/combos_base-card/combo_base.types.dart";

class ComboDetailNavigationData {
  final CampusCardData campusData;
  final ComboByCampusCardData productData;

  ComboDetailNavigationData(
      {required this.campusData, required this.productData});
}
