import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/models/management/menu/menu_by_campus.response.types.dart";
import "../../../core/notifiers/management/menu/menu_by_campus.notifier.dart";
import "../../../layout/base_layout.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../../shared/widgets/features/main-cards/menus/menu_base-card/menu_base.dart";
import "../../../shared/widgets/features/main-cards/menus/menu_base-card/menu_base.types.dart";
import "../../../shared/widgets/features/main-cards/menus/menu_compact-card/menu_compact.dart";
import "../../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "../products_list/products_by_category_of_campus_screen.dart";

class MenuScreen extends ConsumerStatefulWidget {
  final CampusCardData campusCardData;

  const MenuScreen({super.key, required this.campusCardData});

  @override
  MenuDetailScreenState createState() => MenuDetailScreenState();
}

class MenuDetailScreenState extends ConsumerState<MenuScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isFullMode = ref.watch(gridModeProvider);

    final AsyncValue<BaseResponse<List<MenuByCampusResponse>>>
        restaurantResponse =
        ref.watch(menuByCampusNotifierProvider(widget.campusCardData.campusId));

    final AsyncValue<List<MenuBaseCardData>> categoryCard =
        restaurantResponse.when(
      data: (BaseResponse<List<MenuByCampusResponse>> response) {
        return AsyncValue<List<MenuBaseCardData>>.data(
            response.data.map(_mapRestaurantToCardData).toList());
      },
      loading: () {
        return const AsyncValue<List<MenuBaseCardData>>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<List<MenuBaseCardData>>.error(error, stackTrace);
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
        ? gridContentFullMode(context, ref, categoryCard, widget.campusCardData)
        : gridContentCompactMode(
            context, ref, categoryCard, widget.campusCardData);

    Future<void> handleRefresh(WidgetRef ref) async {
      await ref
          .read(menuByCampusNotifierProvider(widget.campusCardData.campusId)
              .notifier)
          .reloadData();
    }

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          await GoRouter.of(context).push(
              "${AppRoutes.categories}/${widget.campusCardData.campusId}",
              extra: widget.campusCardData);
        }
        return true;
      },
      child: BaseLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseProductCategoriesHeader(
            height: 220,
            title: "Menu",
            onButtonPressed: (BuildContext context) {
              GoRouter.of(context).push(
                  "${AppRoutes.categories}/${widget.campusCardData.campusId}",
                  extra: widget.campusCardData);
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              gridModeSwitch,
              const SizedBox(height: 10),
              gridContent,
            ],
          ),
        ),
      ),
    );
  }

  MenuBaseCardData _mapRestaurantToCardData(MenuByCampusResponse response) {
    return MenuBaseCardData(
      amountPrice: response.amountPrice,
      currencyPrice: response.currencyPrice,
      maxCookingTime: response.maxCookingTime,
      menuId: response.menuId,
      minCookingTime: response.minCookingTime,
      name: response.name,
      unitOfTimeCookingTime: response.unitOfTimeCookingTime,
      urlImage: response.urlImage,
    );
  }
}

Widget gridContentFullMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<MenuBaseCardData>> categoryCard,
    CampusCardData campusData) {
  return categoryCard.when(
    data: (List<MenuBaseCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CMenuBaseCard(
              data: dataList[index],
              categoryNavigationData: null,
              campusCardData: campusData);
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
          return const CMenuBaseCard.skeleton();
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
          return CMenuBaseCard.error(error: error.toString());
        },
      );
    },
  );
}

Widget gridContentCompactMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<MenuBaseCardData>> categoryCard,
    CampusCardData campusData) {
  return categoryCard.when(
    data: (List<MenuBaseCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CMenuCompactCard(
              data: dataList[index],
              categoryNavigationData: null,
              campusCardData: campusData);
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
          return const CMenuCompactCard.skeleton();
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
          return CMenuCompactCard.error(error: error.toString());
        },
      );
    },
  );
}
