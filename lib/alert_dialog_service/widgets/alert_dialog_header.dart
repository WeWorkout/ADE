
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:flutter/cupertino.dart';

class AlertDialogHeader extends StatelessWidget {

  String state;

  AlertDialogHeader(this.state);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.075,
      child: _getTitleAccordingToState(),
    );
  }

  Widget _getTitleAccordingToState() {
    if(state == AlertDialogStatus.EXTENTION) {
      return const Text("Extend Timer?");
    } else if(state == AlertDialogStatus.OVERRIDE) {
      return const Text("(Will replace the previous timer)");
    }
    return const SizedBox.shrink();
  }
}