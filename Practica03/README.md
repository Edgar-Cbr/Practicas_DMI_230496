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

La aplicación sigue los principios de **Clean Architecture** dividida en capas desacopladas.

[Ver diagrama interactivo en GitHub Pages](https://Edgar-Cbr.github.io/Practicas_DMI_230496/Practica03/yes_no_app/arquitectura-yes_no_app.html)

[![Captura del diagrama de arquitectura](./yes_no_app/arquitectura-yes_no_app.visual-check.1440x900.light.png)](https://Edgar-Cbr.github.io/Practicas_DMI_230496/Practica03/yes_no_app/arquitectura-yes_no_app.html)

---

## Descripción de la solución

1. **Entidades de Dominio (`Message` y `FromWho`)**:
   - `Message` encapsula el texto, la URL opcional de la imagen GIF, la autoría (`FromWho.me` o `FromWho.hers`) y la fecha/hora de envío (`sentAt`).
2. **Infraestructura (`YesNoModel`)**:
   - Mapea la estructura JSON recibida (`answer`, `forced`, `image`) y expone el método `toMessageEntity()` traduciendo `'yes'` a `'Sí'`, `'no'` a `'No'` y cualquier otra opción a `'Tal Vez'`.
3. **Petición HTTP y Reglas de Probabilidad (`GetYesNoAnswer`)**:
   - Realiza la consulta `GET` asíncrona a `https://yesno.wtf/api` utilizando `dio`.
   - Distribución de probabilidad controlada: **40 % Sí, 40 % No y 20 % Tal Vez** mediante el parámetro de consulta `force` (`['yes', 'yes', 'no', 'no', 'maybe']`).
4. **Gestión de Estado (`ChatProvider`)**:
   - Administra la lista de mensajes reactiva `messageList`.
   - Si un mensaje enviado termina en `'?'`, invoca automáticamente la función `herReply()` para consultar la API.
   - Implementa `moveScrollToBottom()` asegurando renderizado con `addPostFrameCallback` para desplazar automáticamente la vista al último mensaje recibido con animación suave (`Curves.easeOut`).
5. **Interfaz de Usuario y Widgets Personalizados**:
   - `ChatScreen`: Barra superior con avatar e imagen remota, estructurada en un `SafeArea` con `Column`.
   - `MyMessageBubble`: Burbuja con color primario del tema para los mensajes enviados por el usuario, mostrando el texto y la hora de envío (`TimeOfDay`).
   - `HerMessageBubble`: Burbuja con color secundario que muestra la hora de envío e incluye `_ImageBubble` con un `loadingBuilder` para mostrar el estado de carga del GIF animado devuelto por la API.
   - `MessageFieldBox`: Campo de texto con `OutlineInputBorder` redondeado, función de `trim()` para evitar mensajes vacíos, `FocusNode` y `TextEditingController`.
6. **Personalización del Ícono de la Aplicación**:
   - Generación de iconos adaptativos y estándar para Android e iOS mediante el paquete `flutter_launcher_icons`.

---

## Resultados obtenidos

- Desacoplamiento total entre las reglas de negocio, la capa de datos externa y la interfaz de usuario.
- Comunicación bidireccional simulada en tiempo real con respuestas animadas y probabilidades controladas (40% Sí, 40% No, 20% Tal Vez).
- Registro visual de la hora local en cada burbuja de chat.
- Experiencia fluida con desplazamiento automático del scroll al ingresar nuevos mensajes.
- Íconos personalizados en el sistema operativo.

---

## Evidencia de funcionamiento

| Pantalla de Chat Inicial | Pregunta del Usuario | Respuesta con GIF |
|:---:|:---:|:---:|
| Conversación con mensajes predeterminados | Detección de signo de interrogación `?` | Renderizado de respuesta ('Si' / 'No') y GIF animado |
