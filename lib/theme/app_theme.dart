import 'package:flutter/material.dart';

/// ============================================================================
/// SISTEMA DE DISEÑO VANGUARDISTA: AppTheme (Modern Obsidian & Cyber Glow)
/// ============================================================================
/// Inspirado en las interfaces de software más estéticas y modernas del mundo
/// (Linear, Vercel, Raycast, Stripe y Supabase).
/// Implementa superficies obsidian oscuras, bordes micro-definidos con reflejo,
/// gradientes vibrantes (Electric Indigo, Cyan, Cyber Violet y Mint)
/// y tipografía de máxima legibilidad (Outfit & Plus Jakarta Sans).
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

  // ---------------------------------------------------------------------------
  // PALETA DE SUPERFICIES Y FONDOS (Obsidian & Deep Space Slate)
  // ---------------------------------------------------------------------------
  static const Color scaffoldBg = Color(0xFF090D16); // Fondo profundo obsidian
  static const Color surfaceDark = Color(0xFF0D1424); // Superficie de barras y modales
  static const Color cardBg = Color(0xFF121B2E); // Tarjetas obsidian principales
  static const Color cardElevated = Color(0xFF17233B); // Tarjetas en hover/elevadas
  static const Color inputBg = Color(0xFF0A101D); // Fondo de campos de texto

  // ---------------------------------------------------------------------------
  // COLORES DE ACENTO VIBRANTES (Aesthetic Modern Palette)
  // ---------------------------------------------------------------------------
  static const Color accentIndigo = Color(0xFF6366F1); // Indigo eléctrico moderno
  static const Color accentViolet = Color(0xFF8B5CF6); // Violeta cibernético
  static const Color accentCyan = Color(0xFF06B6D4); // Cyan radiante
  static const Color accentSky = Color(0xFF38BDF8); // Azul cielo brillante
  static const Color accentMint = Color(0xFF10B981); // Verde menta / esmeralda
  static const Color accentRose = Color(0xFFF43F5E); // Rosa / Carmesí moderno
  static const Color accentAmber = Color(0xFFF59E0B); // Ámbar cálido

  // Gradientes corporativos estéticos
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Electric Indigo
      Color(0xFF8B5CF6), // Cyber Violet
    ],
  );

  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF06B6D4), // Cyan
      Color(0xFF3B82F6), // Blue
    ],
  );

  static const LinearGradient backgroundMeshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF060911),
      Color(0xFF0B101D),
      Color(0xFF0E172A),
      Color(0xFF0A1122),
    ],
    stops: [0.0, 0.35, 0.70, 1.0],
  );

  // ---------------------------------------------------------------------------
  // BORDES MICRO-DEFINIDOS Y REFLEJOS (Micro-borders)
  // ---------------------------------------------------------------------------
  static const Color borderSubtle = Color(0xFF1E293B); // Borde sutil casi invisible
  static const Color borderMedium = Color(0xFF26354D); // Borde estándar de tarjetas
  static const Color borderStrong = Color(0xFF3B4F73); // Borde de inputs activos
  static const Color borderAccent = Color(0xFF6366F1); // Borde de enfoque índigo

  // ---------------------------------------------------------------------------
  // ESTADOS, PRECIOS Y STOCK (Fintech & Neon Mint)
  // ---------------------------------------------------------------------------
  static const Color priceGreen = Color(0xFF34D399); // Verde menta neón brillante
  static const Color priceBadgeBg = Color(0xFF062E25); // Superficie esmeralda profunda
  static const Color priceBadgeBorder = Color(0xFF059669); // Borde verde esmeralda

  static const Color greenBoxBg = Color(0xFF082720);
  static const Color greenBoxBorder = Color(0xFF0D5E4D);
  static const Color greenTextDark = Color(0xFF6EE7B7);

  // ---------------------------------------------------------------------------
  // COLORES DE TEXTO (Alta Jerarquía y Contraste)
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFFF8FAFC); // Blanco hielo puro
  static const Color textSecondary = Color(0xFF94A3B8); // Pizarra fresca / gris moderno
  static const Color textMuted = Color(0xFF64748B); // Gris atenuado

  // Alias retrocompatibles para no romper referencias existentes
  static const Color primaryBlue = Color(0xFF121B2E);
  static const Color secondaryBlue = Color(0xFF6366F1);

  // ---------------------------------------------------------------------------
  // COLORES DINÁMICOS POR CATEGORÍA TECNOLÓGICA (Aesthetic Neon Tones)
  // ---------------------------------------------------------------------------
  static Color getCategoryColor(String category) {
    switch (category.trim()) {
      case 'Hardware':
        return const Color(0xFF38BDF8); // Electric Sky Blue
      case 'Procesadores':
        return const Color(0xFFA855F7); // Cyber Purple / Neon Violet
      case 'Almacenamiento':
        return const Color(0xFF06B6D4); // Radiant Cyan
      case 'Periféricos':
        return const Color(0xFF10B981); // Emerald Mint
      default:
        return const Color(0xFF818CF8); // Indigo pastel
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

  /// Tema Principal Global de la Aplicación
  static ThemeData get lightTheme => modernTheme;

  static ThemeData get modernTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      fontFamily: fontBody,
      fontFamilyFallback: fontFallbacks,
      colorScheme: ColorScheme.dark(
        primary: accentIndigo,
        secondary: accentViolet,
        surface: cardBg,
        onSurface: textPrimary,
        error: accentRose,
      ),
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
        backgroundColor: surfaceDark,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headingStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderMedium, width: 1.2),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderMedium, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderMedium, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentIndigo, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRose, width: 1.4),
        ),
        labelStyle: bodyStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: bodyStyle(
          color: textMuted,
          fontSize: 13,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: bodyStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderMedium, width: 1.4),
        ),
      ),
    );
  }
}
