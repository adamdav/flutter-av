import 'package:flutter/cupertino.dart';

class CupertinoAudioPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final double volume;
  final Function(double position) onPositionChanged;
  final Function() onCompleted;
  final Function() onPaused;
  final Function() onResumed;
  final Function() onStopped;
  final Function() onBuffering;
  final Function() onReady;
  final Function() onError;

  const CupertinoAudioPlayer({
    super.key,
    required this.url,
    this.autoPlay = false,
    this.loop = false,
    this.muted = false,
    this.volume = 1.0,
    required this.onPositionChanged,
    required this.onCompleted,
    required this.onPaused,
    required this.onResumed,
    required this.onStopped,
    required this.onBuffering,
    required this.onReady,
    required this.onError,
  });

  @override
  State<CupertinoAudioPlayer> createState() => _CupertinoAudioPlayerState();
}

class _CupertinoAudioPlayerState extends State<CupertinoAudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('CupertinoAudioPlayer'),
    );
  }
}
