import 'package:av/utils/audio_player_utils.dart';
import 'package:av/utils/audio_recorder_utils.dart';
import 'package:av/widgets/audio_recording_timer.dart';
import 'package:av/widgets/delete_button.dart';
import 'package:av/widgets/play_button.dart';
import 'package:av/widgets/record_button.dart';
import 'package:av/widgets/save_button.dart';
import 'package:av/widgets/skip_back_button.dart';
import 'package:av/widgets/skip_forward_button.dart';
import 'package:flutter/cupertino.dart';

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
  List<String> _savedRecordings = [];
  bool _isPreparedToRecord = false;
  bool _isRecording = false;
  String? _recordingDestinationUrl;
  bool _isPreparedToPlay = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _prepareToRecord();
    _listenForAudioPlayerEvents();
  }

  Future<void> _prepareToRecord() async {
    final isPreparedToRecord =
        (await AudioRecorderUtils.prepareToRecordMpeg4Aac()) != null;
    setState(() {
      _isPreparedToRecord = isPreparedToRecord;
    });
  }

  Future<void> _startRecording() async {
    await AudioRecorderUtils.startRecording();
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    final recordingDestinationUrl = await AudioRecorderUtils.stopRecording();
    setState(() {
      _isRecording = false;
      _recordingDestinationUrl = recordingDestinationUrl;
    });
  }

  Future<void> _deleteRecording() async {
    await AudioRecorderUtils.deleteRecording();
    setState(() {
      // _savedRecordings = [..._savedRecordings, _recordingDestinationUrl!];
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

  void _listenForAudioPlayerEvents() {
    AudioPlayerUtils.getEventStream().listen((event) {
      if (event['type'] == 'audioPlayer/didFinishPlaying') {
        setState(() {
          _isPlaying = false;
        });
      }
      // print('event: $event');
      // if (event == 'onReady') {
      //   setState(() {
      //     _isPreparedToPlay = true;
      //   });
      // } else if (event == 'onCompleted') {
      //   setState(() {
      //     _isPlaying = false;
      //   });
      // }
    });
  }

  Future<void> _prepareToPlay() async {
    if (_recordingDestinationUrl != null) {
      await AudioPlayerUtils.prepareToPlay(_recordingDestinationUrl!);
      setState(() {
        _isPreparedToPlay = true;
      });
    }
  }

  Future<void> _startPlaying() async {
    await AudioPlayerUtils.startPlaying();
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pausePlaying() async {
    await AudioPlayerUtils.pausePlaying();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: AudioRecordingTimer(isRecording: _isRecording)),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (_isRecording) AudioSpectrum(),
              // if (!_isRecording) AudioWaveform(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_recordingDestinationUrl != null)
                    SkipBackButton(
                        icon: widget.skipBackIcon,
                        onPressed: () async {
                          await AudioPlayerUtils.skip(-15);
                        }),
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
                                  if (_isPreparedToRecord)
                                    await _startRecording();
                                }
                              }
                            : null,
                        isRecording: _isRecording),
                  if (_recordingDestinationUrl != null)
                    SkipForwardButton(
                        icon: widget.skipForwardIcon,
                        onPressed: () async {
                          await AudioPlayerUtils.skip(15);
                          // _saveRecording();
                          // await _prepareToRecord();
                        }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_recordingDestinationUrl != null)
                    DeleteButton(onPressed: () async {
                      await _deleteRecording();
                      await _prepareToRecord();
                    }),
                  if (_recordingDestinationUrl != null)
                    SaveButton(onPressed: () async {
                      _saveRecording();
                      await _prepareToRecord();
                    }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
