import "package:easy_localization/easy_localization.dart";
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
            products: cartItems.expand((item) {
              return item.productInfo.selectedProductVariants.map((variant) {
                return OrderProduct(
                  productVariantId: variant.productVariantId,
                  productAmount: item.quantity,
                  unitPrice: variant.amountPrice,
                );
              });
            }).toList(),
            complements: cartItems.expand((item) {
              return item.productInfo.selectedMenuVariants.map((variant) {
                return OrderComplement(
                  complementId: variant.productVariantId,
                  complementAmount: item.quantity,
                  unitPrice: variant.amountPrice.toInt(),
                );
              });
            }).toList(),
            combos: cartItems.expand((item) {
              return item.productInfo.selectedComboVariants.map((variant) {
                return ComboCombo(
                  comboId: variant.productVariantId,
                  comboAmount: item.quantity,
                  unitPrice: variant.amountPrice,
                  products: [], // Si hay productos dentro de combos, añadir lógica para mapearlos
                  complements: [], // Si hay complementos dentro de combos, añadir lógica para mapearlos
                );
              });
            }).toList(),
            comboPromotions: cartItems.expand((item) {
              return item.productInfo.selectedPromotionVariants.map((variant) {
                return ComboPromotion(
                  promotionId: variant.productVariantId,
                  promotionAmount: item.quantity,
                  unitPrice: variant.amountPrice.toInt(),
                  combos: [], // Si hay combos dentro de promociones, añadir lógica para mapearlos
                );
              });
            }).toList(),
            productPromotions: cartItems.expand((item) {
              return item.productInfo.selectedPromotionVariants.map((variant) {
                return ProductPromotion(
                  promotionId: variant.productVariantId,
                  promotionAmount: item.quantity,
                  unitPrice: variant.amountPrice.toInt(),
                  complements: [], // Si hay complementos dentro de promociones, añadir lógica para mapearlos
                  products: [], // Si hay productos dentro de promociones, añadir lógica para mapearlos
                );
              });
            }).toList(),
            menus: cartItems.expand((item) {
              return item.productInfo.selectedMenuVariants.map((variant) {
                return Menu(
                  menuId: variant.productVariantId,
                  menuAmount: item.quantity,
                  unitPrice: variant.amountPrice.toInt(),
                  products: [], // Si hay productos dentro de menús, añadir lógica para mapearlos
                );
              });
            }).toList(),
          ),
        );

        ref.listen<AsyncValue<BaseResponse<String>>>(
          reservationNotifierProvider(reservationRequest),
          (previous, next) {
            next.when(
              data: (response) async {
                ref.read(cartLoadingProvider.notifier).stopLoading();
                debugPrint("Reserva creada exitosamente: ${response.data}");

                if (context.mounted) {
                  // Muestra la alerta de éxito
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: "Reserva realizada exitosamente!",
                    onConfirmBtnTap: () {
                      debugPrint("Navegando a la pantalla de reservas...");
                      // Redirige a la pantalla de reservas
                      GoRouter.of(context).push(AppRoutes.reservations);
                    },
                  );
                }
              },
              loading: () {
                ref.read(cartLoadingProvider.notifier).startLoading();
                debugPrint("Cargando la reserva...");
              },
              error: (Object error, _) {
                ref.read(cartLoadingProvider.notifier).stopLoading();
                debugPrint("Error al crear la reserva: $error");

                if (context.mounted) {
                  // Muestra la alerta de error
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text:
                        "Error al realizar la reserva. Por favor, inténtelo nuevamente.",
                    onConfirmBtnTap: () {
                      debugPrint("Cerrando el QuickAlert de error");
                      Navigator.pop(context); // Cierra el QuickAlert de error
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
          child: Text("Order.labels.generate_reservation.label".tr()),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text("Error loading login data: $error"),
    );
  }
}
