import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/models/management/product_variant/variants_by_product.response.types.dart";
import "../../../core/notifiers/management/product_variant/variants_by_product.notifier.dart";
import "../../../layout/main_layout.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../../shared/widgets/features/product-card/product_detail-card/product_detail.dart";
import "../../../shared/widgets/features/product-card/product_detail-card/product_detail.types.dart";
import "../../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "../products_list/category_navigation_data.types.dart";
import "product_detail_navigation_data.types.dart";

class ProductDetailScreen extends ConsumerWidget {
  final ProductDetailNavigationData productDetailNavigationData;

  const ProductDetailScreen(
      {super.key, required this.productDetailNavigationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersistentTabController controller = PersistentTabController();
    final AsyncValue<BaseResponse<VariantsByProductResponse>> variantsResponse =
        ref.watch(variantsByProductNotifierProvider(
            productDetailNavigationData.productData.productId));

    final AsyncValue<ProductDetailCardData> categoryCard =
        variantsResponse.when(
      data: (BaseResponse<VariantsByProductResponse> response) {
        return AsyncValue<ProductDetailCardData>.data(
            ProductDetailCardData.fromJson(response.data.toJson()));
      },
      loading: () {
        return const AsyncValue<ProductDetailCardData>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<ProductDetailCardData>.error(error, stackTrace);
      },
    );

    final Widget gridContent = categoryCard.when(
      data: (ProductDetailCardData data) {
        return MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return CProductDetailCard(
              data: data,
              categoryNavigationData: null,
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

    Future<void> handleRefresh(WidgetRef ref) async {
      await ref
          .read(variantsByProductNotifierProvider(
                  productDetailNavigationData.productData.productId)
              .notifier)
          .reloadData();
    }

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          context.go(
              "${AppRoutes.products}/${productDetailNavigationData.categoryData.campusCategoryId}",
              extra: CategoryNavigationData(
                  categoryData: productDetailNavigationData.categoryData,
                  campusData: productDetailNavigationData.campusData));
        }
        return true;
      },
      child: MainLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseProductCategoriesHeader(
            title: productDetailNavigationData.productData.name,
            height: 220,
            onButtonPressed: (BuildContext context) {
              context.go(
                  "${AppRoutes.products}/${productDetailNavigationData.categoryData.campusCategoryId}",
                  extra: CategoryNavigationData(
                      categoryData: productDetailNavigationData.categoryData,
                      campusData: productDetailNavigationData.campusData));
            },
            fontSize: 32,
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
}
