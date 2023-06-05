import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton(
      {super.key, required this.onPressed, required this.isRecording});

  final Function()? onPressed;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: ElevatedButton(
          // height: 100,
          // minWidth: 100,
          // shape: const CircleBorder(),
          // elevation: 10,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          onPressed: onPressed,
          // color: isRecording ? Colors.red : Colors.grey[300],
          child: Center(
              child: isRecording
                  ? SvgPicture.asset('icons/player-stop-filled.svg',
                      package: 'av')
                  : SvgPicture.asset('icons/player-record-filled.svg',
                      package: 'av'))),
    );
  }
}
