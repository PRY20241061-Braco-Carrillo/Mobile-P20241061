import "package:easy_localization/easy_localization.dart";
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/theme/theme_manager.dart';

class ThemeSwitcherWidget extends ConsumerWidget {
  const ThemeSwitcherWidget({super.key});
  static const String themeKey = "Settings.theme.label";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final currentTheme = ref.watch(themeProvider);
    bool isLightTheme = currentTheme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            themeKey.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          GestureDetector(
            onTap: () {
              themeNotifier.toggleTheme(); // Cambiar el tema y guardar
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: isLightTheme ? Colors.yellow[700] : Colors.blueGrey[800],
              ),
              width: 80,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: isLightTheme ? Colors.white : Colors.grey[600],
                  ),
                  Icon(
                    Icons.nightlight_round,
                    color: isLightTheme ? Colors.grey[600] : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
