import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/campus_category/campus_category.response.types.dart";
import "../../core/notifiers/management/campus_category/campus_category.notifier.dart";
import "../../layout/main_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../shared/widgets/features/category-button/category_button.dart";
import "../../shared/widgets/features/category-button/category_button.types.dart";
import "../../shared/widgets/features/header/category-header/restaurant_categories_header.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";

class CategoriesScreen extends ConsumerWidget {
  final CampusCardData campusData;

  const CategoriesScreen({super.key, required this.campusData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersistentTabController controller = PersistentTabController();
    final AsyncValue<BaseResponse<List<CampusCategoryResponse>>>
        campusCategoryResponse =
        ref.watch(campusCategoryNotifierProvider(campusData.campusId));

    final AsyncValue<List<CategoryButtonData>> categoryCard =
        campusCategoryResponse.when(
      data: (BaseResponse<List<CampusCategoryResponse>> response) {
        return AsyncValue<List<CategoryButtonData>>.data(
            response.data.map(_mapCampusCategoryToCardData).toList());
      },
      loading: () {
        return const AsyncValue<List<CategoryButtonData>>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<List<CategoryButtonData>>.error(error, stackTrace);
      },
    );

    final Widget gridContent = categoryCard.when(
      data: (List<CategoryButtonData> dataList) {
        return AlignedGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return CCategoryButton(
                data: dataList[index], campusData: campusData);
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
            return const CCategoryButton.skeleton();
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
            return CCategoryButton.error(error: error.toString());
          },
        );
      },
    );

    Future<void> handleRefresh(WidgetRef ref) async {
      await ref
          .read(campusCategoryNotifierProvider(campusData.campusId).notifier)
          .reloadData();
    }

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          context.go("${AppRoutes.campus}/${campusData.restaurantId}");
        }
        return true;
      },
      child: MainLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseRestaurantCategoriesHeader(
            campusCardData: campusData,
            height: 220,
            idDialogProvider: campusData.campusId,
            onButtonPressed: (BuildContext context) {
              context.go("${AppRoutes.campus}/${campusData.restaurantId}");
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              const ThemeSwitcherWidget(),
              const SizedBox(height: 10),
              gridContent,
            ],
          ),
        ),
      ),
    );
  }

  CategoryButtonData _mapCampusCategoryToCardData(
      CampusCategoryResponse response) {
    return CategoryButtonData(
      name: response.name,
      campusCategoryId: response.campusCategoryId,
      urlImage: response.urlImage,
    );
  }
}
