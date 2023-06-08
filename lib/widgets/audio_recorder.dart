import 'dart:async';

import 'package:av/av_platform_interface.dart';
import 'package:av/widgets/audio_waveform.dart';
import 'package:av/widgets/clock.dart';
import 'package:av/widgets/delete_button.dart';
import 'package:av/widgets/play_button.dart';
import 'package:av/widgets/record_button.dart';
import 'package:av/widgets/save_button.dart';
import 'package:av/widgets/skip_back_button.dart';
import 'package:av/widgets/skip_forward_button.dart';
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
  // List<num> _amplitudes = [];
  List<String> _savedRecordings = [];
  bool _isPreparedToRecord = false;
  bool _isRecording = false;
  String? _audioRecordingUrl;
  bool _isPreparedToPlay = false;
  bool _isPlaying = false;
  // final _waveformScrollController = ScrollController();
  StreamSubscription? _eventBroadcastStreamSubscription;

  @override
  void initState() {
    super.initState();
    AvPlatformInterface.instance.getEventBroadcastStream().listen((event) {
      print(event);
      if (event['type'] == 'audioRecorder/deletedRecording') {
        _prepareToRecord();
        setState(() {
          // _amplitudes = [];
          _audioRecordingUrl = null;
        });
      }
      if (event['type'] == 'audioPlayer/finishedPlaying') {
        setState(() {
          _isPlaying = false;
        });
      }
      // if (event['type'] == 'audioRecorder/metered') {
      //   //print(event['payload']);
      //   setState(() {
      //     _amplitudes = [..._amplitudes, event['payload']['avgAmplitude']];
      //   });
      // }
    });
    _prepareToRecord();
  }

  @override
  void dispose() {
    _eventBroadcastStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _prepareToRecord() async {
    final isPreparedToRecord =
        (await AvPlatformInterface.instance.prepareToRecordMpeg4Aac()) ?? false;
    setState(() {
      _isPreparedToRecord = isPreparedToRecord;
    });
  }

  Future<void> _startRecording() async {
    await AvPlatformInterface.instance.startRecording();
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    final recordingDestinationUrl =
        await AvPlatformInterface.instance.stopRecording();
    setState(() {
      _isRecording = false;
      _audioRecordingUrl = recordingDestinationUrl;
    });
  }

  // Future<void> _deleteRecording() async {
  //   await AvPlatformInterface.instance.deleteRecording();
  //   setState(() {
  //     // _savedRecordings = [..._savedRecordings, _audioRecordingUrl!];
  //     _amplitudes = [];
  //     _audioRecordingUrl = null;
  //     // _isRecording = false;
  //     // _audioRecordingUrl = recordingDestinationUrl;
  //   });
  // }

  void _saveRecording() {
    // await AudioRecorderUtils.saveRecording();
    setState(() {
      _savedRecordings = [..._savedRecordings, _audioRecordingUrl!];
      _audioRecordingUrl = null;
      // _isRecording = false;
      // _audioRecordingUrl = recordingDestinationUrl;
    });
  }

  Future<void> _prepareToPlay() async {
    if (_audioRecordingUrl != null) {
      await AvPlatformInterface.instance.prepareToPlay(_audioRecordingUrl!);
      setState(() {
        _isPreparedToPlay = true;
      });
    }
  }

  Future<void> _startPlaying() async {
    await AvPlatformInterface.instance.startPlaying();
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pausePlaying() async {
    await AvPlatformInterface.instance.pausePlaying();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: Center(child: Clock(isRunning: _isRecording || _isPlaying))),
        const Expanded(flex: 2, child: AudioWaveform()),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_audioRecordingUrl != null) ...[
                    SkipBackButton(
                        icon: widget.skipBackIcon,
                        onPressed: () async {
                          await AvPlatformInterface.instance.skip(-15);
                        }),
                    SizedBox(width: 10)
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
                    SizedBox(width: 10),
                    SkipForwardButton(
                        icon: widget.skipForwardIcon,
                        onPressed: () async {
                          await AvPlatformInterface.instance.skip(15);
                          // _saveRecording();
                          // await _prepareToRecord();
                        })
                  ],
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_audioRecordingUrl != null) ...[
                    const DeleteButton(),
                    SizedBox(width: 10),
                    SaveButton(onPressed: () {
                      _saveRecording();
                      _prepareToRecord();
                    })
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
