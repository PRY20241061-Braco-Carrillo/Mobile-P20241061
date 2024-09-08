import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../core/models/base_response.dart";
import "../../core/models/management/promotion/promotion_combo_detail.response.types.dart";
import "../../core/notifiers/management/promotion/promotion_combo_detail.notifier.dart";
import "../../layout/base_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_detail-card/promotion_combo/promotion_combo_detail.types.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_detail-card/promotion_detail.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "promotion_navigations_data.types.dart";

class PromotionCombosDetailScreen extends ConsumerWidget {
  final PromotionDetailNavigationData promotionDetailNavigationData;

  const PromotionCombosDetailScreen(
      {super.key, required this.promotionDetailNavigationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersistentTabController controller = PersistentTabController();
    final AsyncValue<BaseResponse<PromotionComboDetailResponse>>
        comboDetailResponse = ref.watch(comboPromotionDetailNotifierProvider(
            promotionDetailNavigationData.productData.promotionId));

    final AsyncValue<PromotionComboDetailCardData> categoryCard =
        comboDetailResponse.when(
      data: (BaseResponse<PromotionComboDetailResponse> response) {
        return AsyncValue<PromotionComboDetailCardData>.data(
            PromotionComboDetailCardData.fromJson(response.data.toJson()));
      },
      loading: () {
        return const AsyncValue<PromotionComboDetailCardData>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<PromotionComboDetailCardData>.error(
            error, stackTrace);
      },
    );

    final Widget detailsContent;

    final Widget comboContent = MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      mainAxisSpacing: 10,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return CPromotionDetailCard(
          comboDetailCardData: promotionDetailNavigationData.productData,
        );
      },
    );

    Future<void> handleRefresh(WidgetRef ref) async {
      await ref
          .read(comboPromotionDetailNotifierProvider(
                  promotionDetailNavigationData.productData.promotionId)
              .notifier)
          .reloadData(); // Se llama a reloadData para asegurar la actualización
    }

/*    final Widget buttonAddProduct = ButtonAddProductToCart(
      productData: promotionDetailNavigationData.productData,
      type: "combo",
    );*/

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {}
        return true;
      },
      child: BaseLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseProductCategoriesHeader(
            title: promotionDetailNavigationData.productData.name,
            height: 220,
            onButtonPressed: (BuildContext context) {
              //TODO: Implementar la navegación a la pantalla de categorías
            },
            fontSize: 32,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              comboContent,
              //detailsContent,
              //buttonAddProduct,
            ],
          ),
        ),
      ),
    );
  }
}
