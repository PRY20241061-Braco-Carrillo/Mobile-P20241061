/*


class HomeWidget extends ConsumerWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryCard = ref.watch(restaurantCardProvider);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          const ThemeSwitcherWidget(),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: categoryCard.when(
                data: (dataList) => AlignedGridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 0,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return CRestaurantCard(data: dataList[index]);
                  },
                ),
                loading: () => MasonryGridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 0,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return const CRestaurantCard.skeleton();
                  },
                ),
                error: (error, _) => MasonryGridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 0,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return CRestaurantCard.error(error: error.toString());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



*/