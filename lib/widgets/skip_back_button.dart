import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';

class SkipBackButton extends StatelessWidget {
  const SkipBackButton({super.key, required this.onPressed, this.icon});

  final Function() onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          onPressed: onPressed,
          // color: isRecording ? Colors.red : Colors.grey[300],
          child: Center(
              child: icon ??
                  SvgPicture.asset('icons/rewind-backward-15.svg',
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      package: 'av'))),
      //     Icon(
      //   CupertinoIcons.backward_fill,
      //   size: 20,
      //   color: Colors.grey[700],
      // )
    );
  }
}
