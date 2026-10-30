# Práctica 06 - Cinemapedia (Clean Architecture, The Movie DB & Riverpod)

Aplicación cinematográfica en Flutter implementando **Clean Architecture** (Capa de Dominio, Infraestructura y Presentación), consumo de la API de **The Movie Database (TMDb)** mediante **Dio**, gestión de estado reactiva con **Flutter Riverpod**, navegación declarativa con **GoRouter**, gestión segura de secretos con **flutter_dotenv** y diseño visual moderno **Material Design 3**.

---

## Información del Estudiante y la Materia

| Información de la Materia | Datos del Estudiante |
|:--|:--|
| <table><tr><th>Campo</th><th>Detalle</th></tr><tr><td><b>Materia</b></td><td>Desarrollo Móvil Integral</td></tr><tr><td><b>Carrera</b></td><td>Ingeniería en Desarrollo y Gestión de Software</td></tr><tr><td><b>Docente</b></td><td>M.T.I. Marco A. Ramírez Hernández</td></tr><tr><td><b>Periodo</b></td><td>Septiembre - Diciembre</td></tr></table> | <table><tr><th>Campo</th><th>Detalle</th></tr><tr><td><b>Nombre</b></td><td>Edgar Cabrera</td></tr><tr><td><b>Matrícula</b></td><td>230496</td></tr><tr><td><b>Grupo</b></td><td>10 A°</td></tr><tr><td><b>Correo</b></td><td>230496@utxicotepec.edu.mx</td></tr></table> |

---

## Objetivo de la Práctica

Desarrollar una aplicación móvil robusta y escalable bajo los principios de **Clean Architecture**, integrando:
- **Capa de Dominio**: Entidades puras y contratos abstractos independientes de librerías y fuentes externas.
- **Capa de Infraestructura**: Consumo real de la API de TMDb (`/movie/now_playing`) mediante `Dio`, deserialización de modelos JSON (`MovieDbResponse`, `MovieMovieDB`), mapeo a entidades de negocio (`MovieMapper`) e implementación del repositorio (`MovieRepositoryImpl`).
- **Capa de Presentación con Riverpod**: Configuración de `ProviderScope`, creación de proveedores de repositorio (`movieRepositoryProvider`) y estado (`nowPlayingMoviesProvider`), implementación del ciclo de vida en `ConsumerStatefulWidget` para carga asíncrona paginada y renderizado reactivo con `ListView.builder`.
- **Configuración Global**: Seguridad de credenciales con `.env`, navegación centralizada con `GoRouter` y tematización dinámica Material 3.

---

## Tecnologías y Librerías Utilizadas

- **Flutter SDK (`^3.13.3+`)**: Framework multiplataforma para desarrollo móvil.
- **Dart**: Lenguaje fuertemente tipado.
- **Dio (`^5.11.1`)**: Cliente HTTP para solicitudes a TMDb con parámetros base configurados.
- **Flutter Riverpod (`^3.4.3`)**: Gestor de estado reactivo, inmutable y desacoplado del contexto de Flutter.
- **flutter_dotenv (`^6.0.1`)**: Carga segura de variables de entorno desde `.env`.
- **go_router (`^18.1.1`)**: Enrutador declarativo para navegación por URLs y nombres de ruta.
- **Material Design 3**: Directrices de diseño visual con soporte de `colorSchemeSeed`.

---

## Arquitectura del Proyecto

```
Practica06/cinemapedia/
├── .env.template                   # Plantilla de variables de entorno requeridas
├── .env                            # Archivo local con la API Key (ignorado en git)
├── lib/
│   ├── config/                     # Configuraciones globales de la aplicación
│   │   ├── constants/
│   │   │   └── environment.dart    # Acceso estático y seguro a variables de entorno
│   │   ├── router/
│   │   │   └── app_router.dart     # Definición de rutas y navegación con GoRouter
│   │   └── theme/
│   │       └── app_theme.dart      # Configuración de tema global Material 3
│   ├── domain/                     # Capa de Dominio (Reglas de negocio puras)
│   │   ├── datasources/
│   │   │   └── movies_datasource.dart   # Contrato abstracto para fuentes de datos
│   │   ├── entities/
│   │   │   └── movie.dart               # Entidad Movie nuclear de la aplicación
│   │   └── repositories/
│   │       └── movies_repository.dart   # Contrato abstracto del repositorio de películas
│   ├── infrastructure/             # Capa de Infraestructura (Implementaciones externas)
│   │   ├── datasources/
│   │   │   └── moviedb_datasource.dart  # Implementación de TMDb API mediante Dio
│   │   ├── mappers/
│   │   │   └── movie_mapper.dart        # Adaptador de modelos de API a entidades de negocio
│   │   ├── models/moviedb/
│   │   │   ├── movie_moviedb.dart       # Modelo individual de película devuelta por TMDb
│   │   │   └── moviedb_response.dart    # Respuesta paginada de la API de TMDb
│   │   └── repositories/
│   │       └── movie_repository_impl.dart # Implementación concreta del repositorio
│   ├── presentation/               # Capa de Presentación (UI y Estado)
│   │   ├── providers/              # Gestores de estado con Riverpod
│   │   │   ├── movies/
│   │   │   │   ├── movies_providers.dart           # StateNotifierProvider de películas en cartelera
│   │   │   │   └── movies_repository_provider.dart # Provider inmutable del repositorio
│   │   │   └── providers.dart                      # Archivo barril de providers
│   │   └── screens/                # Vistas y pantallas
│   │       ├── movies/
│   │       │   └── home_screen.dart     # Pantalla que consume Riverpod y lista películas
│   │       └── screens.dart             # Archivo barril de pantallas
│   └── main.dart                   # Punto de entrada, carga de .env y ProviderScope
├── test/
│   └── widget_test.dart            # Pruebas unitarias de la entidad Movie
└── pubspec.yaml                    # Dependencias y registro de assets
```

---

## Componentes Implementados

### 1. Capa de Dominio
- **`Movie`** (`lib/domain/entities/movie.dart`): Entidad pura con atributos esenciales de la película (`id`, `title`, `overview`, `posterPath`, `backdropPath`, `voteAverage`, etc.).
- **`MoviesDatasource`** & **`MoviesRepository`**: Interfaces que definen los métodos de acceso a datos sin acoplar la aplicación a ningún backend o librería específica:
  ```dart
  abstract class MoviesDatasource {
    Future<List<Movie>> getNowPlaying({ int page = 1 });
  }
  ```

### 2. Capa de Infraestructura
- **`MoviedbDatasource`**: Conexión a la API `https://api.themoviedb.org/3/movie/now_playing` con idioma `es-MX`.
- **`MovieMapper`**: Convierte objetos `MovieMovieDB` a la entidad `Movie`, resolviendo rutas completas de imágenes y valores predeterminados para evitar campos rotos o vacíos.
- **`MovieRepositoryImpl`**: Delega la obtención de películas al datasource provisto, facilitando el intercambio de fuentes de datos (ej. caché local o base de datos).

### 3. Capa de Presentación (Riverpod)
- **`movieRepositoryProvider`**: Expone una única instancia inmutable de `MovieRepositoryImpl`.
- **`nowPlayingMoviesProvider`**: Gestiona la lista acumulativa de películas en memoria y provee el método `loadNextPage()` para realizar solicitudes paginadas subsecuentes.
- **`HomeScreen` (`_HomeView`)**: `ConsumerStatefulWidget` que en su `initState` invoca la carga inicial (`ref.read(...).loadNextPage()`) y mediante `ref.watch(nowPlayingMoviesProvider)` redibuja un `ListView.builder` dinámicamente con los títulos de las películas en cartelera.
- **`main.dart`**: Envuelve la raíz de la aplicación con `ProviderScope`.

---

## Instrucciones de Instalación y Ejecución

1. Navegar al directorio del proyecto:
   ```bash
   cd Practica06/cinemapedia
   ```

2. Configurar el archivo de variables de entorno:
   - Duplicar el archivo `.env.template` como `.env`:
     ```bash
     cp .env.template .env
     ```
   - Asignar una clave válida de The Movie DB:
     ```env
     THE_MOVIEDB_KEY=tu_api_key_aqui
     ```

3. Instalar las dependencias de Flutter:
   ```bash
   flutter pub get
   ```

4. Ejecutar la suite de pruebas unitarias:
   ```bash
   flutter test
   ```

5. Iniciar la aplicación en emulador o dispositivo físico:
   ```bash
   flutter run
   ```
