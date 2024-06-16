import "dart:async";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/managers/secure_storage_manager.dart";
import "../../../core/models/order/order_request/saver_order_request.response.types.dart";

final StateNotifierProvider<OrderInProgressNotifier, OrderInProgressState>
    orderInProgressProvider =
    StateNotifierProvider<OrderInProgressNotifier, OrderInProgressState>(
        (StateNotifierProviderRef<OrderInProgressNotifier, OrderInProgressState>
            ref) {
  final SecureStorageManager storageService = ref.read(secureStorageProvider);
  return OrderInProgressNotifier(storageService);
});

class OrderInProgressNotifier extends StateNotifier<OrderInProgressState> {
  final SecureStorageManager _storageService;
  Timer? _timer;

  OrderInProgressNotifier(this._storageService)
      : super(OrderInProgressState(
            false,
            "",
            300,
            "",
            SaveOrderRequestResponse(
                confirmationToken: "", orderRequestId: "", totalPrice: 0.0))) {
    _loadOrderInProgress();
  }

  Future<void> _loadOrderInProgress() async {
    final bool inProgress = await _storageService.getOrderInProgress();
    final String? token = await _storageService.getOrderConfirmationToken();
    final int remainingTime = await _storageService.getOrderRemainingTime();
    final String? orderId = await _storageService.getOrderId();

    print('Loading order in progress...');
    print(
        'inProgress: $inProgress, token: $token, remainingTime: $remainingTime, orderId: $orderId');

    if (inProgress) {
      _startTimer(remainingTime);
    }
    state = OrderInProgressState(
        inProgress,
        token ?? "",
        remainingTime,
        orderId ?? "",
        SaveOrderRequestResponse(
            confirmationToken: "", orderRequestId: "", totalPrice: 0.0));
  }

  void _startTimer(int initialTime) {
    state = state.copyWith(remainingTime: initialTime);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (state.remainingTime <= 0) {
        timer.cancel();
        clearOrderInProgress();
      } else {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
        _storageService.setOrderRemainingTime(state.remainingTime);
      }
    });
  }

  Future<void> setOrderInProgress(bool inProgress,
      {String? token,
      String? orderId,
      SaveOrderRequestResponse? orderRequest}) async {
    state = state.copyWith(
        inProgress: inProgress,
        token: token ?? state.token,
        orderId: orderId ?? state.orderId,
        orderRequestNavigationData:
            orderRequest ?? state.orderRequestNavigationData);

    print('Setting order in progress...');
    print('inProgress: $inProgress, token: $token, orderId: $orderId');

    await _storageService.setOrderInProgress(inProgress);
    if (token != null) {
      await _storageService.setOrderConfirmationToken(token);
    }
    if (orderId != null) {
      await _storageService.setOrderId(orderId);
    }
    if (inProgress) {
      _startTimer(state.remainingTime);
    } else {
      _timer?.cancel();
      await _storageService.setOrderRemainingTime(300); // Reset the timer
    }
  }

  Future<void> clearOrderInProgress() async {
    state = OrderInProgressState(
        false,
        '',
        300,
        '',
        SaveOrderRequestResponse(
            confirmationToken: "", orderRequestId: "", totalPrice: 0.0));
    _timer?.cancel();

    print('Clearing order in progress...');

    await _storageService.setOrderInProgress(false);
    await _storageService.setOrderConfirmationToken('');
    await _storageService.setOrderId('');
    await _storageService.setOrderRemainingTime(300);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class OrderInProgressState {
  final bool inProgress;
  final String token;
  final int remainingTime;
  final String orderId;
  final SaveOrderRequestResponse orderRequestNavigationData;

  OrderInProgressState(
    this.inProgress,
    this.token,
    this.remainingTime,
    this.orderId,
    this.orderRequestNavigationData,
  );

  OrderInProgressState copyWith({
    bool? inProgress,
    String? token,
    int? remainingTime,
    String? orderId,
    SaveOrderRequestResponse? orderRequestNavigationData,
  }) {
    return OrderInProgressState(
      inProgress ?? this.inProgress,
      token ?? this.token,
      remainingTime ?? this.remainingTime,
      orderId ?? this.orderId,
      orderRequestNavigationData ?? this.orderRequestNavigationData,
    );
  }
}
