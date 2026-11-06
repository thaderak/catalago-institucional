import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/component_item.dart';

/// Datos iniciales precargados para el Catálogo SENATI
/// Basados en la guía y capturas del taller integrador
final List<ComponentItem> initialComponents = [
  const ComponentItem(
    id: 'comp-1',
    name: 'Tarjeta Madre ASUS ROG',
    category: 'Hardware',
    price: 1250.00,
    description:
        'Placa madre gaming de alto rendimiento con soporte para procesadores de última generación, disipadores VRM y conectividad ultra rápida.',
    customIcon: FontAwesomeIcons.microchip,
  ),
  const ComponentItem(
    id: 'comp-2',
    name: 'Procesador Intel Core i7',
    category: 'Procesadores',
    price: 1680.00,
    description:
        'Microprocesador Intel Core i7 de última generación con 16 núcleos y 24 hilos, ideal para laboratorios de computación y tareas de alto rendimiento.',
    customIcon: FontAwesomeIcons.microchip,
  ),
  const ComponentItem(
    id: 'comp-3',
    name: 'Memoria RAM 16GB DDR4',
    category: 'Almacenamiento',
    price: 240.00,
    description:
        'Módulo de memoria de alta velocidad a 3200MHz con disipador de calor de aluminio negro.',
    customIcon: FontAwesomeIcons.hardDrive,
  ),
  const ComponentItem(
    id: 'comp-4',
    name: 'Monitor Gamer 27" 144Hz',
    category: 'Periféricos',
    price: 990.00,
    description:
        'Monitor LED curvo Full HD con tasa de refresco de 144Hz y tiempo de respuesta de 1ms.',
    customIcon: FontAwesomeIcons.desktop,
  ),
  const ComponentItem(
    id: 'comp-5',
    name: 'Parlantes Profesionales',
    category: 'Periféricos',
    price: 50.00,
    description: 'Parlantes profesionales con calidad Blooto',
    customIcon: FontAwesomeIcons.volumeHigh,
  ),
];

/// Lista de categorías estándar solicitadas en el requerimiento
final List<String> catalogCategories = [
  'Todos',
  'Hardware',
  'Procesadores',
  'Almacenamiento',
  'Periféricos',
];
