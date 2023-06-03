import 'dart:async';

import 'package:flutter/material.dart';

class AudioRecordingTimer extends StatefulWidget {
  const AudioRecordingTimer({
    super.key,
    required this.isRecording,
  });

  final bool isRecording;

  @override
  State<AudioRecordingTimer> createState() => _AudioRecordingTimerState();
}

class _AudioRecordingTimerState extends State<AudioRecordingTimer> {
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
  void didUpdateWidget(covariant AudioRecordingTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isRecording && widget.isRecording) {
      _startTimer();
    } else if (oldWidget.isRecording && !widget.isRecording) {
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
        style: TextStyle(fontSize: 48, fontFamily: 'monospace'));
  }
}
