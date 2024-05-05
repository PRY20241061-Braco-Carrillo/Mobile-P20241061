import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../config/routes/routes.dart";
import "../campus-card/campus_card.types.dart";
import "category_button.types.dart";
import "../../../../modules/product/products_list/category_navigation_data.types.dart";

class CCategoryButton extends StatelessWidget {
  final CategoryButtonData? data;
  final bool showSkeleton;
  final CampusCardData? campusData;
  final String? error;

  const CCategoryButton(
      {super.key, required this.data, required this.campusData})
      : showSkeleton = false,
        error = null;

  const CCategoryButton.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        campusData = null;

  const CCategoryButton.error({super.key, required this.error})
      : data = null,
        showSkeleton = false,
        campusData = null;

  @override
  Widget build(BuildContext context) {
    if (showSkeleton) {
      return _buildSkeleton(context);
    } else if (error != null) {
      return _buildErrorContent(error!);
    } else {
      return _buildCardContent(context, data!);
    }
  }

  Widget _buildCardContent(BuildContext context, CategoryButtonData data) {
    return InkWell(
      onTap: () {
        context.go("${AppRoutes.products}/${data.campusCategoryId}",
            extra: CategoryNavigationData(
                categoryData: data, campusData: campusData!));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: data.urlImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                          placeholder: (BuildContext context, String url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (BuildContext context, String url,
                                  Object error) =>
                              const Icon(Icons.error),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 3, bottom: 3),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onTap(BuildContext context, CategoryButtonData data) {}

  Widget _buildSkeleton(
    BuildContext context,
  ) {
    return Skeletonizer(
        child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 3, bottom: 3),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 100,
                    height: 20,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildErrorContent(Object error) {
    return Center(
      child: Text("Error: $error"),
    );
  }
}

/*
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

*/
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

