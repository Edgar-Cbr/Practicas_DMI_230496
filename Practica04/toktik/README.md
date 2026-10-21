# Práctica 04 — TokTik

## Descripción

TokTik es una aplicación Flutter de videos cortos. Reúne publicaciones locales
y contenido de proveedores externos en feeds independientes, permite
interactuar con los videos y personaliza la experiencia con temas estacionales.
La app separa presentación, lógica de dominio, repositorios y fuentes de datos.


## Diagrama de arquitectura

El diagrama representa la separación por capas de TokTik: presentación, gestión de estado con Providers, lógica de dominio, repositorios, datasources remotos y locales, y persistencia.

[Abrir diagrama interactivo en GitHub Pages](https://Edgar-Cbr.github.io/Practicas_DMI_230496/Practica04/toktik/arquitectura-toktik/arquitectura-toktik.html)

[![Vista previa del diagrama de arquitectura](./arquitectura-toktik/arquitectura-toktik.visual-check.1440x900.dark.png)](https://Edgar-Cbr.github.io/Practicas_DMI_230496/Practica04/toktik/arquitectura-toktik/arquitectura-toktik.html)

```mermaid
graph TD
    subgraph Presentacion["Capa de Presentación"]
        DS[DiscoverScreen<br><i>Navegación y configuración</i>]
        VSV[VideoScrollableView<br><i>Feed vertical y reproductores</i>]
        DS --> VSV
    end

    subgraph State["Gestión de Estado (Providers)"]
        DP[DiscoverProvider<br><i>Paginación y feed</i>]
        LP[LikesProvider<br><i>Likes y favoritos</i>]
        TP[ThemeProvider<br><i>Temas e iconos de temporada</i>]
    end

    VSV --> DP
    VSV --> LP
    DS --> TP

    subgraph Dominio["Capa de Dominio"]
        VFR["&lt;&lt;interface&gt;&gt;<br>VideoFeedRepository"]
        VP[VideoPost<br><i>Entidad de dominio</i>]
    end

    DP --> VFR
    VFR -.-> VP

    subgraph Infraestructura["Infraestructura y Repositorios"]
        VFRI[VideoFeedRepositoryImpl]
        LVD[LocalVideoDatasource]
        YTA[YoutubeDataApi]
        GIA[GiphyApi]
        DMA[DailymotionApi]
        VPD[VideoPreferencesDatasource]
        LIS[LauncherIconService]
    end

    VFRI -- Implementa --> VFR
    VFRI --> LVD
    VFRI --> YTA
    VFRI --> GIA
    VFRI --> DMA

    LP --> VPD
    TP --> VPD
    TP --> LIS

    subgraph Externo["Servicios Externos y Persistencia"]
        YT[(YouTube Data API v3)]
        GI[(GIPHY API)]
        DM[(Dailymotion API)]
        SP[(SharedPreferences)]
        ASSETS[(Assets locales .mp4)]
        NAT[(Icono Nativo / MethodChannel)]
    end

    YTA --> YT
    GIA --> GI
    DMA --> DM
    LVD --> ASSETS
    VPD --> SP
    LIS --> NAT
```


## Funcionalidades

### Feeds y reproducción

- **Discover:** combina videos locales con resultados de YouTube, GIPHY y
  Dailymotion. Carga más resultados al acercarse al final del feed y evita
  repetir videos al anexar páginas.
- **For You:** presenta una selección de tendencias de las fuentes disponibles.
- **Favorites:** muestra los videos marcados con «Me gusta».
- Los tres feeds se recorren verticalmente; el cambio de sección y los botones
  de navegación permiten pasar entre Discover, For You y Favorites.
- Reproduce videos incluidos en la app, videos de YouTube, GIFs/videos de GIPHY
  y videos de Dailymotion.
- Los fallos de un proveedor no impiden mostrar resultados disponibles de los
  otros proveedores ni los videos locales.

### Interacción y preferencias

- El botón de sonido activa o silencia el video y mantiene esa elección al
  cambiar de video durante la sesión.
- Tocar el corazón cambia el estado de «Me gusta»; un doble toque sobre el
  video también lo marca como favorito.
- Los estados de «Me gusta» y sus conteos se guardan localmente con
  `SharedPreferences`, por lo que sobreviven al cierre de la app mientras no se
  borren sus datos.
- Las descripciones extensas se pueden expandir con «... más» y leer con
  desplazamiento vertical.
- Hay un video local de prueba con cero likes y cero comentarios para comprobar
  el estado inicial y la persistencia del conteo.

### Temas por temporada e icono

- Incluye los temas **Normal**, **Halloween**, **Christmas** y
  **Valentine's Day**, con sus paletas, tipografías, iconografía y avisos
  auditivos.
- El modo automático selecciona el tema usando la fecha local del dispositivo:
  Halloween en octubre, Christmas en diciembre, Valentine's Day en febrero y
  Normal el resto del año.
- Para probar otra temporada, abre el botón de tema en la parte superior y
  selecciona una opción. La selección manual se guarda y permanece tras cerrar
  y volver a abrir la app, hasta elegir otro tema o regresar a **Automático por
  fecha**.
- El icono de inicio del dispositivo se actualiza para corresponder con el tema
  seleccionado y se vuelve a aplicar al iniciar la app.
- El aviso auditivo que acompaña el cambio de tema se puede activar o desactivar
  desde el mismo menú.

## Arquitectura

La interfaz consume proveedores de estado de presentación. `DiscoverProvider`
obtiene las secciones mediante el contrato `VideoFeedRepository`; su
implementación combina los resultados de `LocalVideoDatasourceImpl`,
`YoutubeDataApi`, `GiphyApi` y `DailymotionApi`. Discover maneja la paginación
de las fuentes que ofrecen continuación.

`LikesProvider` gestiona los likes, los conteos y la lista de favoritos.
`ThemeProvider` resuelve la temporada automática o manual, las preferencias de
sonido y la selección del icono. Ambos persisten preferencias mediante
`VideoPreferencesDatasource` y `SharedPreferences`.

## Tecnologías principales

- **Flutter y Dart:** interfaz multiplataforma.
- **Provider:** estado de presentación.
- **Repositorios y datasources:** separación entre dominio y fuentes de video.
- **SharedPreferences:** persistencia local de likes, temas y preferencias.
- **video_player:** reproducción de videos locales y archivos MP4 remotos.
- **youtube_player_iframe:** reproducción de YouTube.
- **webview_flutter:** integración del reproductor de Dailymotion.
- **http:** solicitudes a las API de video.

## Configuración

Los videos locales están en `assets/videos/`. Para usar YouTube y GIPHY,
crea un archivo `env.json` en la raíz de este proyecto (`toktik`) con las claves
de API correspondientes:

```json
{
  "YOUTUBE_API_KEY": "TU_CLAVE_DE_YOUTUBE",
  "YOUTUBE_SEARCH_QUERY": "musica",
  "GIPHY_API_KEY": "TU_CLAVE_DE_GIPHY",
  "GIPHY_SEARCH_QUERY": "funny"
}
```

El archivo `env.json` es opcional para iniciar la aplicación y ver los videos
locales. Si faltan claves, las fuentes que las necesitan mostrarán un aviso.
Dailymotion se consulta mediante su API pública.

No agregues claves reales al control de versiones. Las claves incluidas en una
aplicación cliente pueden extraerse; para producción, restrínjelas o utiliza un
backend.

## Ejecutar y validar

Desde la carpeta `Practica04/toktik`:

```bash
flutter pub get
flutter run --dart-define-from-file=env.json
```

Para iniciar sin `env.json`, ejecuta `flutter run`. Para validar el proyecto:

```bash
flutter analyze
flutter test
```

Para generar una compilación de depuración Android:

```bash
flutter build apk --debug
```

## Autor

- Edgar Cabrera (230496)