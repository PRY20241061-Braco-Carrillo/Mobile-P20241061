import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/promotion/promotion_by_campus.response.types.dart";
import "../../core/notifiers/management/menu/menu_by_campus.notifier.dart";
import "../../core/notifiers/management/promotion/promotion_by_campus.notifier.dart";
import "../../layout/base_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../shared/widgets/features/main-cards/combos/combos_base-card/combo_base.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_base-card/promotion_base.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_base-card/promotion_base.types.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_compact-card/promotion_compact.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "../product/products_list/products_by_category_of_campus_screen.dart";

class PromotionsScreen extends ConsumerStatefulWidget {
  final CampusCardData campusCardData;

  const PromotionsScreen({super.key, required this.campusCardData});

  @override
  PromotionsDetailScreenState createState() => PromotionsDetailScreenState();
}

class PromotionsDetailScreenState extends ConsumerState<PromotionsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isFullMode = ref.watch(gridModeProvider);

    final AsyncValue<BaseResponse<List<PromotionByCampusResponse>>>
        restaurantResponse = ref.watch(
            promotionsByCampusNotifierProvider(widget.campusCardData.campusId));

    final AsyncValue<List<PromotionByCampusCardData>> categoryCard =
        restaurantResponse.when(
      data: (BaseResponse<List<PromotionByCampusResponse>> response) {
        return AsyncValue<List<PromotionByCampusCardData>>.data(
            response.data.map(_mapComboToCardData).toList());
      },
      loading: () {
        return const AsyncValue<List<PromotionByCampusCardData>>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<List<PromotionByCampusCardData>>.error(
            error, stackTrace);
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
            title: widget.campusCardData.name,
            iconUrl: widget.campusCardData.imageUrl,
            withIcon: widget.campusCardData.imageUrl.isNotEmpty,
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

  PromotionByCampusCardData _mapComboToCardData(
      PromotionByCampusResponse response) {
    return PromotionByCampusCardData(
      discount: response.discount,
      discountType: response.discountType,
      name: response.name,
      hasVariant: response.hasVariant,
      promotionId: response.promotionId,
      urlImage: response.urlImage,
      comboId: response.promotionId,
    );
  }
}

Widget gridContentFullMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<PromotionByCampusCardData>> categoryCard,
    CampusCardData campusCardData) {
  return categoryCard.when(
    data: (List<PromotionByCampusCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CPromotionBaseCard(
            data: dataList[index],
            categoryNavigationData: null,
            campusCardData: campusCardData,
          );
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
          return const CComboBaseCard.skeleton();
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
          return CComboBaseCard.error(error: error.toString());
        },
      );
    },
  );
}

Widget gridContentCompactMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<PromotionByCampusCardData>> categoryCard,
    CampusCardData campusCardData) {
  return categoryCard.when(
    data: (List<PromotionByCampusCardData> dataList) {
      return AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CCPromotionCompactCard(
            data: dataList[index],
            categoryNavigationData: null,
            campusCardData: campusCardData,
          );
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
          return const CCPromotionCompactCard.skeleton();
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
          return CCPromotionCompactCard.error(error: error.toString());
        },
      );
    },
  );
}
