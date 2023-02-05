import 'package:ade/alert_dialog_service/widgets/alert_dialog_header.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_nav_buttons.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_timer.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:flutter/material.dart';


class OverlayWidget extends StatefulWidget {

  String dialogStatus;
  ApplicationData app;

  OverlayWidget(this.dialogStatus, this.app);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();

}

class _OverlayWidgetState extends State<OverlayWidget> {


  Map<String, double> timeData = {"time": 0.5};

  double time = 0.5;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        height: screenHeight * 0.5,
        width: screenWidth * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AlertDialogHeader(widget.app, widget.dialogStatus),
            AlertDialogTimer(timeData),
            AlertDialogNavButtons(timeData, widget.app.appName, widget.app.appId)
          ],
        ),
      ),
    );
  }
}
