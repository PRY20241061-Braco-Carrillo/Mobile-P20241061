import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/base_response.dart';
import '../../../models/management/restaurant/restaurant.response.types.dart';
import '../../../repository/management_bc/restaurant/restaurants.repository.dart';

class RestaurantNotifier
    extends StateNotifier<AsyncValue<BaseResponse<List<RestaurantResponse>>>> {
  final RestaurantRepository repository;
  final Map<int, List<RestaurantResponse>> cachedPages = {};
  int lastPage = 0;
  static const int _pageSize = 3;

  RestaurantNotifier(this.repository) : super(const AsyncLoading());

  Future<void> loadData() async {
    if (cachedPages.isNotEmpty) {
      final List<RestaurantResponse> allCachedData =
          cachedPages.values.expand((page) => page).toList();
      state = AsyncData(BaseResponse(code: 'SUCCESS', data: allCachedData));
      return;
    }
    try {
      await fetchData(0, _pageSize);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<BaseResponse<List<RestaurantResponse>>> fetchData(
      int pageNumber, int pageSize) async {
    if (cachedPages.containsKey(pageNumber)) {
      final BaseResponse<List<RestaurantResponse>> response = BaseResponse(
        code: 'SUCCESS',
        data: cachedPages[pageNumber]!,
      );
      state = AsyncData(response);
      return response;
    }
    try {
      final BaseResponse<List<RestaurantResponse>> response =
          await repository.getRestaurants(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      cachedPages[pageNumber] = response.data;
      lastPage = pageNumber;
      state = AsyncData(response);
      return response;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> reloadData() async {
    cachedPages.clear();
    lastPage = 0;
    await loadData();
  }
}

final StateNotifierProvider<RestaurantNotifier,
        AsyncValue<BaseResponse<List<RestaurantResponse>>>>
    restaurantNotifierProvider = StateNotifierProvider<RestaurantNotifier,
        AsyncValue<BaseResponse<List<RestaurantResponse>>>>((ref) {
  final RestaurantRepository repository =
      ref.read(restaurantRepositoryProvider);
  return RestaurantNotifier(repository);
});
