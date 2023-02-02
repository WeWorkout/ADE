import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_header.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_nav_buttons.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_timer.dart';
import 'package:ade/database/database_service.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWidget extends StatefulWidget {
  DatabaseService dbService;

  OverlayWidget(this.dbService);

  @override
  State<OverlayWidget> createState() => _OverlayWidget();
}

class _OverlayWidget extends State<OverlayWidget> {
  Map<String, double> timeData = {"time": 0.5};

  double time = 0.5;
  String status = AlertDialogStatus.FIRST_TIME;
  String appId = "com.ade.ade";
  ApplicationData app = ApplicationData("ADE", "com.ade.ade", null);

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
            AlertDialogHeader(app, status),
            AlertDialogTimer(timeData),
            AlertDialogNavButtons(timeData, app.appName, appId)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    FlutterOverlayWindow.overlayListener.listen((event) async{
      debugPrint("Event is ${event as String}");
      if (event == AlertDialogStatus.FIRST_TIME ||
          event == AlertDialogStatus.EXTENTION ||
          event == AlertDialogStatus.OVERRIDE) {
        status = event;
      } else if (event == "REFRESH DB") {
        await widget.dbService.openBox();
      } else {
        appId = event;
        app = widget.dbService.getAppData(appId)!;
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
