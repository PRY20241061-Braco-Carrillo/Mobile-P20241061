/*import "package:flutter/material.dart";
import "../product_card.types.dart";

enum ActionType { navigate, dialog, ar, addToCart, promotionDetail }

class MenuCardFooterButton extends StatelessWidget {
  final MenuCardFooterButtonTypes buttonType;
  final VoidCallback onPressed;
  final double? fontSize;

  const MenuCardFooterButton({
    super.key,
    required this.buttonType,
    required this.onPressed,
    this.fontSize,
  });

  String get _label {
    switch (buttonType) {
      case MenuCardFooterButtonTypes.add:
        return "Agregar";
      case MenuCardFooterButtonTypes.ar:
        return "Realidad Aumentada";
      case MenuCardFooterButtonTypes.view:
        return "Ver";
      case MenuCardFooterButtonTypes.promotionDetail:
        return "Detalle de Promoción";
      default:
        return "";
    }
  }

  Icon get _icon {
    switch (buttonType) {
      case MenuCardFooterButtonTypes.add:
        return const Icon(Icons.add);
      case MenuCardFooterButtonTypes.ar:
        return const Icon(Icons.camera_alt);
      case MenuCardFooterButtonTypes.view:
        return const Icon(Icons.visibility);
      case MenuCardFooterButtonTypes.promotionDetail:
        return const Icon(Icons.info_outline);
      default:
        return const Icon(Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Center(
                  child: Text(_label,
                      style: TextStyle(
                          fontSize: fontSize, fontWeight: FontWeight.w600))),
            ),
            Expanded(
              flex: 2,
              child: Center(child: _icon),
            ),
          ],
        ),
      ),
    );
  }
}
*/