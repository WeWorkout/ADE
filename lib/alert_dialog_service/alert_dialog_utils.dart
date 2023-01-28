
import 'package:ade/alert_dialog_service/alert_dialog_status.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class AlertDialogUtils {

  static showFirstTimeDialog(String appName) async {
    await FlutterOverlayWindow.showOverlay();
    await FlutterOverlayWindow.shareData(AlertDialogStatus.FIRST_TIME);
    await FlutterOverlayWindow.shareData(appName);
  }

  static showExtensionDialog(String appName) async {
    await FlutterOverlayWindow.showOverlay();
    await FlutterOverlayWindow.shareData(AlertDialogStatus.EXTENTION);
    await FlutterOverlayWindow.shareData(appName);
  }

  static showOverrideDialog(String appName) async {
    await FlutterOverlayWindow.showOverlay();
    await FlutterOverlayWindow.shareData(AlertDialogStatus.OVERRIDE);
    await FlutterOverlayWindow.shareData(appName);
  }

  static closeAlertDialog() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  static getOverlayPermission() async {
    bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
  }
}