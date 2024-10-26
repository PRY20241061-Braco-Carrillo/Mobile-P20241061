import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/managers/secure_storage_manager.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/campus_category/campus_category.response.types.dart";
import "../../core/notifiers/management/campus_category/campus_category.notifier.dart";
import "../../layout/base_layout.dart";
import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../shared/widgets/features/category-button/category_button.dart";
import "../../shared/widgets/features/category-button/category_button.types.dart";
import "../../shared/widgets/features/category-button/category_simple_button.dart";
import "../../shared/widgets/features/header/category-header/restaurant_categories_header.dart";

class CategoriesScreen extends ConsumerStatefulWidget {
  final CampusCardData campusData;
  static const String promotions = "Promotions";
  static const String menu = "Menu";
  static const String combo = "Combo";

  const CategoriesScreen({super.key, required this.campusData});

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  static const int _pageSize = 5;
  static const String no_items = "no_items.label";
  static const String no_more_items = "no_more_items.label";
  static const String failed_to_load = "failed_to_load.label";

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
    _setCampusId();
  }

  Future<void> _setCampusId() async {
    await ref
        .read(secureStorageProvider)
        .setCampusId(widget.campusData.campusId);
  }

  Future<void> _fetchInitialData() async {
    final CampusCategoryNotifier notifier = ref.read(
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
                const SizedBox(height: 10),
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
                        _pagingController.refresh();
                      },
                      child: PagedListView<int, CategoryButtonData>(
                        pagingController: _pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<CategoryButtonData>(
                          itemBuilder: (BuildContext context,
                              CategoryButtonData item, int index) {
                            final bool showPromotion =
                                item.is_promotion ?? false;
                            final bool showMenu = item.is_menu ?? false;
                            final bool showCombo = item.is_combo ?? false;

                            if (index == 0 &&
                                (showPromotion || showMenu || showCombo)) {
                              return Column(
                                children: <Widget>[
                                  if (showPromotion)
                                    CategorySimpleButton(
                                      title: CategoriesScreen.promotions,
                                      path:
                                          "${AppRoutes.categories}${AppRoutes.promotions}/${widget.campusData.campusId}",
                                      campusData: widget.campusData,
                                    ),
                                  if (showMenu)
                                    CategorySimpleButton(
                                      title: CategoriesScreen.menu,
                                      path:
                                          "${AppRoutes.categories}${AppRoutes.menu}/${widget.campusData.campusId}",
                                      campusData: widget.campusData,
                                    ),
                                  if (showCombo)
                                    CategorySimpleButton(
                                      title: CategoriesScreen.combo,
                                      path:
                                          "${AppRoutes.categories}${AppRoutes.combos}/${widget.campusData.campusId}",
                                      campusData: widget.campusData,
                                    ),
                                  // El botón de categoría normal
                                  CCategoryButton(
                                    data: item,
                                    campusData: widget.campusData,
                                  ),
                                ],
                              );
                            } else {
                              return CCategoryButton(
                                data: item,
                                campusData: widget.campusData,
                              );
                            }
                          },
                          firstPageProgressIndicatorBuilder:
                              (BuildContext context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          newPageProgressIndicatorBuilder:
                              (BuildContext context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          noMoreItemsIndicatorBuilder: (BuildContext context) =>
                              Center(
                            child: Text(no_more_items.tr()),
                          ),
                          firstPageErrorIndicatorBuilder:
                              (BuildContext context) => Center(
                            child: Text(failed_to_load.tr()),
                          ),
                          newPageErrorIndicatorBuilder:
                              (BuildContext context) => Center(
                            child: Text(failed_to_load.tr()),
                          ),
                          noItemsFoundIndicatorBuilder:
                              (BuildContext context) => Center(
                            child: Text(no_items.tr()),
                          ),
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
      is_promotion: response.isPromotion,
      is_combo: response.isCombo,
      is_menu: response.isMenu,
    );
  }
}
