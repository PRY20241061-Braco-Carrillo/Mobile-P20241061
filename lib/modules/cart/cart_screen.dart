import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:quickalert/widgets/quickalert_dialog.dart";
import "package:quickalert/models/quickalert_type.dart";

import "../../config/routes/routes.dart";
import "../../core/models/base_response.dart";

import "../../core/models/order/order_request/saver_order_request.response.types.dart";
import "../../core/notifiers/order/order_request/save_order_request.notifier.dart";
import "../../layout/base_layout.dart";
import "../../shared/widgets/features/cart/cart_item/cart_item.dart";
import "../../shared/widgets/features/cart/order/order_button.dart";
import "../../shared/widgets/features/cart/order_cart/order_cart.notifier.dart";
import "../../shared/widgets/features/cart/order_cart/order_cart.types.dart";
import "../../shared/widgets/features/cart/reservation/reservation_button.dart";
import "../order/providers/order_in_progress.notifier.dart";
import "notifiers/cart_loading_notifier.dart";
import "order_navigation_data.dart";

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelOrderKey = "Cart.labels.CART.label";
    const String alertOrderInProgressTitleKey =
        "Order.order_request.alerts.ORDER_CANCELED_OTHER_ORDER_IN_PROGRESS.title";
    const String alertOrderInProgressMessageKey =
        "Order.order_request.alerts.ORDER_CANCELED_OTHER_ORDER_IN_PROGRESS.message";
    const String alertOrderErrorTitleKey =
        "Order.order_request.alerts.ERROR.title";
    const String alertOrderErrorMessageKey =
        "Order.order_request.alerts.ERROR.message";

    final List<CartItem> cartItems = ref.watch(cartProvider);
    final OrderInProgressState orderInProgressState =
        ref.watch(orderInProgressProvider);
    ref.watch(cartLoadingProvider);
    final double total = cartItems.fold<double>(
      0,
      (double sum, CartItem current) =>
          sum + current.productInfo.getTotalPrice() * current.quantity,
    );

    // Listener para el estado de las órdenes
    ref.listen<AsyncValue<BaseResponse<SaveOrderRequestResponse>>>(
      orderRequestNotifierProvider,
      (previous, next) {
        next.when(
          data: (response) async {
            ref.read(cartLoadingProvider.notifier).stopLoading();
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop();
              await ref
                  .read(orderInProgressProvider.notifier)
                  .setOrderInProgress(true,
                      token: response.data.confirmationToken,
                      orderId: response.data.orderRequestId,
                      orderRequest: response.data); // Guarda el objeto completo
              await GoRouter.of(context).push(AppRoutes.orderRequest,
                  extra: OrderRequestNavigationData(
                    orderRequest: response.data, // Pasa el objeto completo
                  ));
            }
          },
          loading: () {
            ref.read(cartLoadingProvider.notifier).startLoading();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
          error: (error, _) async {
            ref.read(cartLoadingProvider.notifier).stopLoading();
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop();
              await ref
                  .read(orderInProgressProvider.notifier)
                  .clearOrderInProgress();
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: alertOrderErrorTitleKey.tr(),
                text: alertOrderErrorMessageKey.tr(),
              );
            }
          },
        );
      },
    );

    Future<void> generateOrder(BuildContext context, WidgetRef ref) async {
      if (orderInProgressState.inProgress) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: alertOrderInProgressTitleKey.tr(),
          text: alertOrderInProgressMessageKey.tr(),
        );
        return;
      }

      await ref.read(orderRequestNotifierProvider.notifier).createOrder();
    }

    return BaseLayout(
      body: Scaffold(
        appBar: AppBar(
          title: Text(labelOrderKey.tr(),
              style: Theme.of(context).textTheme.bodyLarge),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: cartItems.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: CartItemWidget(item: cartItems[index]),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Cart.labels.TOTAL.label".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                "${total.toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          OrderButton(
                            orderInProgressState: orderInProgressState,
                            generateOrder: generateOrder,
                          ),
                          const SizedBox(height: 12),
                          ReservationButton(cartItems: cartItems),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Cart.labels.EMPTY.label".tr(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
