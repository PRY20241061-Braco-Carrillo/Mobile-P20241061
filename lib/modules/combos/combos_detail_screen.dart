import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/combo/combo_detail.response.types.dart";
import "../../core/notifiers/management/combo/combo_detail.notifier.dart";
import "../../layout/base_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../shared/widgets/features/main-cards/buttons/combo/button_add.dart";

import "../../shared/widgets/features/main-cards/combos/combos_detail-card/combos_detail.dart";
import "../../shared/widgets/features/main-cards/combos/combos_detail-card/combos_detail.types.dart";
import "../../shared/widgets/features/main-cards/combos/combos_detail-card/combos_selector/combos_selector.dart";
import "../../shared/widgets/features/main-cards/combos/combos_detail-card/variants/combo/combo_variant.provider.dart";
import "../../shared/widgets/features/main-cards/products/product_detail-card/product_detail.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "combos_detail_navigations_data.types.dart";

class CombosDetailScreen extends ConsumerWidget {
  final ComboDetailNavigationData comboDetailNavigationData;

  const CombosDetailScreen(
      {super.key, required this.comboDetailNavigationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersistentTabController controller = PersistentTabController();
    final AsyncValue<BaseResponse<ComboDetailResponse>> comboDetailResponse =
        ref.watch(comboDetailNotifierProvider(
            comboDetailNavigationData.productData.comboId));

    final AsyncValue<ComboDetailCardData> categoryCard =
        comboDetailResponse.when(
      data: (BaseResponse<ComboDetailResponse> response) {
        final ComboDetailCardData comboDetailCardData =
            ComboDetailCardData.fromJson(response.data.toJson());

        Future.microtask(() {
          ref.read(comboDetailCardDataProvider.notifier).state =
              comboDetailCardData;

          final selectedComboNotifier = ref.read(selectedComboVariantsProvider(
                  comboDetailNavigationData.productData.comboId)
              .notifier);
          selectedComboNotifier.updateComboDetails(
            comboDetailNavigationData.productData.comboId,
            comboDetailNavigationData.productData.name,
            comboDetailNavigationData.productData.amountPrice,
            comboDetailNavigationData.productData.currencyPrice,
            comboDetailNavigationData.productData.urlImage,
          );
        });

        print("Updated comboDetailCardDataProvider with: $comboDetailCardData");
        return AsyncValue<ComboDetailCardData>.data(comboDetailCardData);
      },
      loading: () {
        print("Loading combo details...");
        return const AsyncValue<ComboDetailCardData>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        print("Error loading combo details: $error");
        return AsyncValue<ComboDetailCardData>.error(error, stackTrace);
      },
    );

    final Widget detailsContent = categoryCard.when(
      data: (ComboDetailCardData data) {
        print("Combo details loaded: $data");
        return MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ComboSelectorType(
              comboDetail: data,
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
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return const CProductDetailCard.skeleton();
          },
        );
      },
      error: (Object error, _) {
        print("Error loading ComboDetailCardData: $error");
        return MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return CProductDetailCard.error(error: error.toString());
          },
        );
      },
    );

    final Widget comboContent = MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      mainAxisSpacing: 10,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return CComboDetailCard(
          comboDetailCardData: comboDetailNavigationData.productData,
        );
      },
    );

    Future<void> handleRefresh(WidgetRef ref) async {
      print("Refreshing combo details...");
      await ref
          .read(comboDetailNotifierProvider(
                  comboDetailNavigationData.productData.comboId)
              .notifier)
          .reloadData();
    }

    final Widget buttonAddCombo = ButtonAddComboVariantToCart(
      comboId: comboDetailNavigationData.productData.comboId,
    );

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          await GoRouter.of(context).push(
            "${AppRoutes.categories}${AppRoutes.menu}/${comboDetailNavigationData.campusData.campusId}/${comboDetailNavigationData.productData.comboId}",
            extra: ComboDetailNavigationData(
                campusData: comboDetailNavigationData.campusData,
                productData: comboDetailNavigationData.productData),
          );
        }
        return true;
      },
      child: BaseLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseProductCategoriesHeader(
            title: comboDetailNavigationData.productData.name,
            height: 220,
            onButtonPressed: (BuildContext context) {
              GoRouter.of(context).push(
                "${AppRoutes.categories}${AppRoutes.menu}/${comboDetailNavigationData.campusData.campusId}/${comboDetailNavigationData.productData.comboId}",
                extra: ComboDetailNavigationData(
                    campusData: comboDetailNavigationData.campusData,
                    productData: comboDetailNavigationData.productData),
              );
            },
            fontSize: 32,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              const ThemeSwitcherWidget(),
              const SizedBox(height: 10),
              comboContent,
              detailsContent,
              buttonAddCombo,
            ],
          ),
        ),
      ),
    );
  }
}
