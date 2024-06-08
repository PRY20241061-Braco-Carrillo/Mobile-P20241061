import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quickalert/quickalert.dart';

import '../../config/routes/routes.dart';
import '../../core/models/base_response.dart';
import '../../core/models/order/order_request/saver_order_request.response.types.dart';
import '../../core/notifiers/order/order_request/save_order_request.notifier.dart';
import '../../layout/base_layout.dart';
import "../../shared/widgets/features/cart/cart_item/cart_item.dart";
import '../../shared/widgets/features/cart/order_cart/order_cart.notifier.dart';
import '../../shared/widgets/features/cart/order_cart/order_cart.types.dart';
import '../../shared/widgets/features/header/product-header/products_categories_header.dart';
import '../order/order_request/providers/order_in_progress.notifier.dart';

// Define a notifier to handle the loading state
class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void startLoading() => state = true;
  void stopLoading() => state = false;
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

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
    final PersistentTabController controller = PersistentTabController();
    final OrderInProgressState orderInProgressState =
        ref.watch(orderInProgressProvider);
    final isLoading = ref.watch(loadingProvider);

    ref.listen<AsyncValue<BaseResponse<SaveOrderRequestResponse>>>(
        orderRequestNotifierProvider, (previous, next) {
      next.when(
        data: (response) async {
          ref.read(loadingProvider.notifier).stopLoading();
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
            await ref.read(orderInProgressProvider.notifier).setOrderInProgress(
                true,
                token: response.data.confirmationToken,
                orderId: response.data.orderRequestId);
            await GoRouter.of(context).push(
              AppRoutes.orderRequest,
              extra: response.data.confirmationToken,
            );
          }
        },
        loading: () {
          ref.read(loadingProvider.notifier).startLoading();
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
        error: (error, _) async {
          ref.read(loadingProvider.notifier).stopLoading();
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
            await ref
                .read(orderInProgressProvider.notifier)
                .clearOrderInProgress();
            await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: alertOrderErrorTitleKey.tr(),
                text: alertOrderErrorMessageKey.tr());
          }
        },
      );
    });

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

    void goToOrderRequest(BuildContext context, String token) {
      GoRouter.of(context).push(
        AppRoutes.orderRequest,
        extra: token,
      );
    }

    return BaseLayout(
      tabController: controller,
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.background,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: CBaseProductCategoriesHeader(
                    title: labelOrderKey.tr(),
                    height: 220,
                    onButtonPressed: (BuildContext context) {
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop();
                      }
                    },
                    fontSize: 32,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return CartItemWidget(item: cartItems[index]);
                              },
                              childCount: cartItems.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (cartItems.isNotEmpty && !orderInProgressState.inProgress)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, -1),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (orderInProgressState.inProgress &&
                          orderInProgressState.token.isNotEmpty) {
                        goToOrderRequest(context, orderInProgressState.token);
                      } else {
                        await generateOrder(context, ref);
                      }
                    },
                    child: Text(
                      orderInProgressState.inProgress &&
                              orderInProgressState.token.isNotEmpty
                          ? "Ir a mi orden"
                          : "Generar Orden",
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
