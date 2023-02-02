import 'package:ade/alert_dialog_service/alert_dialog_utils.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';

class AlertDialogService {
  static createAlertDialog(ApplicationData app) async {
    String? currentAppId = await getCurrentRunningAppId();
    if (currentAppId == null) {
      await AlertDialogUtils.showFirstTimeDialog(app);
    } else if (currentAppId == app.appId) {
      // DO NOTHING
      debugPrint("Overlay will not open for same app again.");
    } else {
      await AlertDialogUtils.showOverrideDialog(app);
    }
  }

  static createTimerExtensionAlertDialog() async {
    await AlertDialogUtils.showExtensionDialog();
  }

  static refreshDatabase() async {
    await AlertDialogUtils.refreshDatabase();
  }

  static closeAlertDialog() {
    AlertDialogUtils.closeAlertDialog();
  }
}
