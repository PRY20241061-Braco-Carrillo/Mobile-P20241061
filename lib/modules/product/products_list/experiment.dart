/*import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/product/products_by_category_of_campus.response.types.dart";
import "../../core/notifiers/management/product/products_by_category_of_campus.notifier.dart";
import "../../layout/main_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../shared/widgets/features/category-button/category_navigation_data.types.dart";
import "../../shared/widgets/features/product-card/product_base-card/product_base.dart";
import "../../shared/widgets/features/product-card/product_base-card/product_base.types.dart";
import "../../shared/widgets/features/product-card/product_simple-card/product_simple.dart";
import "../../shared/widgets/features/product-header/products_categories_header.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";

final StateProvider<bool> gridModeProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) => true);

class ProductsByCategoryScreen extends ConsumerWidget {
  final CategoryNavigationData campusCategoryData;

  const ProductsByCategoryScreen({super.key, required this.campusCategoryData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFullMode = ref.watch(gridModeProvider);

    final AsyncValue<BaseResponse<List<ProductByCategoryOfCampusResponse>>>
        restaurantResponse = ref.watch(
            productsByCategoryOfCampusNotifierProvider(
                campusCategoryData.categoryData.campusCategoryId));

    final AsyncValue<List<ProductBaseCardData>> categoryCard =
        restaurantResponse.when(
      data: (BaseResponse<List<ProductByCategoryOfCampusResponse>> response) {
        return AsyncValue<List<ProductBaseCardData>>.data(
            response.data.map(_mapRestaurantToCardData).toList());
      },
      loading: () {
        return const AsyncValue<List<ProductBaseCardData>>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<List<ProductBaseCardData>>.error(error, stackTrace);
      },
    );

    final PersistentTabController controller = PersistentTabController();

    final Widget gridModeSwitch = Switch(
      value: isFullMode,
      onChanged: (bool newValue) {
        ref.read(gridModeProvider.notifier).state = newValue;
      },
    );

    final Widget gridContent = isFullMode
        ? gridContentFullMode(context, ref, categoryCard)
        : gridContentCompactMode(context, ref, categoryCard);

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          context.go(
              "${AppRoutes.categories}/${campusCategoryData.campusData.campusId}",
              extra: campusCategoryData.campusData);
        }
        return true;
      },
      child: MainLayout(
        tabController: controller,
        body: ScrollableLayout(
          header: CBaseProductCategoriesHeader(
            height: 220,
            title: campusCategoryData.categoryData.name,
            iconUrl: campusCategoryData.categoryData.urlImage,
            withIcon: campusCategoryData.categoryData.urlImage.isNotEmpty,
            onButtonPressed: (BuildContext context) {
              context.go(
                  "${AppRoutes.categories}/${campusCategoryData.campusData.campusId}",
                  extra: campusCategoryData.campusData);
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              const ThemeSwitcherWidget(),
              gridModeSwitch,
              const SizedBox(height: 10),
              gridContent,
            ],
          ),
        ),
      ),
    );
  }

  ProductBaseCardData _mapRestaurantToCardData(
      ProductByCategoryOfCampusResponse response) {
    return ProductBaseCardData(
      productId: response.productId,
      name: response.name,
      urlImage: response.urlImage,
      price: response.price,
      currencyPrice: response.currencyPrice,
      hasVariant: response.hasVariant,
      maxCookingTime: response.maxCookingTime,
      minCookingTime: response.minCookingTime,
      unitOfTimeCookingTime: response.unitOfTimeCookingTime,
    );
  }
}

Widget gridContentFullMode(BuildContext context, WidgetRef ref,
    AsyncValue<List<ProductBaseCardData>> categoryCard) {
  return categoryCard.when(
    data: (List<ProductBaseCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CProductBaseCard(data: dataList[index]);
        },
      );
    },
    loading: () {
      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return const CProductBaseCard.skeleton();
        },
      );
    },
    error: (Object error, _) {
      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return CProductBaseCard.error(error: error.toString());
        },
      );
    },
  );
}

Widget gridContentCompactMode(BuildContext context, WidgetRef ref,
    AsyncValue<List<ProductBaseCardData>> categoryCard) {
  return categoryCard.when(
    data: (List<ProductBaseCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CProductSimpleCard(data: dataList[index]);
        },
      );
    },
    loading: () {
      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return const CProductSimpleCard.skeleton();
        },
      );
    },
    error: (Object error, _) {
      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return CProductSimpleCard.error(error: error.toString());
        },
      );
    },
  );
}
*/