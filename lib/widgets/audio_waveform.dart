import 'package:av/av_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWaveform extends StatefulWidget {
  const AudioWaveform(
      {super.key,
      this.height = 300.0,
      this.barWidth = 5.0,
      this.barSpace = 2.0});

  final double height;
  final double barWidth;
  final double barSpace;

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform> {
  final List<Map> _segments = [];

  @override
  void initState() {
    super.initState();
    AvPlatformInterface.instance.getEventStream().listen((event) {
      if (event['type'] == 'audioRecorder/metered') {
        final newAmplitude = event['payload']['avgAmplitude'];

        // Chop amplitudes into segments of 100 because the painter can't handle large paths
        if (_segments.isNotEmpty &&
            _segments.last['amplitudes'] != null &&
            _segments.last['amplitudes'].length < 100) {
          final height = widget.height;
          final halfHeight = height / 2;
          final x = _segments.last['amplitudes'].length *
              (widget.barWidth + widget.barSpace);
          final y = halfHeight;
          final rect = Rect.fromCenter(
              center: Offset(x, y),
              width: widget.barWidth,
              height: newAmplitude * height);

          setState(() {
            _segments.last['amplitudes'].add(newAmplitude);
            _segments.last['path'].addRRect(
                RRect.fromRectAndRadius(rect, const Radius.circular(5.0)));
          });
        } else {
          final height = widget.height;
          final halfHeight = height / 2;
          const x = 0.0;
          final y = halfHeight;
          final rect = Rect.fromCenter(
              center: Offset(x, y),
              width: widget.barWidth,
              height: newAmplitude * height);
          final path = Path();
          path.addRRect(
              RRect.fromRectAndRadius(rect, const Radius.circular(5.0)));
          setState(() {
            _segments.add({
              'amplitudes': [newAmplitude],
              'path': path
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: Row(children: [
            for (var segmentIndex = 0;
                segmentIndex < _segments.length;
                segmentIndex++)
              AudioWaveformSegment(
                path: _segments[segmentIndex]['path'],
                size: Size(
                    _segments[segmentIndex]['amplitudes'].isNotEmpty
                        ? _segments[segmentIndex]['amplitudes'].length *
                                widget.barWidth +
                            (_segments[segmentIndex]['amplitudes'].length - 1) *
                                widget.barSpace
                        : 0.0,
                    widget.height),
                barWidth: widget.barWidth,
              )
          ]),
        )
      ],
    );
  }
}

class AudioWaveformSegment extends StatelessWidget {
  const AudioWaveformSegment({
    super.key,
    required this.size,
    required this.path,
    required this.barWidth,
  });

  final Size size;
  final Path path;
  final double barWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _AudioWaveformSegmentPainter(path: path, barWidth: barWidth),
    );
  }
}

class _AudioWaveformSegmentPainter extends CustomPainter {
  _AudioWaveformSegmentPainter({
    required this.path,
    this.barWidth = 2.0,
  });

  final Path path;
  final double barWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = CupertinoColors.black;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AudioWaveformSegmentPainter oldDelegate) {
    return false;
  }
}
