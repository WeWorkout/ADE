
import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:ade/database/database_service.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:flutter/material.dart';

class AlertDialogHeader extends StatelessWidget {

  ApplicationData app;
  String state;

  AlertDialogHeader(this.app, this.state);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: screenHeight * 0.075,
        child: Center(child: _getTitle(context)),
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

  Widget _getTitle(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListTile(
      leading: app.icon!=null ?
      SizedBox(
          height: screenHeight * 0.05,
          child: Image.memory(app.icon!)) : null,
      title: Center(child: _getTitleAccordingToState()),
      trailing: IconButton(
        onPressed: () => {AlertDialogService.closeAlertDialog()},
        icon: Icon(
          Icons.cancel,
          size: screenHeight * 0.05,
        ),
      ),
    );
  }
}