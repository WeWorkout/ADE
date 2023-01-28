import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_header.dart';
import 'package:ade/alert_dialog_service/widgets/alert_dialog_timer.dart';
import 'package:ade/timer_service/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWidget extends StatefulWidget {
  @override
  State<OverlayWidget> createState() => _OverlayWidget();
}

class _OverlayWidget extends State<OverlayWidget> {

  String status = AlertDialogStatus.FIRST_TIME;
  late String appName;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        color: Colors.white,
        height: screenHeight * 0.45,
        width: screenWidth * 0.7,
        child: Column(
          children: [
            AlertDialogHeader(status),
            AlertDialogTimer(),
            // _timerPresets(),
            // _navButtons(),
            OutlinedButton(
              onPressed: () async {
                createTimerServiceForApp(DateTime.now().add(const Duration(seconds: 10)), appName);
                AlertDialogService.closeAlertDialog();
              },
              child: Text("$status!"),
            ),
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
        appName = event;
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
