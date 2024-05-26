import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../shared/widgets/features/campus-card/campus_card.types.dart";

class ProductDetailScreen extends ConsumerWidget {
  final CampusCardData campusCardData;

  const ProductDetailScreen({super.key, required this.campusCardData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
