import "package:easy_localization/easy_localization.dart";
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../../../../../config/routes/routes.dart";
import "../../../../../modules/cart/order_navigation_data.dart";
import "../../../../../modules/order/providers/order_in_progress.notifier.dart";

class OrderButton extends ConsumerWidget {
  const OrderButton({
    Key? key,
    required this.orderInProgressState,
    required this.generateOrder,
  }) : super(key: key);

  final OrderInProgressState orderInProgressState;
  final Future<void> Function(BuildContext context, WidgetRef ref)
      generateOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        if (orderInProgressState.inProgress &&
            orderInProgressState.token.isNotEmpty) {
          GoRouter.of(context).push(
            AppRoutes.orderRequest,
            extra: OrderRequestNavigationData(
              orderRequest: orderInProgressState
                  .orderRequestNavigationData, // Aquí asegúrate de pasar el objeto completo
            ),
          );
        } else {
          await generateOrder(context, ref);
        }
      },
      child: Text(
        orderInProgressState.inProgress && orderInProgressState.token.isNotEmpty
            ? "Order.labels.go_order.label".tr()
            : "Order.labels.generate_order.label".tr(),
      ),
    );
  }
}
