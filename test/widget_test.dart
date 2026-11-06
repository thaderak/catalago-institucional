import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_01/main.dart';
import 'package:proyecto_01/screens/home_screen.dart';
import 'package:proyecto_01/theme/app_theme.dart';

void main() {
  testWidgets('Test de Login: acceso exitoso con admin / admin123',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.pumpAndSettle();

    // Validar pantalla de login
    expect(find.text('Catálogo SENATI'), findsOneWidget);
    expect(find.text('Portal de Gestión de Laboratorio TI'), findsOneWidget);
    expect(find.text('Ingresar al Catálogo'), findsOneWidget);

    // Ingresar credenciales requeridas
    final textFields = find.byType(TextFormField);
    expect(textFields, findsNWidgets(2));

    await tester.enterText(textFields.at(0), 'admin');
    await tester.enterText(textFields.at(1), 'admin123');
    await tester.pumpAndSettle();

    // Presionar el botón de inicio de sesión con degradado
    await tester.tap(find.widgetWithText(ElevatedButton, 'Ingresar al Catálogo'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Debe encontrarse en el Catálogo (HomeScreen)
    expect(find.widgetWithText(FilterChip, 'Todos'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Hardware'), findsOneWidget);
    expect(find.text('Tarjeta Madre ASUS ROG'), findsOneWidget);
  });

  testWidgets('Test de Login: credenciales incorrectas rechazan acceso',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.pumpAndSettle();

    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'usuario_invalido');
    await tester.enterText(textFields.at(1), 'clave_erronea');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Ingresar al Catálogo'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Debe mostrar mensaje de error y no entrar al HomeScreen
    expect(find.text('Usuario o contraseña incorrectos. Verifique sus credenciales.'),
        findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Todos'), findsNothing);
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

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
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

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
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
