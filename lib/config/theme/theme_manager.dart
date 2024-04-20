import "package:hooks_riverpod/hooks_riverpod.dart";

import "app_theme.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

ThemeData _buildTheme(ColorScheme colorScheme) {
  final ThemeData baseTheme = ThemeData.from(colorScheme: colorScheme);
  return baseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
  );
}

ThemeData lightTheme = _buildTheme(lightColorScheme);
ThemeData darkTheme = _buildTheme(darkColorScheme);

final StateProvider<ThemeData> themeProvider =
    StateProvider<ThemeData>((StateProviderRef<ThemeData> ref) {
  return _buildTheme(lightColorScheme);
});
