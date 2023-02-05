
import 'package:ade/alert_dialog_service/alert_dialog_events.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class AlertDialogUtils {

  static Future<void> showDialog() async {
    await FlutterOverlayWindow.shareData(AlertDialogEvents.SHOW_DIALOG);
    await FlutterOverlayWindow.showOverlay(overlayTitle: "TEST", overlayContent: "CONTENT");
  }

  static showFirstTimeDialog(ApplicationData app) async {
    debugPrint("Sending event for ${AlertDialogEvents.FIRST_TIME},${app.appId}");
    await FlutterOverlayWindow.shareData("${AlertDialogEvents.FIRST_TIME},${app.appId}");
    await showDialog();
  }

  static showExtensionDialog(String appId) async {
    debugPrint("Sending event for ${AlertDialogEvents.EXTENSION},$appId");
    await FlutterOverlayWindow.shareData("${AlertDialogEvents.EXTENSION},$appId");
    await showDialog();
  }

  static showOverrideDialog(ApplicationData app) async {
    debugPrint("Sending event for ${AlertDialogEvents.OVERRIDE},${app.appId}");
    await FlutterOverlayWindow.shareData("${AlertDialogEvents.OVERRIDE},${app.appId}");
    await showDialog();
  }

  static Future<void> refreshDatabase() async {
    await FlutterOverlayWindow.shareData(AlertDialogEvents.REFRESH_DB);
  }

  static Future<void> closeAlertDialog() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  static getOverlayPermission() async {
    bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
  }


}