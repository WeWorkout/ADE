import 'package:ade/alert_dialog_service/alert_dialog_utils.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';

class AlertDialogService {

  // The isolate function for this service has been defined in the main class file!

  static createAlertDialog(ApplicationData app) async {
    // Check if an app is already being timed
    String? currentAppId = await getCurrentRunningAppId();

    if (currentAppId == null) {
      debugPrint("Displaying the Alert Dialog for $currentAppId");
      await AlertDialogUtils.showFirstTimeDialog(app);
    }
    else if (currentAppId == app.appId) {
      // DO NOTHING
      debugPrint("Overlay will not open for same app again.");
    }
    else {
      debugPrint("Displaying Override Alert Dialog for ${app.appId} because of $currentAppId");
      await AlertDialogUtils.showOverrideDialog(app);
    }
  }

  static Future<void> createTimerExtensionAlertDialog() async {
    await AlertDialogUtils.showExtensionDialog();
  }

  static Future<void> refreshDatabase() async {
    await AlertDialogUtils.refreshDatabase();
  }

  static Future<void> closeAlertDialog() async{
    await AlertDialogUtils.closeAlertDialog();
  }
}
