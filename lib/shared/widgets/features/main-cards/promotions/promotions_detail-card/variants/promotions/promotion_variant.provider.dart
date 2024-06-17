import 'package:hooks_riverpod/hooks_riverpod.dart';

import "promotion_detail.variant.types.dart";

final selectedPromotionProductVariantProvider =
    StateProvider<PromotionDetailVariantCard?>((ref) {
  return null;
});

final allVariantsSelectedProvider = StateProvider<bool>((ref) {
  final selectedVariant = ref.watch(selectedPromotionProductVariantProvider);
  return selectedVariant != null;
});

class SelectedVariantsState {
  final PromotionDetailVariantCard? selectedVariant;
  final String? productName;
  final double? price;
  final String? currency;
  final String? imageUrl;

  SelectedVariantsState({
    this.selectedVariant,
    this.productName,
    this.price,
    this.currency,
    this.imageUrl,
  });

  SelectedVariantsState copyWith({
    PromotionDetailVariantCard? selectedVariant,
    String? productName,
    double? price,
    String? currency,
    String? imageUrl,
  }) {
    return SelectedVariantsState(
      selectedVariant: selectedVariant ?? this.selectedVariant,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class SelectedVariantsNotifier
    extends StateNotifier<Map<String, SelectedVariantsState>> {
  final String productId;
  final Ref ref;

  SelectedVariantsNotifier(this.productId, this.ref) : super({});

  void updateSelectedVariant(PromotionDetailVariantCard? variant) {
    final currentState = state[productId];
    state = {
      ...state,
      productId: currentState?.copyWith(selectedVariant: variant) ??
          SelectedVariantsState(selectedVariant: variant),
    };
    ref
        .read(allVariantsSelectedProvider.notifier)
        .update((_) => variant != null);
  }
}
