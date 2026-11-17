import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Nuevo Logotipo oficial de Cinemapedia:
/// "Solaris Cinema Aperture" — Un emblema de lente de cámara cinematográfica
/// de alta precisión con aspas de obturador en oro ámbar, acentos láser cian
/// y un prisma central de reproducción ("Play") luminoso.
///
/// El parámetro [progress] permite animar el trazo del logotipo de 0 a 1 en el SplashScreen.
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

  // Paleta de Oro & Titanio Cinematográfico
  static const _goldBright = Color(0xFFFBBF24);
  static const _goldDeep = Color(0xFFD97706);
  static const _cyanNeon = Color(0xFF06B6D4);
  static const _darkCore = Color(0xFF10131F);
  static const _whiteGlow = Color(0xFFFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    if (side <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final r = side * 0.46;

    final p = progress.clamp(0.0, 1.0);

    // 1. Aura circular de fondo
    if (p > 0.1) {
      final glowPaint = Paint()
        ..color = _goldDeep.withValues(alpha: 0.18 * p)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, r * 0.96, glowPaint);
    }

    // 2. Anillo exterior de película / carrete
    final ringPaint = Paint()
      ..color = _goldBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.8, side * 0.055)
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * p;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 0.88),
      -math.pi / 2,
      sweepAngle,
      false,
      ringPaint,
    );

    // 3. Aspas de la apertura cinematográfica (6 aspas geométricas en espiral)
    if (p > 0.3) {
      final bladeProgress = ((p - 0.3) / 0.7).clamp(0.0, 1.0);
      const bladeCount = 6;
      final bladeR = r * 0.76;
      final innerR = r * 0.32;

      for (int i = 0; i < bladeCount; i++) {
        final baseAngle = (i * 2 * math.pi / bladeCount) + (bladeProgress * 0.4);
        final nextAngle = ((i + 1) * 2 * math.pi / bladeCount) + (bladeProgress * 0.4);

        final p1 = Offset(
          cx + innerR * math.cos(baseAngle),
          cy + innerR * math.sin(baseAngle),
        );
        final p2 = Offset(
          cx + bladeR * math.cos(baseAngle + 0.3),
          cy + bladeR * math.sin(baseAngle + 0.3),
        );
        final p3 = Offset(
          cx + bladeR * math.cos(nextAngle),
          cy + bladeR * math.sin(nextAngle),
        );

        final bladePath = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy)
          ..lineTo(p3.dx, p3.dy)
          ..close();

        final bladeColor = (i % 2 == 0)
            ? _goldDeep.withValues(alpha: 0.85 * bladeProgress)
            : _darkCore.withValues(alpha: 0.95 * bladeProgress);

        final bladeFill = Paint()
          ..color = bladeColor
          ..style = PaintingStyle.fill;

        canvas.drawPath(bladePath, bladeFill);

        final bladeStroke = Paint()
          ..color = _goldBright.withValues(alpha: 0.6 * bladeProgress)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, side * 0.02);

        canvas.drawPath(bladePath, bladeStroke);
      }
    }

    // 4. Borde neón cian fino alrededor del núcleo
    if (p > 0.5) {
      final cyanPaint = Paint()
        ..color = _cyanNeon.withValues(alpha: 0.8 * ((p - 0.5) / 0.5))
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, side * 0.035);

      canvas.drawCircle(center, r * 0.36, cyanPaint);
    }

    // 5. Prisma de reproducción ("Play") en el centro
    if (p > 0.6) {
      final playProgress = ((p - 0.6) / 0.4).clamp(0.0, 1.0);
      final playSize = r * 0.28 * playProgress;

      final pt1 = Offset(cx - playSize * 0.65, cy - playSize * 0.8);
      final pt2 = Offset(cx - playSize * 0.65, cy + playSize * 0.8);
      final pt3 = Offset(cx + playSize * 0.95, cy);

      final playPath = Path()
        ..moveTo(pt1.dx, pt1.dy)
        ..lineTo(pt2.dx, pt2.dy)
        ..lineTo(pt3.dx, pt3.dy)
        ..close();

      final playPaint = Paint()
        ..color = _whiteGlow
        ..style = PaintingStyle.fill;

      canvas.drawPath(playPath, playPaint);
    }
  }

  @override
  bool shouldRepaint(CinemapediaLogoPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
