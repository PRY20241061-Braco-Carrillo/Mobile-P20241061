import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/models/management/combo/combo_detail.response.types.dart";
import "../../../core/notifiers/management/combo/combo_detail.notifier.dart";
import "../../../layout/base_layout.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../../shared/widgets/features/product-card/buttons/button_product.dart";
import "../../../shared/widgets/features/product-card/combos/combos_detail-card/combos_detail.dart";
import "../../../shared/widgets/features/product-card/combos/combos_detail-card/combos_detail.types.dart";
import "../../../shared/widgets/features/product-card/combos/combos_detail-card/combos_selector/combos_selector.dart";
import "../../../shared/widgets/features/product-card/products/product_detail-card/product_detail.dart";
import "../../../shared/widgets/global/theme_switcher/theme_switcher.dart";
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
        return AsyncValue<ComboDetailCardData>.data(
            ComboDetailCardData.fromJson(response.data.toJson()));
      },
      loading: () {
        return const AsyncValue<ComboDetailCardData>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<ComboDetailCardData>.error(error, stackTrace);
      },
    );

    final Widget detailsContent = categoryCard.when(
      data: (ComboDetailCardData data) {
        print("Rendering ProductDetailCardData: $data");
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
        print("Error loading ProductDetailCardData: $error");
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
      await ref
          .read(comboDetailNotifierProvider(
                  comboDetailNavigationData.productData.comboId)
              .notifier)
          .reloadData(); // Se llama a reloadData para asegurar la actualización
    }

    final Widget buttonAddProduct = ButtonAddProductToCart(
      productId: comboDetailNavigationData.productData.comboId,
      type: "combo",
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
              buttonAddProduct,
            ],
          ),
        ),
      ),
    );
  }
}
