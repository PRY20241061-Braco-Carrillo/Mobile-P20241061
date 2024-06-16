import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../config/routes/routes.dart";
import "../../../../modules/cart/order_navigation_data.dart";
import "../../../../modules/order/providers/order_in_progress.notifier.dart";

class OrderSummaryBar extends ConsumerWidget {
  const OrderSummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderInProgressState = ref.watch(orderInProgressProvider);

    return Visibility(
      visible: orderInProgressState.inProgress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 4, color: Colors.black26)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push(
                  AppRoutes.orderRequest,
                  extra: OrderRequestNavigationData(
                      orderRequest:
                          orderInProgressState.orderRequestNavigationData),
                );
              },
              child: const Text("Ir a la Orden"),
            ),
          ],
        ),
      ),
    );
  }
}
