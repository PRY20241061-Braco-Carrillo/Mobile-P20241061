import "package:flutter/material.dart";

class RemainingTimeWidget extends StatelessWidget {
  final int remainingTime;

  const RemainingTimeWidget({super.key, required this.remainingTime});

  String _getFormattedTime(int remainingTime) {
    final String minutes = (remainingTime ~/ 60).toString().padLeft(2, "0");
    final String seconds = (remainingTime % 60).toString().padLeft(2, "0");
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Time remaining: ${_getFormattedTime(remainingTime)}",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
    );
  }
}
