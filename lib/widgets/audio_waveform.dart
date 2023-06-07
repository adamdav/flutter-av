import 'package:av/av_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWaveform extends StatefulWidget {
  const AudioWaveform(
      {super.key,
      // this.amplitudes = const [],
      this.height = 200.0,
      this.barWidth = 2.0,
      this.barSpace = 3.0});

  // final List<num> amplitudes;
  final double height;
  final double barWidth;
  final double barSpace;

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform> {
  final Path _path = Path();

  List<double> _amplitudes = [];
  // double _x = 0.0;
  // double _waveformRight = 0.0;

  @override
  void initState() {
    super.initState();
    AvPlatformInterface.instance.getEventStream().listen((event) {
      if (event['type'] == 'audioRecorder/metered') {
        //print(event['payload']);
        final newAmplitude = event['payload']['avgAmplitude'];
        final height = widget.height;
        final halfHeight = height / 2;

        // for (var i = 0; i < _amplitudes.length; i++) {
        // final amplitude = _amplitudes[i];
        final x = _amplitudes.length * (widget.barWidth + widget.barSpace);
        final y = halfHeight;
        final rect = Rect.fromCenter(
            center: Offset(x, y),
            width: widget.barWidth,
            height: newAmplitude * height);
        _path.addRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(1.0)));
        // }
        setState(() {
          _amplitudes = [..._amplitudes, event['payload']['avgAmplitude']];
        });
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     _waveformRight = size.width;
    //   });
    // });
  }

  // @override
  // void didUpdateWidget(AudioWaveform oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // final height = widget.height;
  //   // final halfHeight = height / 2;

  //   // for (var i = 0; i < _amplitudes.length; i++) {
  //   //   final amplitude = _amplitudes[i];
  //   //   final x = i.toDouble() * (widget.barWidth + widget.barSpace);
  //   //   final y = halfHeight;
  //   //   _path.moveTo(x, y);
  //   //   final rect = Rect.fromCenter(
  //   //       center: Offset(x, y), width: widget.barWidth, height: amplitude * height);
  //   //   _path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(1.0)));
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    final width = _amplitudes.isNotEmpty
        ? _amplitudes.length * widget.barWidth +
            (_amplitudes.length - 1) * widget.barSpace
        : 0.0;
    print("amplitudes ${_amplitudes.length}");
    print("width $width");
    return CustomPaint(
        size: Size(width, widget.height),
        painter: _AudioWaveformPainter(
          path: _path,
          // shouldRepaint: true,
          // amplitudes: widget.amplitudes,
          // amplitudeIndex: _amplitudeIndex,
          barWidth: widget.barWidth,
          // barSpace: widget.barSpace,
          // setWaveformLeft: (double right) {
          //   setState(() {
          //     _waveformRight = right;
          //   });
          // },
          // setAmplitudeIndex: (int index) {
          //   setState(() {
          //     _amplitudeIndex = index;
          //   });
          // },
          // onDraw: () {
          //   setState(() {
          //     _waveformRight -= 2;
          //   });
          // }
        ));
  }
}

class _AudioWaveformPainter extends CustomPainter {
  _AudioWaveformPainter({
    required this.path,
    // required this.amplitudes,
    // required this.setWaveformLeft,
    // required this.amplitudeIndex,
    // required this.setAmplitudeIndex,
    this.barWidth = 2.0,
    // this.barSpace = 3.0,
    // this.onDraw
  });

  final Path path;
  // final List<num> amplitudes;
  // final Function setWaveformLeft;
  // final int amplitudeIndex;
  // final Function setAmplitudeIndex;
  final double barWidth;
  // final double barSpace;
  // final Function? onDraw;

  // int _amplitudeIndex = 0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.black
      ..strokeWidth = barWidth
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);

    // final height = size.height;
    // final halfHeight = height / 2;

    // for (var i = 0; i < amplitudes.length; i++) {
    //   final amplitude = amplitudes[i];
    //   final x = i.toDouble() * (barWidth + barSpace);
    //   final y = halfHeight;
    //   path.moveTo(x, y);
    //   final rect = Rect.fromCenter(
    //       center: Offset(x, y), width: barWidth, height: amplitude * height);

    // }

    // print("draw");
    // final width =
    //     amplitudes.isNotEmpty ? amplitudes.length * (barWidth + barSpace) : 0.0;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setWaveformLeft(width);
    // });
    // print("should draw ${amplitudes.length}");
    // canvas.drawPath(path, paint);
    // _amplitudeIndex = amplitudes.length;
    // onDraw?.call();
  }

  @override
  bool shouldRepaint(_AudioWaveformPainter oldDelegate) {
    // return oldDelegate.amplitudes != amplitudes;
    // return shouldRepaint;
    return true;
  }
}
