import 'package:flutter/material.dart';

/// Configuración de Tema Vanguardista y Profesional para Catálogo SENATI
/// Integra fuentes modernas (Outfit y Plus Jakarta Sans) y diseño enfocado en bordes definidos
class AppTheme {
  // Fuentes del Sistema y Web
  static const String fontHeading = 'Outfit';
  static const String fontBody = 'Plus Jakarta Sans';
  static const List<String> fontFallbacks = [
    'Plus Jakarta Sans',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'sans-serif',
  ];

  // Paleta de Colores Corporativa
  static const Color primaryBlue = Color(0xFF0A2540);
  static const Color secondaryBlue = Color(0xFF005696);
  static const Color accentBlue = Color(0xFF0284C7);
  static const Color darkNavy = Color(0xFF071927);

  // Colores para Bordes Marcados y Definidos
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color borderStrong = Color(0xFF94A3B8);
  static const Color borderAccent = Color(0xFF0284C7);

  // Colores de Estados y Precios
  static const Color priceGreen = Color(0xFF15803D);
  static const Color priceBadgeBg = Color(0xFFECFDF5);
  static const Color priceBadgeBorder = Color(0xFFA7F3D0);

  static const Color greenBoxBg = Color(0xFFF0FDF4);
  static const Color greenBoxBorder = Color(0xFF86EFAC);
  static const Color greenTextDark = Color(0xFF166534);

  // Fondos y Superficies
  static const Color scaffoldBg = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  /// Retorna un color distintivo para el borde y tag según la categoría
  static Color getCategoryColor(String category) {
    switch (category.trim()) {
      case 'Hardware':
        return const Color(0xFF2563EB); // Azul real
      case 'Procesadores':
        return const Color(0xFF7C3AED); // Púrpura vibrante
      case 'Almacenamiento':
        return const Color(0xFF0891B2); // Cyan profundo
      case 'Periféricos':
        return const Color(0xFF059669); // Esmeralda
      default:
        return const Color(0xFF475569); // Pizarra
    }
  }

  /// Estilo de fuente para Títulos y Encabezados (Outfit)
  static TextStyle headingStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    Color color = textPrimary,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: fontHeading,
      fontFamilyFallback: fontFallbacks,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Estilo de fuente para Cuerpo de Texto y Descripciones (Plus Jakarta Sans)
  static TextStyle bodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color color = textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: fontBody,
      fontFamilyFallback: fontFallbacks,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBg,
      fontFamily: fontBody,
      fontFamilyFallback: fontFallbacks,
      textTheme: TextTheme(
        displayLarge: headingStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: headingStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        titleMedium: headingStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: bodyStyle(
          fontSize: 15,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: bodyStyle(
          fontSize: 13,
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: bodyStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headingStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: borderMedium, width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderMedium, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderMedium, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
        labelStyle: bodyStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: bodyStyle(
          color: const Color(0xFF94A3B8),
          fontSize: 13,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF1E3A8A), width: 1.2),
          ),
          textStyle: bodyStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
