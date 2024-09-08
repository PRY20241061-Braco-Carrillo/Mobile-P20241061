import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/campus/campus.response.types.dart";
import "../../core/notifiers/management/campus/campus.notifier.dart";
import "../../layout/base_layout.dart";
import "../../shared/widgets/features/campus-card/campus_card.dart";
import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../shared/widgets/global/header/icon_header.dart";

class CampusScreen extends ConsumerStatefulWidget {
  final String restaurantId;

  const CampusScreen({super.key, required this.restaurantId});

  @override
  CampusScreenState createState() => CampusScreenState();
}

class CampusScreenState extends ConsumerState<CampusScreen> {
  static const int _pageSize = 6;
  final PagingController<int, CampusCardData> _pagingController =
      PagingController<int, CampusCardData>(firstPageKey: 0);
  static const String no_items = "no_items.label";
  static const String no_more_items = "no_more_items.label";
  static const String failed_to_load = "failed_to_load.label";

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
    final CampusNotifier notifier =
        ref.read(campusNotifierProvider(widget.restaurantId).notifier);
    await notifier.loadData();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final BaseResponse<List<CampusResponse>> response = await ref
          .read(campusNotifierProvider(widget.restaurantId).notifier)
          .fetchData(pageKey, _pageSize);
      final List<CampusCardData> newItems =
          response.data.map(_mapCampusToCardData).toList();
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

    return BaseLayout(
      tabController: controller,
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: <Widget>[
                CBaseIconHeader(
                  headerKey: "campus",
                  height: 220,
                  onButtonPressed: (BuildContext context) {
                    GoRouter.of(context).push(AppRoutes.tabScreen);
                  },
                ),
                const SizedBox(height: 5.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await ref
                            .read(campusNotifierProvider(widget.restaurantId)
                                .notifier)
                            .reloadData();
                        _pagingController.refresh();
                      },
                      child: PagedListView<int, CampusCardData>(
                        pagingController: _pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<CampusCardData>(
                          itemBuilder: (BuildContext context,
                                  CampusCardData item, int index) =>
                              CCampusCard(data: item),
                          firstPageProgressIndicatorBuilder:
                              (BuildContext context) => const Center(
                                  child: CircularProgressIndicator()),
                          newPageProgressIndicatorBuilder:
                              (BuildContext context) => const Center(
                                  child: CircularProgressIndicator()),
                          noMoreItemsIndicatorBuilder: (BuildContext context) =>
                              Center(child: Text(no_more_items.tr())),
                          firstPageErrorIndicatorBuilder:
                              (BuildContext context) =>
                                  Center(child: Text(no_items.tr())),
                          newPageErrorIndicatorBuilder:
                              (BuildContext context) =>
                                  Center(child: Text(failed_to_load.tr())),
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

  CampusCardData _mapCampusToCardData(CampusResponse response) {
    return CampusCardData(
      name: response.name,
      address: response.address,
      campusId: response.campusId,
      isAvailable: response.isAvailable,
      restaurantId: response.restaurant.restaurantId,
      openHour: response.openHour,
      phoneNumber: response.phoneNumber,
      toDelivery: response.toDelivery,
      toTakeHome: response.toTakeHome,
      imageUrl: response.urlImage,
      logoUrl: response.restaurant.logoUrl,
    );
  }
}
