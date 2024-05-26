import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../../../../../../../core/models/management/menu/menu_detail.response.types.dart";
import "../variants/variant_detail.dart";
import "../variants/variant_detail.types.dart";

class MenuSelectorType extends StatefulWidget {
  const MenuSelectorType({super.key});

  @override
  MenuSelectorTypeState createState() => MenuSelectorTypeState();
}

class MenuSelectorTypeState extends State<MenuSelectorType> {
  MenuDetailResponse? menuDetail;
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
    final MenuDetailResponse menuDetailResponse =
        MenuDetailResponse.fromJson(data["data"]);
    setState(() {
      menuDetail = menuDetailResponse;
      isLoading = false;
    });
  }

  Widget buildPlatesList(String title, List<PlatesDetailResponse> plates) {
    return ExpansionTile(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      children: plates.map((PlatesDetailResponse plate) {
        return Column(
          children: [
            ListTile(
              title: Text(plate.name),
              subtitle: Text(plate.description),
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
            '${menuDetail!.amountPrice} ${menuDetail!.currencyPrice}',
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
