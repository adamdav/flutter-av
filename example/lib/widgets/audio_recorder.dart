import 'dart:async';

import 'package:av/av.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioRecorder extends StatefulWidget {
  const AudioRecorder({
    super.key,
    this.skipBackIcon,
    this.skipForwardIcon,
  });

  final Widget? skipBackIcon;
  final Widget? skipForwardIcon;

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  List<double> _amplitudes = [];
  List<String> _savedRecordings = [];
  bool _isPreparedToRecord = false;
  bool _isRecording = false;
  String? _audioRecordingUrl;
  bool _isPreparedToPlay = false;
  bool _isPlaying = false;
  StreamSubscription? _audioOutputFinishedStreamSubscription;
  StreamSubscription? _audioInputCapturedStreamSubscription;

  @override
  void initState() {
    super.initState();
    _audioOutputFinishedStreamSubscription = Audio().onOutputFinished((event) {
      setState(() {
        _isPlaying = false;
      });
    });
    _audioInputCapturedStreamSubscription = Audio().onInputCaptured((event) {
      setState(() {
        _amplitudes = [..._amplitudes, event['avgAmplitude']];
      });
    });
    _prepareToRecord();
  }

  @override
  void dispose() {
    _audioOutputFinishedStreamSubscription?.cancel();
    _audioInputCapturedStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _prepareToRecord() async {
    final isPreparedToRecord = await Audio().prepareToRecord();

    setState(() {
      _isPreparedToRecord = isPreparedToRecord;
    });
  }

  Future<void> _startRecording() async {
    final isRecording = await Audio().startRecording();
    setState(() {
      _isRecording = isRecording;
    });
  }

  Future<void> _stopRecording() async {
    final audioRecordingUrl = await Audio().stopRecording();
    setState(() {
      _isRecording = false;
      _audioRecordingUrl = audioRecordingUrl;
    });
  }

  Future<void> _deleteRecordingAndPrepareToRecord() async {
    final isRecordingDeleted = await Audio().deleteRecording();
    setState(() {
      _amplitudes = [];
      _audioRecordingUrl = isRecordingDeleted ? null : _audioRecordingUrl;
    });
    _prepareToRecord();
  }

  void _saveRecordingAndPrepareToRecord() {
    setState(() {
      _savedRecordings = [..._savedRecordings, _audioRecordingUrl!];
      _audioRecordingUrl = null;
    });
    _prepareToRecord();
  }

  Future<void> _prepareToPlay() async {
    if (_audioRecordingUrl != null) {
      final isPreparedToPlay = await Audio().prepareToPlay(_audioRecordingUrl!);
      setState(() {
        _isPreparedToPlay = isPreparedToPlay;
      });
    }
  }

  Future<void> _startPlaying() async {
    final isPlaying = await Audio().startPlaying();
    setState(() {
      _isPlaying = isPlaying;
    });
  }

  Future<void> _pausePlaying() async {
    final isPaused = await Audio().pausePlaying();
    setState(() {
      _isPlaying = !isPaused;
    });
  }

  Future<void> _skipBack() async {
    await Audio().skip(-15);
  }

  Future<void> _skipForward() async {
    await Audio().skip(15);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: Center(child: Clock(isRunning: _isRecording || _isPlaying))),
        Expanded(flex: 2, child: AudioWaveform(amplitudes: _amplitudes)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_audioRecordingUrl != null) ...[
                    SkipBackButton(
                        icon: widget.skipBackIcon, onPressed: _skipBack),
                    const SizedBox(width: 10)
                  ],
                  if (_audioRecordingUrl != null)
                    PlayButton(
                        onPressed: _isPreparedToPlay
                            ? () async {
                                if (_isPlaying) {
                                  await _pausePlaying();
                                } else {
                                  await _startPlaying();
                                }
                              }
                            : null,
                        isPlaying: _isPlaying),
                  if (_audioRecordingUrl == null)
                    RecordButton(
                        onPressed: _isPreparedToRecord
                            ? () async {
                                if (_isRecording) {
                                  await _stopRecording();
                                  await _prepareToPlay();
                                } else {
                                  await _startRecording();
                                }
                              }
                            : null,
                        isRecording: _isRecording),
                  if (_audioRecordingUrl != null) ...[
                    const SizedBox(width: 10),
                    SkipForwardButton(
                        icon: widget.skipForwardIcon, onPressed: _skipForward)
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_audioRecordingUrl != null) ...[
                    DeleteButton(onPressed: _deleteRecordingAndPrepareToRecord),
                    const SizedBox(width: 10),
                    SaveButton(onPressed: _saveRecordingAndPrepareToRecord)
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
