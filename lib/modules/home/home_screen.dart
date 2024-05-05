import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/managers/secure_storage_manager.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/restaurant/restaurant.response.types.dart";
import "../../core/notifiers/management/restaurant/restaurant.notifier.dart";
import "../../layout/main_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../shared/widgets/features/restaurant-card/restaurant_card.dart";
import "../../shared/widgets/features/restaurant-card/restaurant_card.types.dart";
import "../../shared/widgets/global/header/icon_header.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SecureStorageManager storageManager =
        ref.watch(secureStorageProvider);

    final AsyncValue<BaseResponse<List<RestaurantResponse>>>
        restaurantResponse = ref.watch(allRestaurantsNotifierProvider);

    final AsyncValue<List<RestaurantCardData>> categoryCard =
        restaurantResponse.when(
      data: (BaseResponse<List<RestaurantResponse>> response) {
        return AsyncValue<List<RestaurantCardData>>.data(
            response.data.map(_mapRestaurantToCardData).toList());
      },
      loading: () {
        return const AsyncValue<List<RestaurantCardData>>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<List<RestaurantCardData>>.error(error, stackTrace);
      },
    );

    final PersistentTabController controller = PersistentTabController();

    final Widget gridContent = categoryCard.when(
      data: (List<RestaurantCardData> dataList) {
        return AlignedGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return CRestaurantCard(data: dataList[index]);
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
            return const CRestaurantCard.skeleton();
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
            return CRestaurantCard.error(error: error.toString());
          },
        );
      },
    );

    Future<void> handleRefresh(
      WidgetRef ref,
    ) async {
      await ref.read(allRestaurantsNotifierProvider.notifier).reloadData();
    }

    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (!didPop && controller.index != 0) {
          controller.jumpToTab(0);
        }
      },
      child: MainLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref),
          header: FutureBuilder<bool>(
            future: storageManager.isAuthenticated(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final bool isNotAuth = !snapshot.data!;
                return CBaseIconHeader(
                  headerKey: "home",
                  height: 220,
                  returnButton: isNotAuth,
                  onButtonPressed: isNotAuth
                      ? (BuildContext context) {
                          context.go(AppRoutes.accessOptions);
                        }
                      : null,
                );
              } else {
                return const SizedBox.shrink();
              }
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

  RestaurantCardData _mapRestaurantToCardData(RestaurantResponse response) {
    return RestaurantCardData(
      name: response.name,
      logoUrl: response.logoUrl,
      imageUrl: response.imageUrl,
      isAvailable: response.isAvailable,
      restaurantId: response.restaurantId,
    );
  }
}
