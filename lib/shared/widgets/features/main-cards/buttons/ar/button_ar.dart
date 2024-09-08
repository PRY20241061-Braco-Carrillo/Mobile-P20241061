import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../../../ar_core/ar.types.dart";
import "../../../../../../config/routes/routes.dart";

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

    return SizedBox(
      width: double.infinity, // Botón ocupa todo el ancho disponible
      child: ElevatedButton.icon(
        onPressed: () {
          context.push(AppRoutes.ar, extra: <String, Object>{
            "urlGLB": urlGLB,
            "nutritionalInformation": nutritionalInformation,
          });
        },
        icon: const Icon(
          Icons.view_in_ar,
          size: 24,
        ),
        label: Text(
          labelButton.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
