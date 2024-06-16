import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/models/base_response.dart";
import "../../../../core/notifiers/order/order/token_has_been_validated.notifier.dart";

class ValidationStatusWidget extends ConsumerWidget {
  final String orderId;

  const ValidationStatusWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BaseResponse<String>> validationState =
        ref.watch(validateTokenNotifierProvider(orderId));
    return validationState.when(
      data: (BaseResponse<String> response) {
        String message;
        if (response.data == "VALIDATED") {
          message = "Validacion exitosa, su orden esta en progreso";
        } else if (response.data == "NOT_VALIDATED") {
          message = "Validacion pendiente, contacte con el mozo más cercano";
        } else {
          message = "Estado de validación: ${response.data ?? 'No validado'}";
        }

        return Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (Object error, StackTrace stack) => Text(
        "Error al validar el token. Por favor, inténtelo nuevamente.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
        ),
      ),
    );
  }
}
