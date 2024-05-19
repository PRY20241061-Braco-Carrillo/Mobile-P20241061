import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/base_response.dart';
import '../../../models/management/campus/campus.response.types.dart';
import '../../../repository/management_bc/campus/campus.repository.dart';

class CampusNotifier
    extends StateNotifier<AsyncValue<BaseResponse<List<CampusResponse>>>> {
  final CampusRepository repository;
  final String restaurantId;
  final Map<int, List<CampusResponse>> cachedPages = {};
  int lastPage = 0;
  static const int _pageSize = 6;

  CampusNotifier(this.repository, this.restaurantId)
      : super(const AsyncLoading());

  Future<void> loadData() async {
    if (cachedPages.isNotEmpty) {
      final List<CampusResponse> allCachedData =
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

  Future<BaseResponse<List<CampusResponse>>> fetchData(
      int pageNumber, int pageSize) async {
    if (cachedPages.containsKey(pageNumber)) {
      final BaseResponse<List<CampusResponse>> response = BaseResponse(
        code: 'SUCCESS',
        data: cachedPages[pageNumber]!,
      );
      state = AsyncData(response);
      return response;
    }
    try {
      final BaseResponse<List<CampusResponse>> response =
          await repository.getCampusByRestaurantId(
        restaurantId: restaurantId,
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

final StateNotifierProviderFamily<CampusNotifier,
        AsyncValue<BaseResponse<List<CampusResponse>>>, String>
    campusNotifierProvider = StateNotifierProvider.family<
        CampusNotifier,
        AsyncValue<BaseResponse<List<CampusResponse>>>,
        String>((ref, restaurantId) {
  final CampusRepository repository = ref.read(campusRepositoryProvider);
  return CampusNotifier(repository, restaurantId);
});
