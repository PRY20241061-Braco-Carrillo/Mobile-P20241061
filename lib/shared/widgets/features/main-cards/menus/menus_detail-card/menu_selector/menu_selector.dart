import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../menus_detail.types.dart';
import '../variants/menu/menu_variant.provider.dart';
import '../variants/menu/menu_variant_selector.dart';

final StateNotifierProvider<PanelExpansionNotifier, List<bool>>
    panelExpansionStateProvider =
    StateNotifierProvider<PanelExpansionNotifier, List<bool>>((ref) {
  return PanelExpansionNotifier();
});

class PanelExpansionNotifier extends StateNotifier<List<bool>> {
  PanelExpansionNotifier() : super(<bool>[]);

  void togglePanel(int index) {
    if (index >= 0 && index < state.length) {
      state = <bool>[
        for (int i = 0; i < state.length; i++)
          if (i == index) !state[i] else state[i]
      ];
    }
  }

  void setPanelCount(int count) {
    state = List<bool>.generate(count, (index) => true);
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(widget.menuDetail.name,
              style: Theme.of(context).textTheme.headlineMedium),
          Text(
              "${widget.menuDetail.amountPrice} ${widget.menuDetail.currencyPrice}",
              style: Theme.of(context).textTheme.titleMedium),
          buildCategoryPanel('MenuCategory.categories.DESSERTS.label',
              widget.menuDetail.desserts, 0, selectedDessertsVariantsProvider),
          buildCategoryPanel('MenuCategory.categories.DRINKS.label',
              widget.menuDetail.drinks, 1, selectedDrinksVariantsProvider),
          buildCategoryPanel(
              'MenuCategory.categories.INITIAL_DISHES.label',
              widget.menuDetail.initialDishes,
              2,
              selectedInitialDishesVariantsProvider),
          buildCategoryPanel(
              'MenuCategory.categories.PRINCIPAL_DISHES.label',
              widget.menuDetail.principalDishes,
              3,
              selectedPrincipalDishesVariantsProvider),
        ],
      ),
    );
  }

  Widget buildCategoryPanel(
      String title,
      List<DishesDetailCardData> items,
      int index,
      StateNotifierProvider<SelectedMenuVariantsNotifier, SelectedVariantsState>
          provider) {
    final bool allVariantsSelected =
        ref.watch(provider.select((state) => state.selectedVariant != null));

    return ExpansionPanelList(
      expansionCallback: (int i, bool isExpanded) {
        setState(() {
          // handle panel expansion state
        });
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(title.tr(),
                  style: Theme.of(context).textTheme.titleLarge),
              trailing: allVariantsSelected
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.error, color: Colors.red),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                DropdownButton<DishesDetailCardData>(
                  isExpanded: true,
                  hint: Text('Select ${title.tr()}'),
                  value: getSelectedProduct(index),
                  onChanged: (DishesDetailCardData? newValue) {
                    setState(() {
                      setSelectedProduct(newValue, index);
                      resetSelectedVariants(index);
                    });
                  },
                  items: items.map((DishesDetailCardData item) {
                    return DropdownMenuItem<DishesDetailCardData>(
                      value: item,
                      child: Text(item.name),
                    );
                  }).toList(),
                ),
                if (getSelectedProduct(index) != null)
                  buildProductDetails(getSelectedProduct(index)!, provider),
              ],
            ),
          ),
          isExpanded: true, // control this value
        ),
      ],
    );
  }

  Widget buildProductDetails(
      DishesDetailCardData product,
      StateNotifierProvider<SelectedMenuVariantsNotifier, SelectedVariantsState>
          provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 50, maxHeight: 50),
            child: Image.network(product.urlImage),
          ),
          title: Text(product.name),
          subtitle: Text(product.description),
        ),
        MenuVariantSelector(
          menuId: product.productMenuId,
          variants: product.toVariantMenuSelectorDetails(),
          provider: provider,
        ),
      ],
    );
  }

  DishesDetailCardData? getSelectedProduct(int index) {
    switch (index) {
      case 0:
        return widget.menuDetail.desserts
            .firstWhereOrNull((item) => item.productId == selectedDessert);
      case 1:
        return widget.menuDetail.drinks
            .firstWhereOrNull((item) => item.productId == selectedDrink);
      case 2:
        return widget.menuDetail.initialDishes
            .firstWhereOrNull((item) => item.productId == selectedInitialDish);
      case 3:
        return widget.menuDetail.principalDishes.firstWhereOrNull(
            (item) => item.productId == selectedPrincipalDish);
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

  void resetSelectedVariants(int index) {
    final provider = getProviderForIndex(index);
    ref.read(provider.notifier).resetVariants();
  }

  StateNotifierProvider<SelectedMenuVariantsNotifier, SelectedVariantsState>
      getProviderForIndex(int index) {
    switch (index) {
      case 0:
        return selectedDessertsVariantsProvider;
      case 1:
        return selectedDrinksVariantsProvider;
      case 2:
        return selectedInitialDishesVariantsProvider;
      case 3:
        return selectedPrincipalDishesVariantsProvider;
      default:
        throw ArgumentError('Invalid index');
    }
  }
}
