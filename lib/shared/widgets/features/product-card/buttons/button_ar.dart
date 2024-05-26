import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../../ar_core/ar.types.dart";
import "../../../../../config/routes/routes.dart";

class ButtonAR extends ConsumerWidget {
  final String productId;
  final String urlGLB;
  final NutritionalInformationAR nutritionalInformation;

  const ButtonAR({
    super.key,
    required this.productId,
    required this.urlGLB,
    required this.nutritionalInformation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelButton = "MenuCard.buttons.AR.label";

    return ElevatedButton(
      onPressed: () {
        context.push(AppRoutes.ar, extra: <String, Object>{
          "urlGLB": urlGLB,
          "nutritionalInformation": nutritionalInformation
        });
      },
      child: Text(labelButton.tr()),
    );
  }
}
