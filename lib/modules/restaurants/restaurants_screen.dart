import "../../layout/main_layout.dart";
import "../../layout/scrollable_layout.dart";
import "../../mock/menu/mock_header/mock_header.dart";
import "../../mock/menu/mock_restaurant_card/mock_restaurant_card.dart";
import "../../shared/widgets/features/restaurant-card/restaurant_card.dart";
import "../../shared/widgets/global/header/full_header.dart";
import "../../shared/widgets/global/theme_switcher/theme_switcher.dart";
import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../shared/widgets/features/restaurant-card/restaurant_card.types.dart";

import "../../shared/widgets/global/header/header.types.dart";

class RestaurantsScreen extends ConsumerWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<RestaurantCardData>> categoryCard = ref.watch(restaurantCardProvider);
    final AsyncValue<HeaderFullData> headerData = ref.watch(headerProvider);
    //final headerIconData = ref.watch(headerProviderIcon);

    final PersistentTabController controller =
        PersistentTabController();

    final Widget gridContent = categoryCard.when(
      data: (List<RestaurantCardData> dataList) => AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return CRestaurantCard(data: dataList[index]);
        },
      ),
      loading: () => MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return const CRestaurantCard.skeleton();
        },
      ),
      error: (Object error, _) => MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return CRestaurantCard.error(error: error.toString());
        },
      ),
    );

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
          header: headerData.when(
            data: (HeaderFullData data) =>
                CBaseFullHeader(data: data, idDialogProvider: data.aboutInfoId),
            loading: () => const CBaseFullHeader.skeleton(),
            error: (_, __) =>
                const CBaseFullHeader.error(error: "Error fetching data"),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 50),
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
