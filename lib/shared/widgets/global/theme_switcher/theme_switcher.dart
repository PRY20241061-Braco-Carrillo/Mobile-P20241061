import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "../../../../config/theme/theme_manager.dart";

class ThemeSwitcherWidget extends ConsumerWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StateController<ThemeData> currentTheme = ref.watch(themeProvider.notifier);

    return DropdownButton<String>(
      value: currentTheme.state == lightTheme ? "Light" : "Dark",
      onChanged: (String? newValue) {
        switch (newValue) {
          case "Light":
            currentTheme.state = lightTheme;
            break;
          case "Dark":
            currentTheme.state = darkTheme;
            break;
          default:
            currentTheme.state = lightTheme;
        }
      },
      items: <String>["Light", "Dark"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
