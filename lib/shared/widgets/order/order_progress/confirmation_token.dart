import "package:flutter/material.dart";

class ConfirmationTokenWidget extends StatelessWidget {
  final String confirmationToken;

  const ConfirmationTokenWidget({super.key, required this.confirmationToken});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Confirmation Token: $confirmationToken",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
    );
  }
}
