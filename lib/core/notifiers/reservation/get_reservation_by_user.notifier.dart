import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../../models/base_response.dart";
import "../../models/reservation/reservation_by_user.response.types.dart";
import "../../repository/reservation_bc/reservation_repository.dart";

final StateNotifierProviderFamily<ReservationNotifier,
        AsyncValue<BaseResponse<List<ReservationsResponseByUserId>>>, String>
    getReservationByUserNotifierProvider = StateNotifierProvider.family<
        ReservationNotifier,
        AsyncValue<BaseResponse<List<ReservationsResponseByUserId>>>,
        String>((ref, userId) {
  final reservationRepository = ref.read(reservationRepositoryProvider);
  return ReservationNotifier(userId, reservationRepository);
});

class ReservationNotifier extends StateNotifier<
    AsyncValue<BaseResponse<List<ReservationsResponseByUserId>>>> {
  final String userId;
  final ReservationRepository reservationRepository;
  final Map<int, List<ReservationsResponseByUserId>> cachedPages = {};
  int lastPage = 0;
  static const int _pageSize = 5;

  ReservationNotifier(this.userId, this.reservationRepository)
      : super(const AsyncLoading()) {
    loadData(); // Llama al método loadData al inicializar el Notifier
  }

  Future<void> loadData() async {
    if (cachedPages.isNotEmpty) {
      final List<ReservationsResponseByUserId> allCachedData =
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

  Future<BaseResponse<List<ReservationsResponseByUserId>>> fetchData(
      int pageNumber, int pageSize) async {
    if (cachedPages.containsKey(pageNumber)) {
      final BaseResponse<List<ReservationsResponseByUserId>> response =
          BaseResponse(
        code: 'SUCCESS',
        data: cachedPages[pageNumber]!,
      );
      state = AsyncData(response);
      return response;
    }
    try {
      final BaseResponse<List<ReservationsResponseByUserId>> response =
          await reservationRepository.getAllReservationByUserId(userId);
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
