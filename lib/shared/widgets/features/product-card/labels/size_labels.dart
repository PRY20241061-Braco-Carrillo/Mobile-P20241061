import "package:flutter/material.dart";

class SizeLabel extends StatelessWidget {
  final String size;
  final double fontSize;

  const SizeLabel({super.key, required this.size, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        size,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
    );
  }
}
