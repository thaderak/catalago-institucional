import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_01/main.dart';

void main() {
  testWidgets('Smoke test de Catálogo SENATI', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.pumpAndSettle();

    expect(find.text('Catálogo SENATI'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Todos'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Hardware'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Procesadores'), findsOneWidget);
    expect(find.text('Tarjeta Madre ASUS ROG'), findsOneWidget);
    expect(find.text('Procesador Intel Core i7'), findsOneWidget);
  });

  testWidgets('Prueba Responsive en modelo de teléfono móvil (360x780)',
      (WidgetTester tester) async {
    // Simula una pantalla de teléfono móvil estándar (ej. Samsung Galaxy / iPhone)
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.pumpAndSettle();

    // Comprobar que los elementos clave se renderizan sin desbordamientos (overflows)
    expect(find.text('Catálogo SENATI'), findsOneWidget);
    expect(find.text('Nuevo'), findsOneWidget); // Botón FAB compacto en móvil
    expect(find.text('Eliminar'), findsOneWidget); // Botón de eliminar en barra
  });

  testWidgets('Prueba de funcionalidad para eliminar un componente',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.pumpAndSettle();

    expect(find.text('Tarjeta Madre ASUS ROG'), findsOneWidget);

    // Tocar el botón de papelera del primer elemento
    final deleteButton = find.byKey(const ValueKey('delete-comp-1'));
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Confirmar diálogo de eliminación
    expect(find.text('Eliminar Componente'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Eliminar'));
    await tester.pumpAndSettle();

    // Verificar que el elemento fue removido de la lista y aparece el SnackBar con DESHACER
    expect(find.text('Tarjeta Madre ASUS ROG'), findsNothing);
    expect(find.text('DESHACER'), findsOneWidget);
  });
}
