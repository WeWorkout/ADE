
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:flutter/material.dart';

class AlertDialogHeader extends StatelessWidget {

  String state;

  AlertDialogHeader(this.state);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: screenHeight * 0.075,
        child: Center(child: _getTitleAccordingToState()),
      ),
    );
  }

  Widget _getTitleAccordingToState() {
    if(state == AlertDialogStatus.EXTENTION) {
      return const Text("Extend Timer?", style: TextStyle(fontSize: 16),);
    } else if(state == AlertDialogStatus.OVERRIDE) {
      return const Text("(Will replace the previous timer)");
    }
    return const SizedBox.shrink();
  }
}