import 'package:ade/alert_dialog_service/alert_dialog_utils.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';

class AlertDialogService {


  static createAlertDialog(String appName, bool isInitiatedByTimer) async {
    if (isInitiatedByTimer) {
      await AlertDialogUtils.showExtensionDialog(appName);
    } else {
      String? currentAppName = await getCurrentRunningAppName();
      if(currentAppName == null) {
        await AlertDialogUtils.showFirstTimeDialog(appName);
      }
      else if (currentAppName == appName) {
        // DO NOTHING
        debugPrint("Overlay will not open for same app again.");
      } else {
        await AlertDialogUtils.showOverrideDialog(appName);
      }
    }
  }

  static closeAlertDialog() {
    AlertDialogUtils.closeAlertDialog();
  }

}
