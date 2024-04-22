import "package:flutter/material.dart";

class BaseButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? fontSize;
  final double? width;
  final double? height;
  final double iconSize;
  final Widget? icon;

  const BaseButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize,
    this.width,
    this.height,
    this.iconSize = 20,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (icon != null) icon!,
          ],
        ),
      ),
    );
  }
}
