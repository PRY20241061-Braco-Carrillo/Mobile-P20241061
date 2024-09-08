import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/models/management/product/products_by_category_of_campus.response.types.dart";
import "../../../core/notifiers/management/product/products_by_category_of_campus.notifier.dart";
import "../../../layout/base_layout.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../../shared/widgets/features/main-cards/products/product_base-card/product_base.dart";
import "../../../shared/widgets/features/main-cards/products/product_base-card/product_base.types.dart";
import "../../../shared/widgets/features/main-cards/products/product_compact-card/product_compact.dart";
import "category_navigation_data.types.dart";

final StateProvider<bool> gridModeProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) => true);

class ProductsByCategoryScreen extends ConsumerStatefulWidget {
  final CategoryNavigationData campusCategoryData;

  const ProductsByCategoryScreen({super.key, required this.campusCategoryData});

  @override
  ProductsByCategoryScreenState createState() =>
      ProductsByCategoryScreenState();
}

class ProductsByCategoryScreenState
    extends ConsumerState<ProductsByCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isFullMode = ref.watch(gridModeProvider);

    final AsyncValue<BaseResponse<List<ProductByCategoryOfCampusResponse>>>
        restaurantResponse = ref.watch(
            productsByCategoryOfCampusNotifierProvider(
                widget.campusCategoryData.categoryData.campusCategoryId));

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
        ? gridContentFullMode(
            context, ref, categoryCard, widget.campusCategoryData)
        : gridContentCompactMode(
            context, ref, categoryCard, widget.campusCategoryData);

    Future<void> handleRefresh(WidgetRef ref) async {
      await ref
          .read(productsByCategoryOfCampusNotifierProvider(
                  widget.campusCategoryData.categoryData.campusCategoryId)
              .notifier)
          .reloadData();
    }

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          await GoRouter.of(context).push(
              "${AppRoutes.categories}/${widget.campusCategoryData.campusData.campusId}",
              extra: widget.campusCategoryData.campusData);
        }
        return true;
      },
      child: BaseLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseProductCategoriesHeader(
            height: 220,
            title: widget.campusCategoryData.categoryData.name,
            iconUrl: widget.campusCategoryData.categoryData.urlImage,
            withIcon:
                widget.campusCategoryData.categoryData.urlImage.isNotEmpty,
            onButtonPressed: (BuildContext context) {
              GoRouter.of(context).push(
                  "${AppRoutes.categories}/${widget.campusCategoryData.campusData.campusId}",
                  extra: widget.campusCategoryData.campusData);
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              gridModeSwitch,
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
      amountPrice: response.amountPrice,
      currencyPrice: response.currencyPrice,
      hasVariant: response.hasVariant,
      maxCookingTime: response.maxCookingTime,
      minCookingTime: response.minCookingTime,
      unitOfTimeCookingTime: response.unitOfTimeCookingTime,
    );
  }
}

Widget gridContentFullMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ProductBaseCardData>> categoryCard,
    CategoryNavigationData data) {
  return categoryCard.when(
    data: (List<ProductBaseCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CProductBaseCard(
              data: dataList[index], categoryNavigationData: data);
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

Widget gridContentCompactMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ProductBaseCardData>> categoryCard,
    CategoryNavigationData data) {
  return categoryCard.when(
    data: (List<ProductBaseCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CProductCompactCard(
              data: dataList[index], categoryNavigationData: data);
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
          return const CProductCompactCard.skeleton();
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
          return CProductCompactCard.error(error: error.toString());
        },
      );
    },
  );
}
