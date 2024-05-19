import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/base_response.dart';
import '../../../models/management/campus_category/campus_category.response.types.dart';
import "../../../repository/management_bc/campus_category/campus_category.repository.dart";

final StateNotifierProviderFamily<CampusCategoryNotifier,
        AsyncValue<BaseResponse<List<CampusCategoryResponse>>>, String>
    campusCategoryNotifierProvider = StateNotifierProvider.family<
        CampusCategoryNotifier,
        AsyncValue<BaseResponse<List<CampusCategoryResponse>>>,
        String>((ref, campusId) {
  final campusCategoryRepository = ref.read(campusCategoryRepositoryProvider);
  return CampusCategoryNotifier(campusId, campusCategoryRepository);
});

class CampusCategoryNotifier extends StateNotifier<
    AsyncValue<BaseResponse<List<CampusCategoryResponse>>>> {
  final String campusId;
  final CampusCategoryRepository campusCategoryRepository;
  final Map<int, List<CampusCategoryResponse>> cachedPages = {};
  int lastPage = 0;
  static const int _pageSize = 5;

  CampusCategoryNotifier(this.campusId, this.campusCategoryRepository)
      : super(const AsyncLoading());

  Future<void> loadData() async {
    if (cachedPages.isNotEmpty) {
      final List<CampusCategoryResponse> allCachedData =
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

  Future<BaseResponse<List<CampusCategoryResponse>>> fetchData(
      int pageNumber, int pageSize) async {
    if (cachedPages.containsKey(pageNumber)) {
      final BaseResponse<List<CampusCategoryResponse>> response = BaseResponse(
        code: 'SUCCESS',
        data: cachedPages[pageNumber]!,
      );
      state = AsyncData(response);
      return response;
    }
    try {
      final BaseResponse<List<CampusCategoryResponse>> response =
          await campusCategoryRepository.getCategoriesByCampus(
        campusId: campusId,
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
