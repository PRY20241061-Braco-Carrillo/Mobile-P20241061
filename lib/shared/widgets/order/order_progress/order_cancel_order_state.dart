import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/models/base_response.dart";

class CancelOrderStateWidget extends StatelessWidget {
  final AsyncValue<BaseResponse<String>> cancelOrderState;

  const CancelOrderStateWidget({required this.cancelOrderState});

  @override
  Widget build(BuildContext context) {
    return cancelOrderState.when(
      data: (response) => Container(),
      loading: () => Container(),
      error: (error, _) => Text(
        "Error al cancelar la orden. Por favor, inténtelo nuevamente.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
        ),
      ),
    );
  }
}
