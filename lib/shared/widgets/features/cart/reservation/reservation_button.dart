import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/quickalert.dart';

import "../../../../../config/routes/routes.dart";
import "../../../../../core/managers/secure_storage_manager.dart";
import "../../../../../core/models/base_response.dart";
import "../../../../../core/models/reservation/save_reservation.request.types.dart";

import "../../../../../core/notifiers/reservation/save_reservation_request.notifier.dart";

import "../../../../../modules/cart/notifiers/cart_loading_notifier.dart";
import "../order_cart/order_cart.types.dart";

class ReservationButton extends ConsumerWidget {
  const ReservationButton({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  final List<CartItem> cartItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLoginData = ref.watch(authDataProvider);

    return asyncLoginData.when(
      data: (loginData) {
        final userId = loginData[SecureStorageManager.keyUserId] ?? "";
        final campusId = loginData[SecureStorageManager.keyCampusId] ?? "";

        final reservationRequest = SaveReservationRequest(
          userId: userId,
          campusId: campusId,
          order: Order(
            products: cartItems.map((item) {
              return OrderProduct(
                productVariantId: item
                    .productInfo.selectedProductVariants.first.productVariantId,
                productAmount: item.quantity,
                unitPrice:
                    item.productInfo.selectedProductVariants.first.amountPrice,
              );
            }).toList(),
          ),
        );

        ref.listen<AsyncValue<BaseResponse<String>>>(
          reservationNotifierProvider(reservationRequest),
          (previous, next) {
            next.when(
              data: (response) async {
                ref.read(cartLoadingProvider.notifier).stopLoading();
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: "Reserva realizada exitosamente!",
                    onConfirmBtnTap: () {
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop();
                      } else {
                        GoRouter.of(context).go(AppRoutes.home);
                      }
                    },
                  );
                }
              },
              loading: () {
                ref.read(cartLoadingProvider.notifier).startLoading();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
              error: (Object error, _) {
                ref.read(cartLoadingProvider.notifier).stopLoading();
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text:
                        "Error al realizar la reserva. Por favor, inténtelo nuevamente.",
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                }
              },
            );
          },
        );

        return ElevatedButton(
          onPressed: () async {
            final reservationNotifier = ref
                .read(reservationNotifierProvider(reservationRequest).notifier);
            await reservationNotifier.saveReservation();
          },
          child: const Text("Realizar reserva"),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text("Error loading login data: $error"),
    );
  }
}
