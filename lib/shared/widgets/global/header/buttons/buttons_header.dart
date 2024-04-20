import "package:flutter/material.dart";

enum ActionType { navigate, dialog, ar, addToCart, promotionDetail }

enum HeaderButtonTypes { info }

class MenuHeaderButton extends StatelessWidget {
  final HeaderButtonTypes buttonType;
  final VoidCallback onPressed;
  final double? fontSize;
  final double? width;
  final double? height;
  final double iconSize;

  const MenuHeaderButton({
    super.key,
    required this.buttonType,
    required this.onPressed,
    this.fontSize,
    this.width = double.infinity,
    this.height = 50,
    this.iconSize = 24,
  });

  String get _label {
    switch (buttonType) {
      case HeaderButtonTypes.info:
        return "Info";
      default:
        return "";
    }
  }

  Icon get _icon {
    switch (buttonType) {
      case HeaderButtonTypes.info:
        return const Icon(Icons.info_outline);
      default:
        return const Icon(Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      width: width,
      height: height,
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
                _label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              _icon.icon,
              size: iconSize,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
