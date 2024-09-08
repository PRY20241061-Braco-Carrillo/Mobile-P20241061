import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../config/theme/theme_manager.dart';

class ThemeSwitcherWidget extends ConsumerWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StateController<ThemeData> currentTheme =
        ref.watch(themeProvider.notifier);

    // Determinamos si el tema actual es claro u oscuro
    bool isLightTheme = currentTheme.state.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Theme', // Texto que puedes reemplazar con una clave de localización si usas traducción
            style: Theme.of(context).textTheme.bodyText1,
          ),
          // Switch con animación entre Light y Dark
          GestureDetector(
            onTap: () {
              // Alternamos el tema cuando el usuario toca el widget
              currentTheme.state = isLightTheme ? darkTheme : lightTheme;
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
