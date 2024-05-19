import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../config/routes/routes.dart';
import '../../core/models/base_response.dart';
import '../../core/models/management/campus_category/campus_category.response.types.dart';
import '../../core/notifiers/management/campus_category/campus_category.notifier.dart';
import '../../layout/base_layout.dart';
import '../../shared/widgets/features/campus-card/campus_card.types.dart';
import '../../shared/widgets/features/category-button/category_button.dart';
import '../../shared/widgets/features/category-button/category_button.types.dart';
import '../../shared/widgets/features/header/category-header/restaurant_categories_header.dart';
import '../../shared/widgets/global/theme_switcher/theme_switcher.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  final CampusCardData campusData;

  const CategoriesScreen({super.key, required this.campusData});

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  static const int _pageSize = 5;
  final PagingController<int, CategoryButtonData> _pagingController =
      PagingController<int, CategoryButtonData>(firstPageKey: 0);

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
    final notifier = ref.read(
        campusCategoryNotifierProvider(widget.campusData.campusId).notifier);
    await notifier.loadData();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final BaseResponse<List<CampusCategoryResponse>> response = await ref
          .read(campusCategoryNotifierProvider(widget.campusData.campusId)
              .notifier)
          .fetchData(pageKey, _pageSize);
      final List<CategoryButtonData> newItems =
          response.data.map(_mapCampusCategoryToCardData).toList();
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
                CBaseRestaurantCategoriesHeader(
                  campusCardData: widget.campusData,
                  height: 220,
                  idDialogProvider: widget.campusData.campusId,
                  onButtonPressed: (BuildContext context) {
                    GoRouter.of(context).push(
                        "${AppRoutes.campus}/${widget.campusData.restaurantId}");
                  },
                ),
                const SizedBox(height: 5.0),
                const ThemeSwitcherWidget(),
                const SizedBox(height: 10),
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
                      child: PagedListView<int, CategoryButtonData>(
                        pagingController: _pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<CategoryButtonData>(
                          itemBuilder: (BuildContext context,
                                  CategoryButtonData item, int index) =>
                              CCategoryButton(
                                  data: item, campusData: widget.campusData),
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

  CategoryButtonData _mapCampusCategoryToCardData(
      CampusCategoryResponse response) {
    return CategoryButtonData(
      name: response.name,
      campusCategoryId: response.campusCategoryId,
      urlImage: response.urlImage,
    );
  }
}
