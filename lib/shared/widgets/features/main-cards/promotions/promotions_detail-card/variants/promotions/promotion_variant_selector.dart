import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "promotion_detail.variant.types.dart";
import "promotion_variant.provider.dart";

class PromotionProductVariantSelector extends ConsumerWidget {
  final List<PromotionDetailVariantCard> variants;

  const PromotionProductVariantSelector({
    super.key,
    required this.variants,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVariant = ref.watch(selectedPromotionProductVariantProvider);

    return SingleChildScrollView(
      child: Column(
        children: variants.map((variant) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: RadioListTile<PromotionDetailVariantCard>(
              title: Text(variant.name!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail: ${variant.detail}'),
                  Text(
                      'Price: ${variant.amountPrice} ${variant.currencyPrice}'),
                  Text(
                      'Cooking Time: ${variant.minCookingTime}-${variant.maxCookingTime} ${variant.unitOfTimeCookingTime}'),
                ],
              ),
              value: variant,
              groupValue: selectedVariant,
              onChanged: (PromotionDetailVariantCard? value) {
                ref
                    .read(selectedPromotionProductVariantProvider.notifier)
                    .state = value;
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
