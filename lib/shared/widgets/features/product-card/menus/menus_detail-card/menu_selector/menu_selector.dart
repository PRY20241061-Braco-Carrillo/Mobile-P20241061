import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import "../../../products/product_detail-card/variants/variant_abstract.types.dart";
import "../../../products/product_detail-card/variants/product_variant_selector.dart";
import "../menus_detail.types.dart";

class MenuSelectorType extends StatefulWidget {
  const MenuSelectorType({super.key});

  @override
  MenuSelectorTypeState createState() => MenuSelectorTypeState();
}

class MenuSelectorTypeState extends State<MenuSelectorType> {
  MenuDetailCardData? menuDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMenuDetail();
  }

  Future<void> loadMenuDetail() async {
    final String response =
        await rootBundle.loadString('assets/pruebas/prueba.json');
    final data = json.decode(response);
    final MenuDetailCardData menuDetailResponse =
        MenuDetailCardData.fromJson(data["data"]);
    setState(() {
      menuDetail = menuDetailResponse;
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (menuDetail == null) {
      return const Center(child: Text('Failed to load menu details'));
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(menuDetail!.name, style: Theme.of(context).textTheme.headline4),
          Text(
            "${menuDetail!.amountPrice} ${menuDetail!.currencyPrice}",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          buildPlatesList("Desserts", menuDetail!.desserts),
          buildPlatesList("Drinks", menuDetail!.drinks),
          buildPlatesList("Initial Dishes", menuDetail!.initialDishes),
          buildPlatesList("Principal Dishes", menuDetail!.principalDishes),
        ],
      ),
    );
  }
}
