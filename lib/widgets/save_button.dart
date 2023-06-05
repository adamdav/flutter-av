import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
          style: ButtonStyle(
            // elevation: MaterialStateProperty.all<double>(0),
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
              child: Row(
            children: [
              SvgPicture.asset('icons/download.svg', package: 'av'),
              Text(
                "Save",
                style: TextStyle(color: Colors.grey[700], fontSize: 10),
              )
            ],
          ))),
    );
  }
}
