import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../../../../../config/routes/routes.dart";
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
            extra: orderInProgressState.token,
          );
        } else {
          await generateOrder(context, ref);
        }
      },
      child: Text(
        orderInProgressState.inProgress && orderInProgressState.token.isNotEmpty
            ? "Ir a mi orden"
            : "Generar Orden",
      ),
    );
  }
}
