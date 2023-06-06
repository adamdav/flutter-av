import 'package:flutter/cupertino.dart';

class AudioWaveform extends StatelessWidget {
  const AudioWaveform(
      {super.key,
      this.amplitudes = const [],
      this.barWidth = 2.0,
      this.barSpace = 1.0});

  final List<num> amplitudes;
  final double barWidth;
  final double barSpace;

  @override
  Widget build(BuildContext context) {
    final width =
        amplitudes.length * barWidth + (amplitudes.length - 1) * barSpace;
    return CustomPaint(
      size: Size(width, 500),
      painter: _AudioWaveformPainter(amplitudes: amplitudes),
    );
  }
}

class _AudioWaveformPainter extends CustomPainter {
  _AudioWaveformPainter(
      {required this.amplitudes, this.barWidth = 2.0, this.barSpace = 1.0});

  final List<num> amplitudes;
  final double barWidth;
  final double barSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.black
      ..strokeWidth = barWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final sampleCount = amplitudes.length;
    final halfHeight = height / 2;

    for (var i = 0; i < sampleCount; i++) {
      final amplitude = amplitudes[i];
      final x = i.toDouble() * (2 * barWidth + barSpace);
      final y = halfHeight;
      path.moveTo(x, y);
      final rect = Rect.fromCenter(
          center: Offset(x, y), width: barWidth, height: amplitude * height);
      path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(1.0)));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AudioWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
