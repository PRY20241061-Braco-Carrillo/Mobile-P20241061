import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:go_router/go_router.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../core/managers/secure_storage_manager.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/restaurant/restaurant.response.types.dart";
import "../../core/notifiers/management/restaurant/restaurant.notifier.dart";
import "../../layout/main_layout.dart";
import "../../shared/widgets/features/restaurant-card/restaurant_card.dart";
import "../../shared/widgets/features/restaurant-card/restaurant_card.types.dart";
import "../../shared/widgets/global/header/icon_header.dart";
import "../../config/routes/routes.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  static const int _pageSize = 3;
  final PagingController<int, RestaurantCardData> _pagingController =
      PagingController<int, RestaurantCardData>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((int pageKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchPage(pageKey);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  Future<void> _fetchInitialData() async {
    final RestaurantNotifier notifier =
        ref.read(restaurantNotifierProvider.notifier);
    await notifier.loadData();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final BaseResponse<List<RestaurantResponse>> response = await ref
          .read(restaurantNotifierProvider.notifier)
          .fetchData(pageKey, _pageSize);
      final List<RestaurantCardData> newItems =
          response.data.map(_mapRestaurantToCardData).toList();
      final bool isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final int nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } on Exception catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController();

    return MainLayout(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: <Widget>[
                FutureBuilder<bool>(
                  future: ref.watch(secureStorageProvider).isAuthenticated(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final bool isNotAuth = !snapshot.data!;
                      return CBaseIconHeader(
                        headerKey: "home",
                        height: 220,
                        returnButton: isNotAuth,
                        onButtonPressed: isNotAuth
                            ? (BuildContext context) {
                                GoRouter.of(context)
                                    .push(AppRoutes.accessOptions);
                              }
                            : null,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 5.0),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _pagingController.refresh();
                      },
                      child: PagedListView<int, RestaurantCardData>(
                        pagingController: _pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<RestaurantCardData>(
                          itemBuilder: (BuildContext context,
                                  RestaurantCardData item, int index) =>
                              CRestaurantCard(data: item),
                          firstPageProgressIndicatorBuilder:
                              (BuildContext context) => const Center(
                                  child: CircularProgressIndicator()),
                          newPageProgressIndicatorBuilder:
                              (BuildContext context) => const Center(
                                  child: CircularProgressIndicator()),
                          noMoreItemsIndicatorBuilder: (BuildContext context) =>
                              const Center(child: Text("No more items")),
                          firstPageErrorIndicatorBuilder:
                              (BuildContext context) => const Center(
                                  child: Text("Failed to load items")),
                          newPageErrorIndicatorBuilder:
                              (BuildContext context) => const Center(
                                  child: Text("Failed to load more items")),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
