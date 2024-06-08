/*import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "../../../../utils/constants/currency_types.dart";
import "../product_card.types.dart";

class DiscountLabel extends StatelessWidget {
  final MenuCardDiscount discount;
  final double fontSize;

  const DiscountLabel(
      {super.key, required this.discount, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return _buildDiscountWidget(discount);
  }

  Widget _buildDiscountWidget(MenuCardDiscount discount) {
    if (discount is PercentDiscountLabel) {
      final String labelKey = "MenuCard.labelDiscount.percent".tr();
      return Container(
          margin: const EdgeInsets.only(right: 5, left: 5),
          padding: const EdgeInsets.all(3),
          alignment: Alignment.center,
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text("${discount.quantity}$labelKey ",
              style: TextStyle(color: Colors.white, fontSize: fontSize)));
    } else if (discount is CurrencyDiscountLabel) {
      final String labelKey = "MenuCard.labelDiscount.currency".tr();
      final String? currentCurrency = currencySymbol[discount.currency];
      return Container(
        margin: const EdgeInsets.only(right: 5, left: 5),
        padding: const EdgeInsets.all(3),
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text("$currentCurrency${discount.quantity} $labelKey",
            style: TextStyle(color: Colors.white, fontSize: fontSize)),
      );
    } else if (discount is SpecialCardDiscountLabel) {
      final String labelKey = "MenuCard.labelDiscount.specialCard".tr();
      return Container(
        margin: const EdgeInsets.only(right: 5, left: 5),
        padding: const EdgeInsets.all(3),
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text("${discount.quantity}$labelKey",
            style: TextStyle(color: Colors.white, fontSize: fontSize)),
      );
    } else {
      return Container();
    }
  }
}
*/