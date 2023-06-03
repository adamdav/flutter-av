import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton(
      {super.key, required this.onPressed, required this.isPlaying});

  final Function()? onPressed;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Center(
            child: isPlaying
                ? Icon(CupertinoIcons.pause_fill,
                    size: 25, color: Colors.grey[700])
                : Icon(CupertinoIcons.play_fill,
                    size: 25, color: Colors.grey[700]),
          )),
    );
  }
}
