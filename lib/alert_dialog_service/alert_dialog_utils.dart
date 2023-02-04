
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class AlertDialogUtils {

  static showFirstTimeDialog(ApplicationData app) async {
    await FlutterOverlayWindow.showOverlay();
    await FlutterOverlayWindow.shareData(AlertDialogStatus.FIRST_TIME);
    await FlutterOverlayWindow.shareData(app.appId);
  }

  static showExtensionDialog(String appId) async {
    await FlutterOverlayWindow.showOverlay();
    await FlutterOverlayWindow.shareData(AlertDialogStatus.EXTENTION);
    await FlutterOverlayWindow.shareData(appId);
  }

  static showOverrideDialog(ApplicationData app) async {
    await FlutterOverlayWindow.showOverlay();
    await FlutterOverlayWindow.shareData(AlertDialogStatus.OVERRIDE);
    await FlutterOverlayWindow.shareData(app.appId);
  }

  static Future<void> refreshDatabase() async {
    await FlutterOverlayWindow.shareData("REFRESH DB");
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