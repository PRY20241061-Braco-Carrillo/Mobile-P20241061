import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "category_button.types.dart";
import "package:flutter_svg/flutter_svg.dart";

class CCategoryButton extends ICategoryButton {
  const CCategoryButton({
    super.key,
    required super.labelKey,
    super.disabled,
    super.icon = "assets/icons/empty.svg", //TODO: Agregar un icono empty
    required super.actionType,
    super.path,
    required super.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : () => _handleTap(context),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                icon,
                width: 100,
                height: 100,
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(labelKey).tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    // Acciones cuando se toca la tarjeta, por ejemplo, navegación.
  }
}

final List<CCategoryButton> categoryButtons = <CCategoryButton>[
  const CCategoryButton(
    labelKey: "Category.categories.SNACK.label",
    icon: "assets/icons/snack-category.svg",
    actionType: ActionType.custom,
    id: "snack_button",
  ),
  const CCategoryButton(
    labelKey: "Category.categories.DRINK.label",
    icon: "assets/icons/drinks-category.svg",
    actionType: ActionType.custom,
    id: "drink_button",
  ),
  const CCategoryButton(
    labelKey: "Category.categories.DESSERT.label",
    icon: "assets/icons/dessert-category.svg",
    actionType: ActionType.custom,
    id: "dessert_button",
  ),
  const CCategoryButton(
    labelKey: "Category.categories.ENTRY.label",
    icon: "assets/icons/entry-category.svg",
    actionType: ActionType.custom,
    id: "entry_button",
  ),
  const CCategoryButton(
    labelKey: "Category.categories.KIDS.label",
    icon: "assets/icons/kids-category.svg",
    actionType: ActionType.custom,
    id: "kids_button",
  ),
  const CCategoryButton(
    labelKey: "Category.categories.OFFER.label",
    icon: "assets/icons/offer-category.svg",
    actionType: ActionType.custom,
    id: "offer_button",
  ),
  const CCategoryButton(
    labelKey: "Category.categories.TREND.label",
    icon: "assets/icons/trend-category.svg",
    actionType: ActionType.custom,
    id: "trend_button",
  ),
  const CCategoryButton(
    labelKey: "Category.categories.PRINCIPAL.label",
    icon: "assets/icons/principal-category.svg",
    actionType: ActionType.custom,
    id: "principal_button",
  ),
];


/*
class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: categoryButtons.length,
        itemBuilder: (context, index) {
          final item = categoryButtons[index];
          return CCategoryButton(
            labelKey: item.labelKey,
            disabled: item.disabled,
            icon: item.icon,
            actionType: item.actionType,
            path: item.path,
            id: item.id,
          );
        },
      ),
    );
  }
}
*/

