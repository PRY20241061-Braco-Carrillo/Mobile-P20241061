import "../../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../../shared/widgets/features/category-button/category_button.types.dart";

class CategoryNavigationData {
  final CategoryButtonData categoryData;
  final CampusCardData campusData;

  CategoryNavigationData(
      {required this.categoryData, required this.campusData});
}
