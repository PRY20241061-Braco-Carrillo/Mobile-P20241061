import "package:flutter/material.dart";

import "../../../products/product_detail-card/variants/product_variant_selector.dart";
import "../../../products/product_detail-card/variants/variant_abstract.types.dart";
import "../menus_detail.types.dart";

class MenuSelectorType extends StatefulWidget {
  final MenuDetailCardData menuDetail;

  const MenuSelectorType({super.key, required this.menuDetail});

  @override
  MenuSelectorTypeState createState() => MenuSelectorTypeState();
}

class MenuSelectorTypeState extends State<MenuSelectorType> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(widget.menuDetail.name,
              style: Theme.of(context).textTheme.headlineMedium),
          Text(
            "${widget.menuDetail.amountPrice} ${widget.menuDetail.currencyPrice}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          buildPlatesList("Desserts", widget.menuDetail.desserts),
          buildPlatesList("Drinks", widget.menuDetail.drinks),
          buildPlatesList("Initial Dishes", widget.menuDetail.initialDishes),
          buildPlatesList(
              "Principal Dishes", widget.menuDetail.principalDishes),
        ],
      ),
    );
  }

  Widget buildPlatesList(String title, List<DishesDetailCardData> plates) {
    return ExpansionTile(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      children: plates.map((DishesDetailCardData plate) {
        final List<Variant> menuVariants = plate.variants.cast<Variant>();

        return Column(
          children: [
            ListTile(
              title: Text(plate.name),
              subtitle: Text(plate.description),
            ),
            ProductVariantSelector(
              productId: plate.productId,
              variants: menuVariants,
              type: "menu",
            ),
          ],
        );
      }).toList(),
    );
  }
}
