import 'package:ade/alert_dialog_service/utils/alert_dialog_utils.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';

class AlertDialogService {

  // The isolate function for this service has been defined in the main class file!

  static Future<void> createAlertDialog({bool fromTimerService = false}) async {
    if(fromTimerService || !await isTimerServiceRunning()) {
      await AlertDialogUtils.showDialog();
    } else {
      debugPrint("Timer already running for the same application.");
    }
  }

  static Future<void> closeAlertDialog() async{
    await AlertDialogUtils.closeAlertDialog();
  }
}
