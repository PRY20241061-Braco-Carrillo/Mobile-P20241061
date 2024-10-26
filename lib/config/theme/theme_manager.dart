import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

const String themePrefKey = 'selected_theme';

// Función para construir el tema
ThemeData _buildTheme(ColorScheme colorScheme) {
  final ThemeData baseTheme = ThemeData.from(colorScheme: colorScheme);
  return baseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
  );
}

// Definimos los temas claro y oscuro
ThemeData lightTheme = _buildTheme(lightColorScheme);
ThemeData darkTheme = _buildTheme(darkColorScheme);

// Proveedor de estado del tema con persistencia
final StateNotifierProvider<ThemeNotifier, ThemeData> themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

// Clase para manejar el estado del tema y la persistencia
class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightTheme) {
    _loadThemeFromPreferences(); // Cargar el tema guardado al inicializar
  }

  // Alternar entre tema claro y oscuro
  Future<void> toggleTheme() async {
    if (state == lightTheme) {
      state = darkTheme;
      await _saveThemeToPreferences(false); // Guardar tema oscuro
    } else {
      state = lightTheme;
      await _saveThemeToPreferences(true); // Guardar tema claro
    }
  }

  // Cargar el tema desde SharedPreferences
  Future<void> _loadThemeFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLightTheme = prefs.getBool(themePrefKey) ?? true;
    state = isLightTheme ? lightTheme : darkTheme;
  }

  // Guardar el tema seleccionado en SharedPreferences
  Future<void> _saveThemeToPreferences(bool isLightTheme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themePrefKey, isLightTheme);
  }
}
