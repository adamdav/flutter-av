import 'package:av/av_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteButton extends StatefulWidget {
  const DeleteButton({super.key});

  // final Function() onPressed;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  void _deleteRecording() async {
    await AvPlatformInterface.instance.deleteRecording();
  }

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
          onPressed: _deleteRecording,
          child: Center(
              child: Row(
            children: [
              SvgPicture.asset('icons/trash.svg', package: 'av'),
            ],
          ))),
    );
  }
}
