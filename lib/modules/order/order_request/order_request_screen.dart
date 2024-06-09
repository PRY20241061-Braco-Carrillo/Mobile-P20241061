import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quickalert/quickalert.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/notifiers/order/order/token_has_been_validated.notifier.dart";
import "../../../core/notifiers/order/order_request/cancel_order_request.notifier.dart";
import "../../../shared/widgets/order/order_progress/confirmation_token.dart";
import "../../../shared/widgets/order/order_progress/order_cancel_order_state.dart";
import "../../../shared/widgets/order/order_progress/order_validation_status.dart";
import "../../../shared/widgets/order/order_progress/remaining_time.dart";
import 'providers/order_in_progress.notifier.dart';

class OrderLoadingNotifier extends StateNotifier<bool> {
  OrderLoadingNotifier() : super(false);

  void startLoading() => state = true;
  void stopLoading() => state = false;
}

final orderLoadingProvider =
    StateNotifierProvider<OrderLoadingNotifier, bool>((ref) {
  return OrderLoadingNotifier();
});

class OrderRequestScreen extends ConsumerWidget {
  final String confirmationToken;

  const OrderRequestScreen({super.key, required this.confirmationToken});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrderInProgressState orderState = ref.watch(orderInProgressProvider);
    final int remainingTime = orderState.remainingTime;
    final AsyncValue<BaseResponse<String>> cancelOrderState =
        ref.watch(cancelOrderRequestNotifierProvider);

    void handleExpiredOrder() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text:
            'El tiempo de expiración del token ya venció. Por favor, genere su orden nuevamente.',
        onConfirmBtnTap: () {
          if (GoRouter.of(context).canPop()) {
            GoRouter.of(context).pop();
          } else {
            GoRouter.of(context).go(AppRoutes.cart);
          }
        },
      );
    }

    Future<void> cancelOrder(BuildContext context, WidgetRef ref) async {
      if (orderState.inProgress &&
          orderState.remainingTime > 0 &&
          orderState.token.isNotEmpty) {
        await ref
            .read(cancelOrderRequestNotifierProvider.notifier)
            .cancelOrder(orderState.orderId);
      } else {
        handleExpiredOrder();
      }
    }

    Future<void> refreshValidation(BuildContext context, WidgetRef ref) async {
      await ref
          .read(validateTokenNotifierProvider(orderState.orderId).notifier)
          .validateToken();
    }

    ref.listen<AsyncValue<BaseResponse<String>>>(
      cancelOrderRequestNotifierProvider,
      (previous, next) {
        next.when(
          data: (BaseResponse<String> response) {
            ref.read(orderLoadingProvider.notifier).stopLoading();
            Navigator.of(context).pop(); // Cierra el diálogo de carga
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Order has been cancelled successfully!',
              onConfirmBtnTap: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                } else {
                  GoRouter.of(context).go(AppRoutes.cart);
                }
              },
            ).then((_) {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              } else {
                GoRouter.of(context).go(AppRoutes.cart);
              }
            });
          },
          loading: () {
            ref.read(orderLoadingProvider.notifier).startLoading();
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
            ref.read(orderLoadingProvider.notifier).stopLoading();
            Navigator.of(context).pop(); // Cierra el diálogo de carga
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text:
                  'Error al cancelar la orden. Por favor, inténtelo nuevamente.',
              onConfirmBtnTap: () {
                Navigator.pop(context);
              },
            ).then((_) {
              Navigator.pop(context); // Cierra el diálogo de error
            });
          },
        );
      },
    );

    ref.listen<OrderInProgressState>(orderInProgressProvider, (_, state) {
      if (state.remainingTime <= 0) {
        handleExpiredOrder();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Request"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => refreshValidation(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshValidation(context, ref),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            children: [
              ConfirmationTokenWidget(confirmationToken: confirmationToken),
              const SizedBox(height: 20),
              RemainingTimeWidget(remainingTime: remainingTime),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => cancelOrder(context, ref),
                child: const Text("Cancel Order"),
              ),
              const SizedBox(height: 20),
              CancelOrderStateWidget(cancelOrderState: cancelOrderState),
              const SizedBox(height: 20),
              ValidationStatusWidget(orderId: orderState.orderId),
            ],
          ),
        ),
      ),
    );
  }
}
