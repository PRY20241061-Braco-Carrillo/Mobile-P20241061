import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";

class SizeLabel extends StatelessWidget {
  final double? fontSize;

  const SizeLabel({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "MenuCard.labelSize.variant".tr(),
        style: TextStyle(color: Colors.white, fontSize: fontSize ?? 12),
      ),
    );
  }
}
