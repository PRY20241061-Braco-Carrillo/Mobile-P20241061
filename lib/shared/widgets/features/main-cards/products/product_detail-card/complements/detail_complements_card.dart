import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "product_complement.notifier.dart";
import "product_components.types.dart";

class ComplementSelector extends ConsumerWidget {
  final List<ProductComplement> complements;

  const ComplementSelector({super.key, required this.complements});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, int> complementState = ref.watch(complementProvider);
    final List<ProductComplement> sauces =
        complements.where((ProductComplement c) => c.isSauce == true).toList();
    final List<ProductComplement> others =
        complements.where((ProductComplement c) => c.isSauce == false).toList();

    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (sauces.isNotEmpty) ...<Widget>[
            const Text("Salsas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildComplementList(sauces, complementState, ref),
          ],
          if (others.isNotEmpty) ...<Widget>[
            const SizedBox(height: 20),
            const Text("Otros Complementos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildComplementList(others, complementState, ref),
          ],
        ],
      ),
    );
  }

  Widget _buildComplementList(List<ProductComplement> complements,
      Map<String, int> complementState, WidgetRef ref) {
    return Column(
      children: complements.map((ProductComplement complement) {
        final int count = complementState[complement.complementId] ?? 0;
        final bool isFree = count <= complement.freeAmount!;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(complement.name!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text("Gratis: ${complement.freeAmount}",
                        style: const TextStyle(color: Colors.green)),
                    if (!isFree)
                      Text(
                          "Precio adicional por unidad: ${complement.amountPrice}",
                          style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () {
                      ref
                          .read(complementProvider.notifier)
                          .removeComplement(complement.complementId!);
                    },
                  ),
                  Text("$count", style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      ref.read(complementProvider.notifier).addComplement(
                          complement.complementId!, complement.freeAmount!);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
