import 'dart:isolate';
import 'package:ade/timer_service/handler/timer_task_handler.dart';
import 'package:ade/timer_service/utils/timer_service_notifications_utils.dart';
import 'package:flutter/cupertino.dart';
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

Future<bool> startForegroundService(String appName, DateTime finishTime, Function startCallBack){
  return FlutterForegroundTask.startService(
    notificationTitle:  getNotificationTitle(appName, finishTime),
    notificationText: getNotificationDescription(DateTime.now(), finishTime),
    callback: startCallBack,
  );
}

void setTaskHandlerWithSessionData() async{
  // The setTaskHandler function must be called to handle the task in the background.
  String? appName = await FlutterForegroundTask.getData(key: APP_NAME_CUSTOM_DATA_KEY) as String?;
  String? finishTimeString = await FlutterForegroundTask.getData(key: FINISH_TIME_CUSTOM_DATA_KEY) as String?;

  if(appName == null || finishTimeString == null){
    debugPrint("AppName/FinishTime could not be received from custom data!");
    return;
  }

  DateTime finishTime = DateTime.parse(finishTimeString);

  FlutterForegroundTask.setTaskHandler(TimerTaskHandler(appName, finishTime));
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
    debugPrint("AppName/FinishTime could not be set in custom data!");
    return false;
  }
  return true;
}

killOngoingServiceIfAny() async {
  if (await FlutterForegroundTask.isRunningService) {
    bool isDataCleared = await FlutterForegroundTask.clearAllData();
    bool isServiceStopped = await FlutterForegroundTask.stopService();

    if(!(isDataCleared && isServiceStopped)){
      debugPrint("Issue in killing service: $isDataCleared  $isServiceStopped");
    } else {
      debugPrint("Timer Service killed successfully!");
    }
  }
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

Future<ReceivePort?> getForegroundServiceReceivePort() async{
  return FlutterForegroundTask.receivePort;
}

Future<bool> isTimerServiceRunning() async{
  return FlutterForegroundTask.isRunningService;
}

Future<String?> getCurrentRunningAppName() async{
  if(await isTimerServiceRunning()){
    String? appName = await FlutterForegroundTask.getData(key: APP_NAME_CUSTOM_DATA_KEY) as String?;
    return appName;
  }
  else{
    return null;
  }
}