import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'menu_detail_variant.types.dart';
import 'menu_variant.provider.dart';

class MenuVariantSelector extends ConsumerStatefulWidget {
  final String menuId;
  final List<MenuDetailVariantCard> variants;
  final StateNotifierProvider<SelectedMenuVariantsNotifier,
      SelectedVariantsState> provider;

  const MenuVariantSelector({
    super.key,
    required this.menuId,
    required this.variants,
    required this.provider,
  });

  @override
  MenuVariantSelectorState createState() => MenuVariantSelectorState();
}

class MenuVariantSelectorState extends ConsumerState<MenuVariantSelector> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(widget.provider.notifier).initializeVariants(widget.variants);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedVariantsState = ref.watch(widget.provider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RadioVariantGroup(
          title: 'Variants',
          variants: widget.variants.map((variant) => variant.detail).toList(),
          selectedVariant: selectedVariantsState.selectedVariant?.detail,
          onChanged: (String? selected) {
            final selectedVariant = widget.variants
                .firstWhere((variant) => variant.detail == selected);
            ref
                .read(widget.provider.notifier)
                .updateSelectedVariant(selectedVariant);
          },
        ),
      ],
    );
  }
}

class RadioVariantGroup extends StatelessWidget {
  final String title;
  final List<String> variants;
  final String? selectedVariant;
  final void Function(String?) onChanged;

  const RadioVariantGroup({
    super.key,
    required this.title,
    required this.variants,
    this.selectedVariant,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          Column(
            children: variants.map((String variant) {
              return RadioListTile<String>(
                title: Text(variant),
                value: variant,
                groupValue: selectedVariant,
                onChanged: onChanged,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
