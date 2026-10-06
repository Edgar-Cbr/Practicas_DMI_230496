# Practica 03 - Yes, No, Maybe (Chat App)

Chat interactivo en Flutter con respuestas automáticas y GIFs mediante la API yesno.wtf.

**(30) firmas**

## Objetivo de la práctica

Desarrollar una aplicación de mensajería interactiva ("Yes No App") implementando una arquitectura limpia (Clean Architecture), gestión de estado reactivo mediante `provider`, peticiones asíncronas HTTP con `dio` y el consumo de una API REST externa (`https://yesno.wtf/api`) para generar respuestas aleatorias acompañadas de GIFs animados cuando el usuario realiza una pregunta terminada con el signo `?`.

---

## Tecnologías utilizadas

- **Flutter & Dart**: Entorno de desarrollo para aplicaciones móviles multiplataforma.
- **Provider (`provider: ^6.1.5`)**: Gestor de estado reactivo basado en `ChangeNotifier` para notificar actualizaciones a la UI sin recrear widgets innecesariamente.
- **Dio (`dio: ^5.11.1`)**: Cliente HTTP avanzado para realizar peticiones REST asíncronas y tipificadas.
- **YesNo API (`https://yesno.wtf/api`)**: Servicio externo REST que retorna respuestas booleanas (`yes`, `no`, `maybe`) junto a la URL de un GIF animado.
- **Material Design 3**: Widgets modernos (`Scaffold`, `AppBar`, `CircleAvatar`, `ListView.builder`, `TextFormField`, `ClipRRect`).

---

## Arquitectura de Software

La aplicación sigue los principios de **Clean Architecture** dividida en cuatro capas desacopladas:

```
yes_no_app/
├── lib/
│   ├── config/
│   │   ├── helpers/
│   │   │   └── get_yes_no_answer.dart       # Petición HTTP a la API yesno.wtf mediante Dio
│   │   └── theme/
│   │       └── app_theme.dart               # Configuración del tema y paleta de colores Material 3
│   ├── domain/
│   │   └── entities/
│   │       └── message.dart                 # Entidad pura del mensaje (texto, imagen, emisor)
│   ├── infrastructure/
│   │   └── models/
│   │       └── yes_no_model.dart            # Mapeo del JSON de respuesta de la API a la entidad
│   ├── presentation/
│   │   ├── providers/
│   │   │   └── chat_provider.dart           # Gestor de estado: lista de mensajes, envío, auto-scroll
│   │   ├── screens/
│   │   │   └── chat/
│   │   │       └── chat_screen.dart         # Pantalla principal con AppBar y lista de mensajes
│   │   └── widgets/
│   │       ├── chat/
│   │       │   ├── my_message_bubble.dart   # Burbuja del usuario (alineada a la derecha)
│   │       │   └── her_message_bubble.dart  # Burbuja de respuesta con GIF y loader
│   │       └── shared/
│   │           └── message_field_box.dart   # Caja de texto con botón de envío y control de foco
│   └── main.dart                            # Punto de entrada y configuración de MultiProvider
```

---

## Descripción de la solución

1. **Entidades de Dominio (`Message` y `FromWho`)**:
   - `Message` encapsula el texto, la URL opcional de la imagen GIF y la autoría (`FromWho.me` o `FromWho.hers`).
2. **Infraestructura (`YesNoModel`)**:
   - Mapea la estructura JSON recibida (`answer`, `forced`, `image`) y expone el método `toMessageEntity()` traduciendo `'yes'` a `'Si'` y `'no'` a `'No'`.
3. **Petición HTTP (`GetYesNoAnswer`)**:
   - Realiza la consulta `GET` asíncrona a `https://yesno.wtf/api` utilizando `dio`.
4. **Gestión de Estado (`ChatProvider`)**:
   - Administra la lista de mensajes reactiva `messageList`.
   - Si un mensaje enviado termina en `'?'`, invoca automáticamente la función `herReply()` para consultar la API.
   - Implementa `moveScrollToBottom()` para desplazar automáticamente la vista al último mensaje recibido con animación suave (`Curves.easeOut`).
5. **Interfaz de Usuario y Widgets Personalizados**:
   - `ChatScreen`: Barra superior con avatar e imagen remota, estructurada en un `SafeArea` con `Column`.
   - `MyMessageBubble`: Burbuja con color primario del tema para los mensajes enviados por el usuario.
   - `HerMessageBubble`: Burbuja con color secundario que incluye `_ImageBubble` con un `loadingBuilder` para mostrar el estado de carga del GIF animado.
   - `MessageFieldBox`: Campo de texto con `OutlineInputBorder` redondeado, `FocusNode` y `TextEditingController` para limpiar y reenfocar al enviar.

---

## Resultados obtenidos

- Desacoplamiento total entre las reglas de negocio, la capa de datos externa y la interfaz de usuario.
- Comunicación bidireccional simulada en tiempo real con respuestas animadas.
- Experiencia fluida con desplazamiento automático del scroll al ingresar nuevos mensajes.
- Cumplimiento al 100% de las especificaciones de la rama `fin-seccion-6` del curso de Fernando Herrera.

---

## Evidencia de funcionamiento

| Pantalla de Chat Inicial | Pregunta del Usuario | Respuesta con GIF |
|:---:|:---:|:---:|
| Conversación con mensajes predeterminados | Detección de signo de interrogación `?` | Renderizado de respuesta ('Si' / 'No') y GIF animado |
