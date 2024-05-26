import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/models/management/menu/menu_detail.response.types.dart";
import "../../../core/notifiers/management/menu/menu_detail.notifier.dart";
import "../../../layout/base_layout.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../../shared/widgets/features/product-card/buttons/button_product.dart";
import "../../../shared/widgets/features/product-card/menus/menus_detail-card/menu_selector/menu_selector.dart";
import "../../../shared/widgets/features/product-card/menus/menus_detail-card/menus_detail.dart";
import "../../../shared/widgets/features/product-card/menus/menus_detail-card/menus_detail.types.dart";
import "../../../shared/widgets/features/product-card/products/product_detail-card/product_detail.types.dart";
import "../../../shared/widgets/features/product-card/products/product_detail-card/variants/variant_detail.dart";
import "../../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "menu_detail_navigation_data.types.dart";

class MenusDetailScreen extends ConsumerWidget {
  final MenuDetailNavigationData menuDetailNavigationData;

  const MenusDetailScreen({super.key, required this.menuDetailNavigationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersistentTabController controller = PersistentTabController();
    /*final AsyncValue<BaseResponse<MenuDetailResponse>> menuDetailResponse =
        ref.watch(menuDetailNotifierProvider(
            menuDetailNavigationData.productData.productId));

    final ProductVariant? selectedVariant =
        ref.watch(selectedProductVariantProvider);

    final AsyncValue<MenuDetailCardData> categoryCard = menuDetailResponse.when(
      data: (BaseResponse<MenuDetailResponse> response) {
        return AsyncValue<MenuDetailCardData>.data(
            MenuDetailCardData.fromJson(response.data.toJson()));
      },
      loading: () {
        return const AsyncValue<MenuDetailCardData>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<MenuDetailCardData>.error(error, stackTrace);
      },
    );*/

    const Widget detailsContent = MenuSelectorType();

    final Widget menuContent = MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      mainAxisSpacing: 10,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return CMenuDetailCard(
          menuDetailCardData: menuDetailNavigationData.productData,
        );
      },
    );

    Future<void> handleRefresh(WidgetRef ref) async {
      await ref
          .read(menuDetailNotifierProvider(
                  menuDetailNavigationData.productData.productId)
              .notifier)
          .loadData();
    }

    final Widget buttonAddProduct = ButtonProduct(
      productId: menuDetailNavigationData.productData.productId,
    );

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          await GoRouter.of(context).push(
              "${AppRoutes.categories}${AppRoutes.menu}/${menuDetailNavigationData.campusData.campusId}",
              extra: menuDetailNavigationData.campusData);
        }
        return true;
      },
      child: BaseLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: CBaseProductCategoriesHeader(
            title: menuDetailNavigationData.productData.name,
            height: 220,
            onButtonPressed: (BuildContext context) {
              GoRouter.of(context).push(
                  "${AppRoutes.categories}${AppRoutes.menu}/${menuDetailNavigationData.campusData.campusId}",
                  extra: menuDetailNavigationData.campusData);
            },
            fontSize: 32,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              const ThemeSwitcherWidget(),
              const SizedBox(height: 10),
              menuContent,
              /*if (selectedVariant != null)
                Text(
                    "Price: \$${selectedVariant.amountPrice.toStringAsFixed(2)}"),*/
              detailsContent,
              //buttonAddProduct,
            ],
          ),
        ),
      ),
    );
  }
}
