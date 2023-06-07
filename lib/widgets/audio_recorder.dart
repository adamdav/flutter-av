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
  List<num> _amplitudes = [];
  List<String> _savedRecordings = [];
  bool _isPreparedToRecord = false;
  bool _isRecording = false;
  String? _recordingDestinationUrl;
  bool _isPreparedToPlay = false;
  bool _isPlaying = false;
  // final _waveformScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _prepareToRecord();
    _listenForEvents();
  }

  Future<void> _prepareToRecord() async {
    final isPreparedToRecord =
        (await AvPlatformInterface.instance.prepareToRecordMpeg4Aac()) != null;
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
      _recordingDestinationUrl = recordingDestinationUrl;
    });
  }

  Future<void> _deleteRecording() async {
    await AvPlatformInterface.instance.deleteRecording();
    setState(() {
      // _savedRecordings = [..._savedRecordings, _recordingDestinationUrl!];
      _amplitudes = [];
      _recordingDestinationUrl = null;
      // _isRecording = false;
      // _recordingDestinationUrl = recordingDestinationUrl;
    });
  }

  void _saveRecording() {
    // await AudioRecorderUtils.saveRecording();
    setState(() {
      _savedRecordings = [..._savedRecordings, _recordingDestinationUrl!];
      _recordingDestinationUrl = null;
      // _isRecording = false;
      // _recordingDestinationUrl = recordingDestinationUrl;
    });
  }

  void _listenForEvents() {
    AvPlatformInterface.instance.getEventStream().listen((event) {
      if (event['type'] == 'audioPlayer/finishedPlaying') {
        setState(() {
          _isPlaying = false;
        });
      }
      if (event['type'] == 'audioRecorder/metered') {
        //print(event['payload']);
        setState(() {
          _amplitudes = [..._amplitudes, event['payload']['avgAmplitude']];
        });
      }
    });
  }

  Future<void> _prepareToPlay() async {
    if (_recordingDestinationUrl != null) {
      await AvPlatformInterface.instance
          .prepareToPlay(_recordingDestinationUrl!);
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
        Expanded(
            flex: 2,
            child: Container(
                color: Colors.red,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: AudioWaveform(),
                      // Text(
                      //   'Waveform waveform waveform waveform waveform waveform waveform.',
                      //   style: TextStyle(color: Colors.white),
                      //   softWrap: false,
                      // ),
                    )
                  ],
                ))),
        // Expanded(
        //     flex: 2,
        //     child: Container(
        //         // width: double.infinity,
        //         // height: 200,
        //         color: Colors.red,
        //         // child: SingleChildScrollView(
        //         //     scrollDirection: Axis.horizontal,
        //         //     child: AudioWaveform(amplitudes: _amplitudes)),
        //         child: AudioWaveform(amplitudes: _amplitudes))),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_recordingDestinationUrl != null) ...[
                    SkipBackButton(
                        icon: widget.skipBackIcon,
                        onPressed: () async {
                          await AvPlatformInterface.instance.skip(-15);
                        }),
                    SizedBox(width: 10)
                  ],
                  if (_recordingDestinationUrl != null)
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
                  if (_recordingDestinationUrl == null)
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
                  if (_recordingDestinationUrl != null) ...[
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
                  if (_recordingDestinationUrl != null) ...[
                    DeleteButton(onPressed: () async {
                      await _deleteRecording();
                      await _prepareToRecord();
                    }),
                    SizedBox(width: 10),
                    SaveButton(onPressed: () async {
                      _saveRecording();
                      await _prepareToRecord();
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
