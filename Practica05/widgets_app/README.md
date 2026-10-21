# Práctica 05 - Widgets App (Catálogo de Widgets en Flutter)

Catálogo interactivo y modular de componentes, controles y widgets avanzados en Flutter utilizando **Material Design 3**, **Riverpod** para el manejo de estado y **GoRouter** para la navegación declarativa.

---

## Información del Estudiante y la Materia

| Información de la Materia | Datos del Estudiante |
|:--|:--|
| <table><tr><th>Campo</th><th>Detalle</th></tr><tr><td><b>Materia</b></td><td>Desarrollo Móvil Integral</td></tr><tr><td><b>Carrera</b></td><td>Ingeniería en Desarrollo y Gestión de Software</td></tr><tr><td><b>Docente</b></td><td>M.T.I. Marco A. Ramírez Hernández</td></tr><tr><td><b>Periodo</b></td><td>Septiembre - Diciembre</td></tr></table> | <table><tr><th>Campo</th><th>Detalle</th></tr><tr><td><b>Nombre</b></td><td>Edgar Cabrera</td></tr><tr><td><b>Matrícula</b></td><td>230496</td></tr><tr><td><b>Grupo</b></td><td>10 A°</td></tr><tr><td><b>Correo</b></td><td>230496@utxicotepec.edu.mx</td></tr></table> |

---

## Objetivo de la Práctica

Construir una aplicación catálogo interactiva en Flutter que explore y demuestre el uso práctico de los widgets fundamentales y avanzados del SDK de Flutter, implementando:
- **Gestión de estado global** reactivo con `flutter_riverpod` (`StateProvider` y `StateNotifierProvider`).
- **Navegación desacoplada y tipada** con `go_router`.
- **Tematización dinámica** personalizable en tiempo de ejecución (Dark Mode y selección de paleta de colores Material 3).
- **Animaciones implícitas y explícitas** mediante `AnimatedContainer` y la librería `animate_do`.
- **Manejo de asincronía y retroalimentación al usuario**: loaders, pull-to-refresh, infinite scrolling, snackbars y diálogos modales.

---

## Tecnologías Utilizadas

- **Flutter & Dart**: Framework multiplataforma y lenguaje de programación tipado.
- **Flutter Riverpod (`^2.2.0`)**: Manejador de estado seguro en tiempo de compilación y altamente escalable.
- **Go Router (`^6.0.7`)**: Enrutador declarativo para Flutter que simplifica la navegación y gestión de rutas profundas.
- **Animate Do (`^3.0.2`)**: Paquete de animaciones listas para usar inspiradas en Animate.css (`FadeIn`, `FadeInRight`, `BounceIn`, etc.).
- **Material Design 3**: Sistema de diseño moderno con soporte para colores dinámicos, botones elevados/tonales/contorneados y tarjetas personalizadas.

---

## Arquitectura del Proyecto

```
Practica05/widgets_app/
├── assets/
│   └── images/                     # Recursos visuales (imágenes del tutorial y gif loader)
│       ├── 1.png
│       ├── 2.png
│       ├── 3.png
│       └── jar-loading.gif
├── lib/
│   ├── config/
│   │   ├── menu/
│   │   │   └── menu_items.dart     # Lista de opciones y configuración del menú principal
│   │   ├── router/
│   │   │   └── app_router.dart     # Definición de rutas declarativas con GoRouter
│   │   └── theme/
│   │       └── app_theme.dart      # Generador de temas, colores y modo oscuro
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── counter_provider.dart  # Providers para contador con StateProvider
│   │   │   └── theme_provider.dart    # Gestor de tema con StateNotifierProvider
│   │   ├── screens/
│   │   │   ├── animated/animated_screen.dart             # Animaciones con AnimatedContainer
│   │   │   ├── app_tutorial/app_tutorial_screen.dart     # Tutorial introductorio con PageView
│   │   │   ├── buttons/buttons_screen.dart               # Catálogo de estilos de botones
│   │   │   ├── cards/cards_screen.dart                   # Diferentes tipos de Card (elevadas, contorno, relleno)
│   │   │   ├── counter/counter_screen.dart               # Pantalla de contador reactivo con Riverpod
│   │   │   ├── home/home_screen.dart                     # Menú principal con navegación y Drawer lateral
│   │   │   ├── infinite_scroll/infinite_scroll_screen.dart # Infinite scroll y Pull to refresh
│   │   │   ├── progress/progress_screen.dart             # Indicadores circulares y lineales controlados
│   │   │   ├── snackbar/snackbar_screen.dart             # Diálogos de alerta, confirmación y Snackbars
│   │   │   ├── theme_changer/theme_changer_screen.dart   # Selector de color y toggle de modo oscuro
│   │   │   ├── ui_controls/ui_controls_screen.dart       # SwitchListTile, RadioListTile y CheckboxListTile
│   │   │   └── screens.dart                              # Archivo barril para exportación limpia
│   │   └── widgets/
│   │       └── side_menu.dart      # Menú lateral (NavigationDrawer) responsive
│   └── main.dart                   # Punto de entrada envuelto en ProviderScope
└── pubspec.yaml                    # Dependencias y configuración de assets
```

---

## Catálogo de Módulos y Pantallas

| Pantalla / Módulo | Ruta | Descripción |
|---|---|---|
| **Home Screen** | `/` | Menú principal que lista todos los accesos con iconos y subtítulos, con soporte para Drawer lateral. |
| **Riverpod Counter** | `/counter-river` | Contador que demuestra el consumo de estado reactivo mediante `ConsumerWidget` y `ref.watch`. |
| **Botones** | `/buttons` | Muestrario de `ElevatedButton`, `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton` y botones personalizados. |
| **Tarjetas** | `/cards` | Variantes de tarjetas con elevación, bordes definidos y fondos con color primario. |
| **Progress Indicators** | `/progress` | Indicadores de progreso circulares y lineales continuos y controlados dinámicamente mediante `StreamBuilder`. |
| **Snackbars y Diálogos** | `/snackbars` | Mensajes contextuales con `SnackBarAction`, diálogos de confirmación y advertencias modales. |
| **Animated Container** | `/animated` | Widget interactivo que transforma dimensiones, radio de bordes y color con curvas de animación. |
| **UI Controls** | `/ui-controls` | Controles de formulario: interruptores (`Switch`), opciones de transporte (`Radio`) y preferencias (`Checkbox`). |
| **Tutorial de App** | `/tutorial` | Carrusel instructivo interactivo con `PageView` y botón condicional de finalización animado con `animate_do`. |
| **Infinite Scroll & Pull** | `/infinite` | Descarga simulada de imágenes con paginación infinita y refresco al deslizar hacia abajo (`RefreshIndicator`). |
| **Cambiar Tema** | `/theme-changer` | Personalización global de la aplicación cambiando entre temas claros/oscuros y paleta de colores Material 3. |

---

## Instrucciones de Instalación y Ejecución

1. Ubicarse en el directorio del proyecto:
   ```bash
   cd Practica05/widgets_app
   ```

2. Descargar las dependencias necesarias:
   ```bash
   flutter pub get
   ```

3. Ejecutar la aplicación en un emulador, dispositivo físico o navegador:
   ```bash
   flutter run
   ```
