import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoMicrophoneButton extends StatelessWidget {
  const CupertinoMicrophoneButton(
      {super.key, required this.onPressed, required this.isRecording});

  final Function() onPressed;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      // color: isRecording ? Colors.red : Colors.grey[300],
      child: Icon(
        CupertinoIcons.mic_fill,
        size: 100,
        color: isRecording ? Colors.red : Colors.grey[300],
      ),
    );
  }
}
