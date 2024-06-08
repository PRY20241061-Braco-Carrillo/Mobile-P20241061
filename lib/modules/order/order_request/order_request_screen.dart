import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/quickalert.dart';

import "../../../config/routes/routes.dart";
import "../../../core/models/base_response.dart";
import "../../../core/notifiers/order/order_request/cancel_order_request.notifier.dart";
import 'providers/order_in_progress.notifier.dart';

class OrderRequestScreen extends ConsumerWidget {
  final String confirmationToken;

  const OrderRequestScreen({super.key, required this.confirmationToken});

  String _getFormattedTime(int remainingTime) {
    final String minutes = (remainingTime ~/ 60).toString().padLeft(2, "0");
    final String seconds = (remainingTime % 60).toString().padLeft(2, "0");
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderInProgressProvider);
    final remainingTime = orderState.remainingTime;
    final cancelOrderState = ref.watch(cancelOrderRequestNotifierProvider);

    Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
      print("Cancelling order...");
      print(orderState.orderId);
      if (orderState.inProgress &&
          orderState.remainingTime > 0 &&
          orderState.token.isNotEmpty) {
        await ref
            .read(cancelOrderRequestNotifierProvider.notifier)
            .cancelOrder(orderState.orderId);
      } else {
        ref.read(cancelOrderRequestNotifierProvider.notifier).state =
            AsyncValue<BaseResponse<String>>.error(
                Exception("No active order to cancel!"), StackTrace.current);
      }
    }

    ref.listen<AsyncValue<BaseResponse<String>>>(
      cancelOrderRequestNotifierProvider,
      (_, state) {
        state.when(
          data: (response) {
            if (response.code == "DELETED") {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Order has been cancelled successfully!',
              ).then((_) {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                } else {
                  GoRouter.of(context).go(AppRoutes.cart);
                }
              });
            }
          },
          loading: () {
            // Show loading indicator if needed
          },
          error: (error, _) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: error.toString(),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Order Request")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Confirmation Token: $confirmationToken",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize:
                        Theme.of(context).textTheme.titleLarge!.fontSize)),
            const SizedBox(height: 20),
            Text("Time remaining: ${_getFormattedTime(remainingTime)}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize:
                        Theme.of(context).textTheme.titleLarge!.fontSize)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _cancelOrder(context, ref),
              child: const Text("Cancel Order"),
            ),
            if (cancelOrderState.isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
