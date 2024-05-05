import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../config/routes/routes.dart";
import "../../core/models/base_response.dart";
import "../../core/models/management/campus/campus.response.types.dart";
import "../../core/notifiers/management/campus/campus.notifier.dart";
import "../../layout/main_layout.dart";
import "../../layout/scrollable_layout.dart";

import "../../shared/widgets/features/campus-card/campus_card.dart";
import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../shared/widgets/global/header/icon_header.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";

class CampusScreen extends ConsumerWidget {
  final String restaurantId;

  const CampusScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BaseResponse<List<CampusResponse>>> restaurantResponse =
        ref.watch(campusNotifierProvider(restaurantId));

    final AsyncValue<List<CampusCardData>> categoryCard =
        restaurantResponse.when(
      data: (BaseResponse<List<CampusResponse>> response) {
        return AsyncValue<List<CampusCardData>>.data(
            response.data.map(_mapRestaurantToCardData).toList());
      },
      loading: () {
        return const AsyncValue<List<CampusCardData>>.loading();
      },
      error: (Object error, StackTrace stackTrace) {
        return AsyncValue<List<CampusCardData>>.error(error, stackTrace);
      },
    );

    final PersistentTabController controller = PersistentTabController();

    final Widget gridContent = categoryCard.when(
      data: (List<CampusCardData> dataList) {
        return AlignedGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return CCampusCard(data: dataList[index]);
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
            return const CCampusCard.skeleton();
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
            return CCampusCard.error(error: error.toString());
          },
        );
      },
    );

    Future<void> handleRefresh(WidgetRef ref, String restaurantId) async {
      await ref
          .read(campusNotifierProvider(restaurantId).notifier)
          .reloadData();
    }

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          context.go(AppRoutes.home);
        }
        return true;
      },
      child: MainLayout(
        tabController: controller,
        body: ScrollableLayout(
          onRefresh: () => handleRefresh(ref, restaurantId),
          header: CBaseIconHeader(
            headerKey: "campus",
            height: 220,
            onButtonPressed: (BuildContext context) {
              context.go(AppRoutes.home);
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

  CampusCardData _mapRestaurantToCardData(CampusResponse response) {
    return CampusCardData(
      name: response.name,
      address: response.address,
      campusId: response.campusId,
      isAvailable: response.isAvailable,
      restaurantId: response.restaurantId,
      openHour: response.openHour,
      phoneNumber: response.phoneNumber,
      toDelivery: response.toDelivery,
      toTakeHome: response.toTakeHome,
      imageUrl: response.imageUrl,
      logoUrl: response.logoUrl,
    );
  }
}
