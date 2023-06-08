import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Center(
              child: Row(
            children: [
              SvgPicture.asset('icons/download.svg', package: 'av'),
            ],
          ))),
    );
  }
}
