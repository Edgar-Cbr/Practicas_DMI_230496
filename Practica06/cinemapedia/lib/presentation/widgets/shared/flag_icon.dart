import 'package:flutter/material.dart';

/// Bandera dibujada en código para compatibilidad multiplataforma completa
/// (los emojis de bandera no se renderizan nativamente en Windows desktop).
class FlagIcon extends StatelessWidget {
  final String country; // MX, US, DE, FR, JP
  final double width;

  const FlagIcon({super.key, required this.country, this.width = 40});

  @override
  Widget build(BuildContext context) {
    final height = width * 2 / 3;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomPaint(
          size: Size(width, height),
          painter: _FlagPainter(country),
        ),
      ),
    );
  }
}

class _FlagPainter extends CustomPainter {
  final String country;

  _FlagPainter(this.country);

  @override
  void paint(Canvas canvas, Size size) {
    switch (country) {
      case 'MX':
        _mexico(canvas, size);
        break;
      case 'US':
        _usa(canvas, size);
        break;
      case 'DE':
        _germany(canvas, size);
        break;
      case 'FR':
        _france(canvas, size);
        break;
      case 'JP':
        _japan(canvas, size);
        break;
      default:
        canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey);
    }
  }

  void _fill(Canvas c, Rect r, Color color) => c.drawRect(r, Paint()..color = color);

  void _mexico(Canvas c, Size s) {
    final w = s.width / 3;
    _fill(c, Rect.fromLTWH(0, 0, w, s.height), const Color(0xFF006847));
    _fill(c, Rect.fromLTWH(w, 0, w, s.height), Colors.white);
    _fill(c, Rect.fromLTWH(w * 2, 0, w + 1, s.height), const Color(0xFFCE1126));
    c.drawCircle(
      Offset(s.width / 2, s.height / 2),
      s.height * 0.16,
      Paint()..color = const Color(0xFF8C6B3F),
    );
  }

  void _usa(Canvas c, Size s) {
    final stripe = s.height / 13;
    for (var i = 0; i < 13; i++) {
      _fill(
        c,
        Rect.fromLTWH(0, i * stripe, s.width, stripe + 0.5),
        i.isEven ? const Color(0xFFB22234) : Colors.white,
      );
    }
    final canton = Rect.fromLTWH(0, 0, s.width * 0.4, stripe * 7);
    _fill(c, canton, const Color(0xFF3C3B6E));

    final dot = Paint()..color = Colors.white;
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 5; col++) {
        c.drawCircle(
          Offset(
            canton.width * (col + 0.7) / 5.4,
            canton.height * (row + 0.7) / 4.4,
          ),
          s.height * 0.035,
          dot,
        );
      }
    }
  }

  void _germany(Canvas c, Size s) {
    final h = s.height / 3;
    _fill(c, Rect.fromLTWH(0, 0, s.width, h), Colors.black);
    _fill(c, Rect.fromLTWH(0, h, s.width, h), const Color(0xFFDD0000));
    _fill(c, Rect.fromLTWH(0, h * 2, s.width, h + 1), const Color(0xFFFFCE00));
  }

  void _france(Canvas c, Size s) {
    final w = s.width / 3;
    _fill(c, Rect.fromLTWH(0, 0, w, s.height), const Color(0xFF002395));
    _fill(c, Rect.fromLTWH(w, 0, w, s.height), Colors.white);
    _fill(c, Rect.fromLTWH(w * 2, 0, w + 1, s.height), const Color(0xFFED2939));
  }

  void _japan(Canvas c, Size s) {
    _fill(c, Offset.zero & s, Colors.white);
    c.drawCircle(
      Offset(s.width / 2, s.height / 2),
      s.height * 0.28,
      Paint()..color = const Color(0xFFBC002D),
    );
  }

  @override
  bool shouldRepaint(_FlagPainter old) => old.country != country;
}
