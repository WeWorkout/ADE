
import 'dart:ui';

import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/timer_service/timer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogNavButtons extends StatelessWidget {

  Map<String, double> timeData;
  String appName;

  AlertDialogNavButtons(this.timeData, this.appName);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.1,
      width: screenWidth * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _dismissButton(context),
          _startButton(context),
        ],
      ),
    );
  }

  Widget _startButton(BuildContext context) {
    void onPressed() {
      createTimerServiceForApp(DateTime.now().add(Duration(minutes: timeData["time"]!.toInt())), appName);
      AlertDialogService.closeAlertDialog();
    }
    return _customOutlinedButton(
      onPressed,
      "START",
      context
    );
  }

  Widget _dismissButton(BuildContext context) {
    void onPressed() {
      AlertDialogService.closeAlertDialog();
    }
    return _customOutlinedButton(
        onPressed,
        "DISMISS",
        context
    );
  }

  Widget _customOutlinedButton(void Function() onPressed, String text, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: Size(screenWidth*0.25, screenHeight*0.05)
      ),
        onPressed: onPressed,
        child: Text(
          text
        ));
  }


}