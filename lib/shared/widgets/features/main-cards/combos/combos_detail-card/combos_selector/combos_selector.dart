import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../combos_detail.types.dart';

import '../variants/combo/combo_variant_selector.dart';

class ComboSelectorType extends ConsumerStatefulWidget {
  final ComboDetailCardData? comboDetail;
  const ComboSelectorType({super.key, required this.comboDetail});

  @override
  ComboSelectorTypeState createState() => ComboSelectorTypeState();
}

class ComboSelectorTypeState extends ConsumerState<ComboSelectorType> {
  @override
  Widget build(BuildContext context) {
    int uniqueIdCounter = 0;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ...widget.comboDetail!.products
              .map((ProductComboDetailCardData product) {
            return _buildProductCard(product, ref, uniqueIdCounter);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProductCard(
      ProductComboDetailCardData product, WidgetRef ref, int uniqueIdCounter) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(product.urlImage),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          for (int i = 0; i < product.productAmount; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ComboVariantSelector(
                comboId: "${product.productId}-${uniqueIdCounter++}",
                variants: product.toComboDetailVariantCards(),
              ),
            ),
        ],
      ),
    );
  }
}
