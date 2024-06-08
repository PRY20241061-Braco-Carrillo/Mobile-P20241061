import "package:collection/collection.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../../../providers/image_provider.dart";
import "../../../../../global/image_display/image_display.dart";
import "../variants/menu/menu_detail_variant.types.dart";
import "../variants/menu/menu_variant_selector.dart";
import "../menus_detail.types.dart";

final StateNotifierProvider<PanelExpansionNotifier, List<bool>>
    panelExpansionStateProvider =
    StateNotifierProvider<PanelExpansionNotifier, List<bool>>(
        (StateNotifierProviderRef<PanelExpansionNotifier, List<bool>> ref) {
  return PanelExpansionNotifier();
});

class PanelExpansionNotifier extends StateNotifier<List<bool>> {
  PanelExpansionNotifier() : super(<bool>[]);

  void togglePanel(int index) {
    state = <bool>[
      for (int i = 0; i < state.length; i++)
        if (i == index) !state[i] else state[i]
    ];
  }

  void setPanelCount(int count) {
    state = List<bool>.generate(count, (int index) => true);
  }
}

class MenuSelectorType extends ConsumerStatefulWidget {
  final MenuDetailCardData menuDetail;

  const MenuSelectorType({super.key, required this.menuDetail});

  @override
  MenuSelectorTypeState createState() => MenuSelectorTypeState();
}

class MenuSelectorTypeState extends ConsumerState<MenuSelectorType> {
  String? selectedDessert;
  String? selectedDrink;
  String? selectedInitialDish;
  String? selectedPrincipalDish;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(panelExpansionStateProvider.notifier).setPanelCount(4);
      initializeSelectedProduct();
    });
  }

  void initializeSelectedProduct() {
    if (widget.menuDetail.desserts.length == 1) {
      selectedDessert = widget.menuDetail.desserts.first.productId;
    }
    if (widget.menuDetail.drinks.length == 1) {
      selectedDrink = widget.menuDetail.drinks.first.productId;
    }
    if (widget.menuDetail.initialDishes.length == 1) {
      selectedInitialDish = widget.menuDetail.initialDishes.first.productId;
    }
    if (widget.menuDetail.principalDishes.length == 1) {
      selectedPrincipalDish = widget.menuDetail.principalDishes.first.productId;
    }
  }

  @override
  Widget build(BuildContext context) {
    const String labelDessertsKey = "MenuCategory.categories.DESSERTS.label";
    const String labelDrinksKey = "MenuCategory.categories.DRINKS.label";
    const String labelInitialDishesKey =
        "MenuCategory.categories.INITIAL_DISHES.label";
    const String labelPrincipalDishesKey =
        "MenuCategory.categories.PRINCIPAL_DISHES.label";
    const String selectDessertsKey = "MenuCategory.categories.DESSERTS.select";
    const String selectDrinksKey = "MenuCategory.categories.DRINKS.select";
    const String selectInitialDishesKey =
        "MenuCategory.categories.INITIAL_DISHES.select";
    const String selectPrincipalDishesKey =
        "MenuCategory.categories.PRINCIPAL_DISHES.select";

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(widget.menuDetail.name,
              style: Theme.of(context).textTheme.headlineMedium),
          Text(
              "${widget.menuDetail.amountPrice} ${widget.menuDetail.currencyPrice}",
              style: Theme.of(context).textTheme.titleMedium),
          buildCategoryPanel(labelDessertsKey, widget.menuDetail.desserts, 0,
              selectDessertsKey),
          buildCategoryPanel(
              labelDrinksKey, widget.menuDetail.drinks, 1, selectDrinksKey),
          buildCategoryPanel(labelInitialDishesKey,
              widget.menuDetail.initialDishes, 2, selectInitialDishesKey),
          buildCategoryPanel(labelPrincipalDishesKey,
              widget.menuDetail.principalDishes, 3, selectPrincipalDishesKey),
        ],
      ),
    );
  }

  Widget buildCategoryPanel(String title, List<DishesDetailCardData> items,
      int index, String selectKey) {
    final List<bool> panelState = ref.watch(panelExpansionStateProvider);

    print("Building category panel: $title with items: ${items.length}");

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExpansionPanelList(
      expansionCallback: (int i, bool isExpanded) {
        ref.read(panelExpansionStateProvider.notifier).togglePanel(index);
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(title.tr(),
                  style: Theme.of(context).textTheme.titleLarge),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                DropdownButton<DishesDetailCardData>(
                  isExpanded: true,
                  hint: Text(selectKey.tr()),
                  value: getSelectedProduct(index),
                  onChanged: (DishesDetailCardData? newValue) {
                    setState(() {
                      setSelectedProduct(newValue, index);
                      print(
                          "Selected product: ${newValue?.name} for index: $index");
                    });
                  },
                  items: items.map((DishesDetailCardData item) {
                    return DropdownMenuItem<DishesDetailCardData>(
                      value: item,
                      child: Text(item.name),
                    );
                  }).toList(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  dropdownColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                if (getSelectedProduct(index) != null)
                  buildProductDetails(getSelectedProduct(index)!),
              ],
            ),
          ),
          isExpanded: panelState[index],
        ),
      ],
    );
  }

  Widget buildProductDetails(DishesDetailCardData product) {
    print(
        "Building product details for: ${product.name} with variants: ${product.variants.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 50, maxHeight: 50),
            child: ImageDisplay(
              config: ImageConfig(
                imageUrl: product.urlImage,
                width: 50,
                height: 50,
                onErrorHeight: 50,
                onErrorWidth: 50,
                onErrorPadding: const EdgeInsets.only(bottom: 70, top: 30),
              ),
            ),
          ),
          title: Text(product.name),
          subtitle: Text(product.description),
        ),
        MenuVariantSelector(
          menuId: product.productMenuId,
          variants: convertVariantMenuSelectorDetailsToMenuDetailVariantCards(
              product.variants),
        ),
      ],
    );
  }

  DishesDetailCardData? getSelectedProduct(int index) {
    switch (index) {
      case 0:
        return widget.menuDetail.desserts.firstWhereOrNull(
            (DishesDetailCardData item) => item.productId == selectedDessert);
      case 1:
        return widget.menuDetail.drinks.firstWhereOrNull(
            (DishesDetailCardData item) => item.productId == selectedDrink);
      case 2:
        return widget.menuDetail.initialDishes.firstWhereOrNull(
            (DishesDetailCardData item) =>
                item.productId == selectedInitialDish);
      case 3:
        return widget.menuDetail.principalDishes.firstWhereOrNull(
            (DishesDetailCardData item) =>
                item.productId == selectedPrincipalDish);
      default:
        return null;
    }
  }

  void setSelectedProduct(DishesDetailCardData? product, int index) {
    switch (index) {
      case 0:
        selectedDessert = product?.productId;
        break;
      case 1:
        selectedDrink = product?.productId;
        break;
      case 2:
        selectedInitialDish = product?.productId;
        break;
      case 3:
        selectedPrincipalDish = product?.productId;
        break;
    }
  }

  List<MenuDetailVariantCard>
      convertVariantMenuSelectorDetailsToMenuDetailVariantCards(
          List<VariantMenuSelectorDetail> variantDetails) {
    return variantDetails.map((VariantMenuSelectorDetail variantDetail) {
      return MenuDetailVariantCard(
        productVariantId: variantDetail.productVariantId,
        detail: double.tryParse(variantDetail.detail) ?? 0.0,
        variantInfo: variantDetail.variantInfo,
        variantOrder: variantDetail.variantOrder.toDouble(),
        variants: variantDetail.variants,
      );
    }).toList();
  }
}
