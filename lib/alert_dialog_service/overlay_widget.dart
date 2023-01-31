import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_header.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_nav_buttons.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWidget extends StatefulWidget {
  @override
  State<OverlayWidget> createState() => _OverlayWidget();
}

class _OverlayWidget extends State<OverlayWidget> {

  Map<String, double> timeData = {"time": 0.5};

  double time = 0.5;
  String status = AlertDialogStatus.FIRST_TIME;
  String appName = "ADE";
  String appId = "com.ade.ade";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        color: Colors.white,
        height: screenHeight * 0.5,
        width: screenWidth * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AlertDialogHeader(status),
            AlertDialogTimer(timeData),
            AlertDialogNavButtons(timeData, appName, appId)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    FlutterOverlayWindow.overlayListener.listen((event) {
      debugPrint("Event is ${event is AlertDialogService}");
      if(event == AlertDialogStatus.FIRST_TIME || event == AlertDialogStatus.EXTENTION || event == AlertDialogStatus.OVERRIDE) {
        status = event;
      } else {
        String eventString = event as String;
        if(eventString.contains("AppName")) {
          appName = eventString.replaceFirst("AppName-", "");
        } else {
          appId = eventString;
        }

      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint("Overlay Disposed!");
    super.dispose();
  }
}
