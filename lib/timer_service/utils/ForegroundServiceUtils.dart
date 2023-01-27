import 'package:ade/timer_service/utils/timer_service_notifications_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

const String APP_NAME_CUSTOM_DATA_KEY = "App_Name";
const String FINISH_TIME_CUSTOM_DATA_KEY = "Duration_Time";
const String SERVICE_RUNNING_STATUS_MESSAGE_KEY = "isServiceRunning";

void initNotificationForegroundTask(DateTime finishTime, String appName) {
  debugPrint("Initializing Time Foreground Service!");
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelName: 'Foreground Notification_$appName',
      channelId: 'notification_channel_id_$appName',
      channelDescription:
      'Timer Service is running for $appName!\n Duration: ${finishTime.toString()}',
      channelImportance: NotificationChannelImportance.MAX,
      priority: NotificationPriority.MAX,
      iconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
        backgroundColor: Colors.green,
      ),

    ),

    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),

    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 5000,
      isOnceEvent: true,
      autoRunOnBoot: false,
      allowWakeLock: true,
      allowWifiLock: false,
    ),
  );
}

Future<bool> updateForegroundServiceNotification(String appName, DateTime finishTime, DateTime currentTime){
  return FlutterForegroundTask.updateService(
      notificationTitle: getNotificationTitle(appName, finishTime),
      notificationText: getNotificationDescription(currentTime, finishTime)
  );
}

Future<bool> storeForegroundSessionData(String appName, DateTime finishTime) async{
  // You can save data using the saveData function.
  // Here saving the App-Name and the Duration
  bool appNameSet = await FlutterForegroundTask.saveData(key: APP_NAME_CUSTOM_DATA_KEY, value: appName);
  bool finishTimeSet = await FlutterForegroundTask.saveData(key: FINISH_TIME_CUSTOM_DATA_KEY, value: finishTime.toString());
  if(!(appNameSet && finishTimeSet)){
    debugPrint("AppName/FinishTime could not be set in session!");
    return false;
  }
  return true;
}

Future<bool> checkForOverlayPermissions() async{
  if (!await FlutterForegroundTask.canDrawOverlays) {
    final isGranted = await FlutterForegroundTask.openSystemAlertWindowSettings();
    if (!isGranted) {
      debugPrint('SYSTEM_ALERT_WINDOW permission denied!');
      return false;
    }
  }
  return true;
}