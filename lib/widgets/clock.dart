import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Clock extends StatefulWidget {
  const Clock({
    super.key,
    required this.isRunning,
  });

  final bool isRunning;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer? _timer;
  int _start = 0;

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _start = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    // _startTimer();
  }

  @override
  void didUpdateWidget(covariant Clock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isRunning && widget.isRunning) {
      _startTimer();
    } else if (oldWidget.isRunning && !widget.isRunning) {
      _stopTimer();
      _resetTimer();
    }
  }

  // @override
  // void dispose() {
  //   _stopTimer();
  //   super.dispose();
  // }

  String get _timerText {
    final int minutes = (_start / 60).floor();
    final int seconds = _start - (minutes * 60);
    final String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    final String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Text(_timerText,
        style: GoogleFonts.robotoMono(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ));
    // style: TextStyle(
    //     fontSize: 48,
    //     fontFamily: 'Roboto Mono',
    //     fontWeight: FontWeight.w700));
  }
}
