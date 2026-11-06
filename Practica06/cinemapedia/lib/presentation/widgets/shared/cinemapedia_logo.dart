import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Logo oficial de Cinemapedia:
/// Un emblema cinematográfico moderno con un prisma de reproducción ("Play")
/// luminoso en el centro y un escudo hexagonal facetado con muescas de claqueta.
///
/// El parámetro [progress] permite animar el trazo del logotipo de 0 (inicio) a 1 (completo).
class CinemapediaLogo extends StatelessWidget {
  final double size;
  final double progress;

  const CinemapediaLogo({
    super.key,
    this.size = 28,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: CinemapediaLogoPainter(progress: progress),
    );
  }
}

class CinemapediaLogoPainter extends CustomPainter {
  final double progress;

  CinemapediaLogoPainter({required this.progress});

  // Paleta moderna cinematográfica
  static const _violet = Color(0xFF8B5CF6);
  static const _cyan = Color(0xFF06B6D4);
  static const _pink = Color(0xFFEC4899);
  static const _deep = Color(0xFF16122A);

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    if (side <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = (side / 2) * 0.88;
    final strokeWidth = math.max(1.8, side * 0.07);

    final currentProgress = progress.clamp(0.0, 1.0);

    // 1. Fondo interior oscuro del escudo
    if (currentProgress > 0.2) {
      final bgOpacity = ((currentProgress - 0.2) / 0.8).clamp(0.0, 1.0);
      final bgPaint = Paint()
        ..color = _deep.withValues(alpha: 0.85 * bgOpacity)
        ..style = PaintingStyle.fill;

      final hexPath = _buildHexagonPath(Offset(cx, cy), r);
      canvas.drawPath(hexPath, bgPaint);
    }

    // 2. Trazo hexagonal exterior progresivo
    if (currentProgress > 0.0) {
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_violet, _cyan, _pink],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));

      final hexPath = _buildHexagonPath(Offset(cx, cy), r);

      // Extraer solo la porción correspondiente a progress
      final pathMetrics = hexPath.computeMetrics();
      for (final metric in pathMetrics) {
        final extractLength = metric.length * math.min(1.0, currentProgress * 1.25);
        final extracted = metric.extractPath(0, extractLength);
        canvas.drawPath(extracted, borderPaint);
      }
    }

    // 3. Muescas superiores de claqueta de cine
    if (currentProgress >= 0.5) {
      final notchProgress = ((currentProgress - 0.5) / 0.5).clamp(0.0, 1.0);
      final notchPaint = Paint()
        ..color = _pink.withValues(alpha: notchProgress)
        ..strokeWidth = math.max(1.5, strokeWidth * 0.65)
        ..strokeCap = StrokeCap.round;

      for (int k = -2; k <= 2; k++) {
        final tickX = cx + k * (side * 0.08);
        final tickY1 = cy - r * 0.72;
        final tickY2 = cy - r * 0.54;
        canvas.drawLine(Offset(tickX, tickY1), Offset(tickX, tickY2), notchPaint);
      }
    }

    // 4. Prisma central de reproducción ("Play") con brillo
    if (currentProgress >= 0.35) {
      final playProgress = ((currentProgress - 0.35) / 0.65).clamp(0.0, 1.0);
      final playScale = playProgress;
      final playR = (side * 0.22) * playScale;
      final optOffset = side * 0.025 * playScale;

      final playPath = Path();
      final p1 = Offset(cx - playR * 0.65 + optOffset, cy - playR * 0.85);
      final p2 = Offset(cx + playR * 1.05 + optOffset, cy);
      final p3 = Offset(cx - playR * 0.65 + optOffset, cy + playR * 0.85);

      playPath.moveTo(p1.dx, p1.dy);
      playPath.lineTo(p2.dx, p2.dy);
      playPath.lineTo(p3.dx, p3.dy);
      playPath.close();

      // Relleno gradiente del triángulo
      final playPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [Color(0xFF22D3EE), Color(0xFFF43F5E), Color(0xFF8B5CF6)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: playR));

      canvas.drawPath(playPath, playPaint);

      // Trazo fino blanco para resaltar bordes
      final playBorder = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withValues(alpha: 0.85 * playProgress)
        ..strokeWidth = math.max(1.0, strokeWidth * 0.3)
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(playPath, playBorder);
    }
  }

  Path _buildHexagonPath(Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CinemapediaLogoPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
