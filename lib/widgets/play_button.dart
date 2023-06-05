import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton(
      {super.key, required this.onPressed, required this.isPlaying});

  final Function()? onPressed;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
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
                  ? SvgPicture.asset('icons/player-pause-filled.svg',
                      package: 'av')
                  : SvgPicture.asset('icons/player-play-filled.svg',
                      package: 'av'))),
    );
  }
}
