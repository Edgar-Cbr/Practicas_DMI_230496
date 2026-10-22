import 'package:flutter/material.dart';


class VideoBackground extends StatelessWidget {
  final List<Color>? colors;
  final List<double>? stops;

  const VideoBackground({
    super.key,
    this.colors,
    this.stops,
  });

  @override
  Widget build(BuildContext context) {
    // Si no se especifican colores, aplicamos un gradiente cinematográfico:
    // sombra suave arriba para la barra de navegación y reloj, y sombra
    // progresiva abajo para textos de descripción y botones.
    final gradientColors = colors ??
        const [
          Color(0x99000000), // ~60% negro arriba
          Color(0x00000000), // transparente
          Color(0x00000000), // transparente
          Color(0x80000000), // ~50% negro
          Color(0xD9000000), // ~85% negro al fondo
        ];

    final gradientStops = stops ?? const [0.0, 0.22, 0.60, 0.82, 1.0];

    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              stops: gradientStops,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}