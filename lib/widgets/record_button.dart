import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton(
      {super.key, required this.onPressed, required this.isRecording});

  final Function()? onPressed;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
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
                ? Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  )
                : Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
          )),
    );
  }
}
