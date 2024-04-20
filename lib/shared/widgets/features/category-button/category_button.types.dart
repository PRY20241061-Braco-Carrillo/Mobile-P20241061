import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

enum ActionType {
  submit,
  reset,
  navigate,
  custom,
}

abstract class ICategoryButton extends StatelessWidget {
  final String labelKey;
  final bool disabled;
  final String icon;
  final ActionType actionType;
  final String? path;
  final String id;

  const ICategoryButton({
    super.key,
    required this.labelKey,
    this.disabled = false,
    this.icon = "",
    required this.actionType,
    this.path,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
