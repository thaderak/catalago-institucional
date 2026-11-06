# Catálogo Institucional de Componentes Tecnológicos • SENATI

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Material Design 3](https://img.shields.io/badge/Design-Material%203-7C3AED)](https://m3.material.io)
[![Style](https://img.shields.io/badge/Style-Obsidian%20Cyber%20Glow-6366F1)](https://linear.app)

Aplicación multiplataforma (Móvil, Web y Escritorio) desarrollada en **Flutter** para la gestión pedagógica y catalogación de hardware tecnológico en laboratorios de computación e informática de **SENATI**.

---

## 👨‍💻 Información Académica

* **Institución:** Servicio Nacional de Adiestramiento en Trabajo Industrial (SENATI)
* **Carrera / Módulo:** Ingeniería de Software con IA / Desarrollo de Aplicaciones Multiplataforma
* **Estudiante:** Fabian Andre Chavez Villavicencio
* **ID:** 001684993
* **Docente / Instructor:** Jorge Antonio Luque Chambi

---

## ✨ Características Principales

1. **🔐 Autenticación y Control de Acceso (Login):**
   - Credenciales fijas: Usuario `admin` / Contraseña `admin123`.
   - Cápsula interactiva de autocompletado rápido para demostraciones.
   - Ocultamiento dinámico de contraseña y alertas visuales.
   - Cierre de sesión seguro (`Logout`) desde la barra superior.

2. **🎨 Sistema de Diseño Obsidian Cyber Glow:**
   - Inspirado en las interfaces modernas de vanguardia (Linear, Vercel, Supabase y Raycast).
   - Canvas y superficies oscuras profundas con micro-bordes luminosos.
   - Gradientes vibrantes (*Electric Indigo* a *Cyber Violet*, *Cyan Radiante*).
   - Etiquetas de precios estilo *Fintech & Neon Mint* con indicadores de disponibilidad en stock.
   - Neón distintivo por categoría de hardware (Hardware, Procesadores, Almacenamiento, Periféricos).

3. **🔍 Búsqueda y Filtrado Reactivo:**
   - Filtros horizontales interactivos (`FilterChips`) con conteo dinámico de productos.
   - Barra de búsqueda en tiempo real que filtra por nombre, descripción y categoría simultáneamente.

4. **📱 Diseño 100% Responsive:**
   - Optimizado para teléfonos móviles (360x780), tablets y monitores de escritorio (1920x1080).
   - Sin desbordamientos de interfaz gráfica (`zero RenderFlex overflow`).

5. **⚡ Gestión Dinámica de Hardware (CRUD con Undo):**
   - Modal táctil para registrar nuevos componentes con validación estricta.
   - Eliminación individual de productos y menú dedicado para periféricos.
   - Notificación emergente (`SnackBar`) con opción reactiva **DESHACER** (*Undo*).

---

## 🚀 Cómo Ejecutar el Proyecto

### Requisitos Previos
* Flutter SDK (3.x o superior)
* Dart SDK
* Android Studio / VS Code con extensión de Flutter
* Dispositivo físico Android o emulador configurado

### Instrucciones

```bash
# 1. Clonar el repositorio
git clone https://github.com/thaderak/catalago-institucional.git
cd catalago-institucional

# 2. Obtener dependencias
flutter pub get

# 3. Ejecutar pruebas unitarias y de widgets
flutter test

# 4. Lanzar en modo desarrollo (Móvil / Web / Windows)
flutter run

# 5. Compilar APK para Android
flutter build apk --debug
```

---

## 📁 Estructura del Proyecto

```
lib/
├── data/
│   └── initial_components.dart    # Colección precargada de componentes
├── models/
│   └── component_item.dart        # Entidad y modelo de datos
├── screens/
│   ├── login_screen.dart          # Pantalla de acceso con degradados dinámicos
│   ├── home_screen.dart           # Catálogo interactivo principal
│   └── details_screen.dart        # Ficha técnica detallada
├── theme/
│   └── app_theme.dart             # Sistema de diseño Obsidian Cyber Glow
├── widgets/
│   ├── add_component_modal.dart   # Formulario modal de registro
│   ├── component_card.dart        # Tarjeta de componente estilizada
│   └── filter_chip_bar.dart       # Barra horizontal de chips de filtrado
└── main.dart                      # Punto de entrada y enrutador SPA
```

---

## 📄 Licencia

Desarrollado con fines educativos y de evaluación académica para **SENATI**.
