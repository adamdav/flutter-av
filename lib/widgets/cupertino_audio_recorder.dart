import 'package:av/utils/audio_recorder.dart';
import 'package:av/widgets/cupertino_microphone_button.dart';
import 'package:flutter/cupertino.dart';

class CupertinoAudioRecorder extends StatefulWidget {
  const CupertinoAudioRecorder({
    super.key,
  });

  @override
  State<CupertinoAudioRecorder> createState() => _CupertinoAudioRecorderState();
}

class _CupertinoAudioRecorderState extends State<CupertinoAudioRecorder> {
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    AudioRecorder.prepareMpeg4Aac();
  }

  Future<void> _startRecording() async {
    await AudioRecorder.start();
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await AudioRecorder.stop();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoMicrophoneButton(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            isRecording: _isRecording),
      ],
    );
  }
}
