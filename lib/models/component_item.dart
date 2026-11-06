import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

/// Modelo de datos para un Componente Tecnológico del Catálogo SENATI
class ComponentItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String stockStatus;
  final FaIconData? customIcon;

  const ComponentItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.stockStatus = 'Stock disponible en almacén',
    this.customIcon,
  });

  /// Formatea el precio a la moneda local peruana (S/ 1,250.00)
  String get formattedPrice {
    final formatter = NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/ ',
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  /// Retorna un ícono dinámico representativo de la librería FontAwesome
  /// según la categoría o el nombre del componente
  FaIconData get iconData {
    if (customIcon != null) return customIcon!;

    final lowerName = name.toLowerCase();
    if (lowerName.contains('parlante') ||
        lowerName.contains('audio') ||
        lowerName.contains('speaker')) {
      return FontAwesomeIcons.volumeHigh;
    }
    if (lowerName.contains('monitor') || lowerName.contains('pantalla')) {
      return FontAwesomeIcons.desktop;
    }
    if (lowerName.contains('teclado') || lowerName.contains('keyboard')) {
      return FontAwesomeIcons.keyboard;
    }
    if (lowerName.contains('mouse') || lowerName.contains('ratón')) {
      return FontAwesomeIcons.computerMouse;
    }
    if (lowerName.contains('madre') ||
        lowerName.contains('motherboard') ||
        lowerName.contains('asus')) {
      return FontAwesomeIcons.microchip;
    }

    switch (category) {
      case 'Hardware':
        return FontAwesomeIcons.microchip;
      case 'Procesadores':
        return FontAwesomeIcons.microchip;
      case 'Almacenamiento':
        return FontAwesomeIcons.hardDrive;
      case 'Periféricos':
        return FontAwesomeIcons.gamepad;
      default:
        return FontAwesomeIcons.boxOpen;
    }
  }

  /// Copia inmutable del objeto
  ComponentItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? description,
    String? stockStatus,
    FaIconData? customIcon,
  }) {
    return ComponentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      stockStatus: stockStatus ?? this.stockStatus,
      customIcon: customIcon ?? this.customIcon,
    );
  }
}
