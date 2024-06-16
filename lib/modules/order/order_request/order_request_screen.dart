import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/quickalert.dart';

import '../../../config/routes/routes.dart';
import "../../../core/managers/secure_storage_manager.dart";
import '../../../core/models/base_response.dart';
import "../../../core/models/order/order/save_order.request.types.dart";
import '../../../core/notifiers/order/order/create_order.notifier.dart';
import '../../../core/notifiers/order/order/token_has_been_validated.notifier.dart';
import '../../../core/notifiers/order/order_request/cancel_order_request.notifier.dart';
import '../../../shared/widgets/features/cart/order_cart/order_cart.notifier.dart';
import "../../../shared/widgets/features/cart/order_cart/order_cart.types.dart";
import "../../../shared/widgets/features/cart/order_cart/selected_product_info.types.dart";
import '../../../shared/widgets/order/order_progress/confirmation_token.dart';
import '../../../shared/widgets/order/order_progress/order_cancel_order_state.dart';
import '../../../shared/widgets/order/order_progress/order_validation_status.dart';
import '../../../shared/widgets/order/order_progress/remaining_time.dart';
import "../../cart/order_navigation_data.dart";
import "../providers/order_in_progress.notifier.dart";

SaveOrderRequest createOrderRequestFromCart(List<CartItem> cartItems,
    String userId, String campusId, String orderRequestId) {
  final List<OrderRequestProduct> products = <OrderRequestProduct>[];
  final List<OrderRequestComplement> complements = <OrderRequestComplement>[];
  final List<ComboCombo> combos = <ComboCombo>[];
  final List<ComboPromotion> comboPromotions = <ComboPromotion>[];
  final List<ProductPromotion> productPromotions = <ProductPromotion>[];
  final List<Menu> menus = <Menu>[];

  for (final CartItem item in cartItems) {
    final SelectedProductInfo productInfo = item.productInfo;

    for (final variant in productInfo.selectedProductVariants) {
      products.add(OrderRequestProduct(
        productVariantId: variant.productVariantId,
        productAmount: item.quantity,
        unitPrice: variant.amountPrice,
      ));
    }
  }

  return SaveOrderRequest(
    tableNumber: "A14",
    forTable: true,
    userId: userId,
    orderRequestId: orderRequestId,
    campusId: campusId,
    orderRequest: OrderRequest(
      products: products,
      complements: complements,
      combos: combos,
      comboPromotions: comboPromotions,
      productPromotions: productPromotions,
      menus: menus,
    ),
  );
}

class OrderLoadingNotifier extends StateNotifier<bool> {
  OrderLoadingNotifier() : super(false);

  void startLoading() => state = true;
  void stopLoading() => state = false;
}

final StateNotifierProvider<OrderLoadingNotifier, bool> orderLoadingProvider =
    StateNotifierProvider<OrderLoadingNotifier, bool>(
        (StateNotifierProviderRef<OrderLoadingNotifier, bool> ref) {
  return OrderLoadingNotifier();
});

class OrderRequestScreen extends ConsumerWidget {
  final OrderRequestNavigationData orderRequestData;
  final bool useNotifier;

  const OrderRequestScreen({
    super.key,
    required this.orderRequestData,
    this.useNotifier = true, // Cambia esto a true para consumir el servicio
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrderInProgressState orderState = ref.watch(orderInProgressProvider);
    final int remainingTime = orderState.remainingTime;
    final AsyncValue<BaseResponse<String>> cancelOrderState =
        ref.watch(cancelOrderRequestNotifierProvider);
    final List<CartItem> cartItems = ref.watch(cartProvider);

    void handleExpiredOrder() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text:
            "El tiempo de expiración del token ya venció. Por favor, genere su orden nuevamente.",
        onConfirmBtnTap: () {
          if (GoRouter.of(context).canPop()) {
            GoRouter.of(context).pop();
          } else {
            GoRouter.of(context).go(AppRoutes.cart);
          }
        },
      );
    }

    Future<void> createOrder(BuildContext context, WidgetRef ref) async {
      final loginData = await ref.read(secureStorageProvider).getLoginData();
      final userId = loginData[SecureStorageManager.keyUserId] ?? "";
      final campusId = loginData[SecureStorageManager.keyCampusId] ?? "";
      final orderRequestId = orderState.orderId;
      final orderRequest = createOrderRequestFromCart(
          cartItems, userId, campusId, orderRequestId);

      if (useNotifier) {
        // Usa el notifier para consumir el servicio
        ref.read(orderNotifierProvider(orderRequest).notifier);
      } else {
        // Imprime el JSON en la consola y muestra una alerta
        print(orderRequest.toJson());
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          text: 'JSON del pedido generado: ${orderRequest.toJson()}',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
        );
      }
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
      (AsyncValue<BaseResponse<String>>? previous,
          AsyncValue<BaseResponse<String>> next) {
        next.when(
          data: (BaseResponse<String> response) {
            ref.read(orderLoadingProvider.notifier).stopLoading();
            Navigator.of(context).pop(); // Cierra el diálogo de carga
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: "Order has been cancelled successfully!",
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
            Navigator.of(context).pop();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text:
                  "Error al cancelar la orden. Por favor, inténtelo nuevamente.",
              onConfirmBtnTap: () {
                Navigator.pop(context);
              },
            ).then((_) {
              Navigator.pop(context);
            });
          },
        );
      },
    );

    ref.listen<OrderInProgressState>(orderInProgressProvider,
        (_, OrderInProgressState state) {
      if (state.remainingTime <= 0) {
        handleExpiredOrder();
      }
    });

    ref.listen<AsyncValue<BaseResponse<String>>>(
      validateTokenNotifierProvider(orderState.orderId),
      (previous, next) {
        next.when(
          data: (BaseResponse<String> response) {
            if (response.data == "VALIDATED") {
              ref.read(orderLoadingProvider.notifier).stopLoading();
              GoRouter.of(context).go(AppRoutes.orderInProgress);
            }
          },
          loading: () {
            ref.read(orderLoadingProvider.notifier).startLoading();
          },
          error: (Object error, StackTrace stackTrace) {
            ref.read(orderLoadingProvider.notifier).stopLoading();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text:
                  "Error al validar la orden. Por favor, inténtelo nuevamente.",
              onConfirmBtnTap: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Request"),
        actions: <Widget>[
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
            children: <Widget>[
              ConfirmationTokenWidget(
                  confirmationToken:
                      orderRequestData.orderRequest.confirmationToken),
              const SizedBox(height: 20),
              RemainingTimeWidget(remainingTime: remainingTime),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => cancelOrder(context, ref),
                child: const Text("Cancel Order"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => createOrder(context, ref),
                child: const Text("Create Order"),
              ),
              const SizedBox(height: 20),
              CancelOrderStateWidget(cancelOrderState: cancelOrderState),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
