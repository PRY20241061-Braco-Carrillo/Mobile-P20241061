import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/models/management/product_variant/variants_by_product.response.types.dart";
import "../../../core/notifiers/management/product_variant/variants_by_product.notifier.dart";
import "../../../layout/base_layout.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../../shared/widgets/features/product-card/buttons/button_product.dart";
import "../../../shared/widgets/features/product-card/product_detail-card/product_detail.dart";
import "../../../shared/widgets/features/product-card/product_detail-card/product_detail.types.dart";
import "../../../shared/widgets/features/product-card/product_detail-card/variants/variant_detail.dart";
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

    final ProductVariant? selectedVariant =
        ref.watch(selectedProductVariantProvider);

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

    final Widget detailsContent = categoryCard.when(
      data: (ProductDetailCardData data) {
        return MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ProductVariantSelector(
              productVariants: data.productVariants,
              data: data,
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

    final Widget productContent = MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      mainAxisSpacing: 10,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return CProductDetailCard(
          productBaseCardData: productDetailNavigationData.productData,
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

    final Widget buttonProduct = ButtonProduct(
      productId: productDetailNavigationData.productData.productId,
    );

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          await GoRouter.of(context).push(
              "${AppRoutes.products}/${productDetailNavigationData.categoryData.campusCategoryId}",
              extra: CategoryNavigationData(
                  categoryData: productDetailNavigationData.categoryData,
                  campusData: productDetailNavigationData.campusData));
        }
        return true;
      },
      child: BaseLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseProductCategoriesHeader(
            title: productDetailNavigationData.productData.name,
            height: 220,
            onButtonPressed: (BuildContext context) {
              GoRouter.of(context).push(
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
              productContent,
              if (selectedVariant != null)
                Text(
                    "Price: \$${selectedVariant.amountPrice.toStringAsFixed(2)}"),
              detailsContent,
              buttonProduct,
            ],
          ),
        ),
      ),
    );
  }
}
