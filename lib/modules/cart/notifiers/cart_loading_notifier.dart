import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartLoadingNotifier extends StateNotifier<bool> {
  CartLoadingNotifier() : super(false);

  void startLoading() => state = true;
  void stopLoading() => state = false;
}

final StateNotifierProvider<CartLoadingNotifier, bool> cartLoadingProvider =
    StateNotifierProvider<CartLoadingNotifier, bool>(
        (StateNotifierProviderRef<CartLoadingNotifier, bool> ref) {
  return CartLoadingNotifier();
});
