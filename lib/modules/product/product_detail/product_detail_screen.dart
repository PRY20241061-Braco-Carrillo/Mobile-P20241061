import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../../ar_core/ar.types.dart";
import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/models/management/product_variant/variants_by_product.response.types.dart";
import "../../../core/notifiers/management/product_variant/variants_by_product.notifier.dart";
import "../../../layout/base_layout.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../../shared/widgets/features/main-cards/buttons/ar/button_ar.dart";
import "../../../shared/widgets/features/main-cards/buttons/product/button_add.dart";
import "../../../shared/widgets/features/main-cards/products/product_detail-card/complements/detail_complements_card.dart";
import "../../../shared/widgets/features/main-cards/products/product_detail-card/complements/product_components.types.dart";
import "../../../shared/widgets/features/main-cards/products/product_detail-card/product_detail.dart";
import "../../../shared/widgets/features/main-cards/products/product_detail-card/product_detail.types.dart";
import "../../../shared/widgets/features/main-cards/products/product_detail-card/variants/product/product_variant.provider.dart";
import "../../../shared/widgets/features/main-cards/products/product_detail-card/variants/product/product_variant_selector.dart";
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
        ref.watch(productVariantNotifierProvider(
            productDetailNavigationData.productData.productId));

    final AsyncValue<ProductDetailCardData> categoryCard =
        variantsResponse.when(
      data: (BaseResponse<VariantsByProductResponse> response) {
        final ProductDetailCardData productDetailCardData =
            ProductDetailCardData.fromJson(response.data.toJson());

        Future.microtask(() {
          ref.read(productDetailCardDataProvider.notifier).state =
              productDetailCardData;

          final selectedProductNotifier = ref.read(
              selectedProductVariantsProvider(
                      productDetailNavigationData.productData.productId)
                  .notifier);
          selectedProductNotifier.updateProductDetails(
            productDetailNavigationData.productData.productId,
            productDetailNavigationData.productData.name,
            productDetailNavigationData.productData.amountPrice,
            productDetailNavigationData.productData.currencyPrice,
            productDetailNavigationData.productData.urlImage,
          );
        });

        print(
            "Updated productDetailCardDataProvider with: $productDetailCardData");
        return AsyncValue<ProductDetailCardData>.data(productDetailCardData);
      },
      loading: () {
        print("Loading product variants...");
        return const AsyncValue<ProductDetailCardData>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        print("Error loading product variants: $error");
        return AsyncValue<ProductDetailCardData>.error(error, stackTrace);
      },
    );

    final Widget detailsContent = categoryCard.when(
      data: (ProductDetailCardData data) {
        print("Product details loaded: $data");
        return MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ProductVariantSelector(
                productId: productDetailNavigationData.productData.productId,
                variants: data.toProductDetailVariantCards());
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

    final Widget complementsContent =
        categoryCard.when(data: (ProductDetailCardData data) {
      print("Product details loaded: $data");
      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ComplementSelector(
              complements: data.complements.map((complement) {
            return ProductComplement(
              complementId: complement.complementId,
              name: complement.name,
              freeAmount: complement.freeAmount,
              amountPrice: complement.amountPrice,
              currencyPrice: complement.currencyPrice,
              isSauce: complement.isSauce,
            );
          }).toList());
        },
      );
    }, loading: () {
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
    }, error: (Object error, _) {
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
    });

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
      print("Refreshing product variants...");
      await ref
          .read(productVariantNotifierProvider(
                  productDetailNavigationData.productData.productId)
              .notifier)
          .reloadData();
    }

    final Widget buttonAddProduct = ButtonAddProductVariantToCart(
        productId: productDetailNavigationData.productData.productId,
        campusData: productDetailNavigationData.campusData);

    final Widget buttonArProduct = variantsResponse.when(
      data: (BaseResponse<VariantsByProductResponse> response) {
        final nutritionalInfo = response.data.product.nutritionalInformation;
        final productInfo = response.data.product;

        return ButtonAR(
          productId: productDetailNavigationData.productData.productId,
          urlGLB: productInfo.urlGlb,
          nutritionalInformation: NutritionalInformationAR(
            calories: nutritionalInfo.calories,
            carbohydrates: nutritionalInfo.carbohydrates,
            isHighProtein: nutritionalInfo.isHighProtein,
            proteins: nutritionalInfo.proteins,
            totalFat: nutritionalInfo.totalFat,
            isLowCalories: nutritionalInfo.isLowCalories,
            isVegan: nutritionalInfo.isVegan,
            isVegetarian: nutritionalInfo.isVegetarian,
            isWithoutEggs: nutritionalInfo.isWithoutEggs,
            isWithoutGluten: nutritionalInfo.isWithoutGluten,
            isWithoutLactose: nutritionalInfo.isWithoutLactose,
            isWithoutNut: nutritionalInfo.isWithoutNut,
            isWithoutPig: nutritionalInfo.isWithoutPig,
            isWithoutSeafood: nutritionalInfo.isWithoutSeafood,
            nutritionalInformationId: nutritionalInfo.nutritionalInformationId,
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error loading AR data: $error'),
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
              buttonArProduct,
              detailsContent,
              complementsContent,
              buttonAddProduct,
            ],
          ),
        ),
      ),
    );
  }
}
