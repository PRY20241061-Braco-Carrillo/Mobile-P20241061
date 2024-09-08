import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../core/models/base_response.dart";
import "../../core/models/management/promotion/promotion_product_detail.response.types.dart";
import "../../core/notifiers/management/promotion/promotion_combo_detail.notifier.dart";
import "../../core/notifiers/management/promotion/promotion_product_detail.notifier.dart";
import "../../layout/base_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../shared/widgets/features/main-cards/buttons/promotion/button_add.dart";
import "../../shared/widgets/features/main-cards/products/product_detail-card/product_detail.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_detail-card/promotion_detail.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_detail-card/variants/promotions/promotion_detail.variant.types.dart";
import "../../shared/widgets/features/main-cards/promotions/promotions_detail-card/variants/promotions/promotion_variant_selector.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "promotion_navigations_data.types.dart";

class PromotionProductDetailScreen extends ConsumerWidget {
  final PromotionDetailNavigationData promotionDetailNavigationData;

  const PromotionProductDetailScreen(
      {super.key, required this.promotionDetailNavigationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersistentTabController controller = PersistentTabController();
    final AsyncValue<BaseResponse<PromotionProductDetailResponse>>
        comboDetailResponse = ref.watch(productPromotionDetailNotifierProvider(
            promotionDetailNavigationData.productData.promotionId));

    final AsyncValue<PromotionProductDetailResponse> categoryCard =
        comboDetailResponse.when(
      data: (BaseResponse<PromotionProductDetailResponse> response) {
        return AsyncValue<PromotionProductDetailResponse>.data(
            PromotionProductDetailResponse.fromJson(response.data.toJson()));
      },
      loading: () {
        return const AsyncValue<PromotionProductDetailResponse>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<PromotionProductDetailResponse>.error(
            error, stackTrace);
      },
    );

    final Widget detailsContent = categoryCard.when(
      data: (PromotionProductDetailResponse data) {
        return MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return PromotionProductVariantSelector(
              variants: data.productVariants.map((variant) {
                return PromotionDetailVariantCard(
                  productVariantId: variant.productVariantId,
                  detail: variant.detail,
                  amountPrice: variant.amountPrice,
                  currencyPrice: variant.currencyPrice,
                  name: variant.name,
                  minCookingTime: variant.minCookingTime,
                  maxCookingTime: variant.maxCookingTime,
                  unitOfTimeCookingTime: variant.unitOfTimeCookingTime,
                  description: variant.description,
                  nutritionalInformationId: variant.nutritionalInformationId,
                  productId: variant.productId,
                );
              }).toList(),
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
          .reloadData();
    }

    final Widget buttonAddProduct = ButtonAddProductPromotionVariantToCart(
        productId: promotionDetailNavigationData.productData.promotionId,
        campusData: promotionDetailNavigationData.campusData);

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
            fontSize: 32,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
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
