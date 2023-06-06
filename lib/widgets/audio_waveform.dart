import 'package:flutter/cupertino.dart';

class AudioWaveform extends StatelessWidget {
  AudioWaveform({super.key, this.amplitudes = const []});

  final List<num> amplitudes;

  // final ScrollController _scrollController = ScrollController();

  // void _scrollToCenter() {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // controller: _scrollController,
      scrollDirection: Axis.horizontal,
      children: [
        CustomPaint(
          size: Size(double.infinity, 500),
          painter: _AudioWaveformPainter(amplitudes: amplitudes),
        )
      ],
    );
  }
}

class _AudioWaveformPainter extends CustomPainter {
  _AudioWaveformPainter({required this.amplitudes});

  final List<num> amplitudes;
  // final Function onMove;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final sampleCount = amplitudes.length;
    // final sampleWidth = width / sampleCount;
    // final sampleWidth = 1.0;
    final halfHeight = height / 2;

    for (var i = 0; i < sampleCount; i++) {
      final amplitude = amplitudes[i];
      // final x = i * sampleWidth;
      final x = i.toDouble() * 5;
      // final y = halfHeight + (sample / 255) * halfHeight;
      // final y = halfHeight + (amplitude * halfHeight);
      final y = halfHeight;
      print("x: $x, y: $y");
      path.moveTo(x, y);
      final rect = Rect.fromCenter(
          center: Offset(x, y), width: 2, height: amplitude * height);
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(1.0)));
      // onMove(x);
      // path.addRRect(RRect.fromLTRBR(
      //     x, y, x + 2, amplitude * halfHeight, Radius.circular(1.0)));
      // path.lineTo(x, halfHeight - (level.abs() * halfHeight));

      // if (i == 0) {
      // } else {
      //   path.lineTo(x, y);
      // }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AudioWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
