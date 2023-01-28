
import 'package:flutter/material.dart';

class AlertDialogTimer extends StatefulWidget {

  @override
  State<AlertDialogTimer> createState() => _AlertDialogTimerState();
}

class _AlertDialogTimerState extends State<AlertDialogTimer> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.1,
      width: screenHeight * 0.1,
      child: const CircularProgressIndicator(
        value: 5,
      ),
    );
  }

}