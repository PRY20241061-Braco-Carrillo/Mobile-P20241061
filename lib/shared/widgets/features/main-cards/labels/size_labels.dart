import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";

class SizeLabel extends StatelessWidget {
  final double? fontSize;
  final double height;
  final double width;

  const SizeLabel({super.key, this.fontSize, this.height = 4, this.width = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
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
