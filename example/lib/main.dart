// import 'package:av/widgets/audio_recorder.dart';
import 'package:av_example/widgets/audio_recorder.dart';
import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter/services.dart';
import 'package:av/av.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(child: Center(child: AudioRecorder())),
      ),
    );
  }
}
