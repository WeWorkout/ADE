import 'dart:isolate';
import 'package:ade/timer_service/handler/timer_task_handler.dart';
import 'package:ade/timer_service/utils/timer_service_notifications_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

const String APP_NAME_CUSTOM_DATA_KEY = "App_Name";
const String APP_ID_CUSTOM_DATA_KEY = "App_ID";
const String FINISH_TIME_CUSTOM_DATA_KEY = "Duration_Time";
const String SERVICE_RUNNING_STATUS_MESSAGE_KEY = "isServiceRunning";
const String UPDATE_TIMER_BUTTON_KEY = "UpdateTimer";
const String STOP_TIMER_BUTTON_KEY = "StopTimer";

void initNotificationForegroundTask(DateTime finishTime) {
  debugPrint("Initializing Time Foreground Service!");
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelName: 'Foreground Notification',
      channelId: 'notification_channel_id',
      channelDescription:
      'Timer Service is running for duration: ${finishTime.toString()}',
      channelImportance: NotificationChannelImportance.MAX,
      priority: NotificationPriority.MAX,
      iconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
        //backgroundColor: Colors.blue,
      ),
      buttons: [
        // Handled in the handler according to the id
        const NotificationButton(id: UPDATE_TIMER_BUTTON_KEY, text: "Update"),
        const NotificationButton(id: STOP_TIMER_BUTTON_KEY, text: "Stop")
      ]

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

Future<bool> startForegroundService(DateTime finishTime, Function startCallBack){
  return FlutterForegroundTask.startService(
    notificationTitle:  getNotificationTitle(finishTime),
    notificationText: getNotificationDescription(DateTime.now(), finishTime),
    callback: startCallBack,
  );
}

void setTaskHandlerWithSessionData() async{
  // The setTaskHandler function must be called to handle the task in the background.
  String? finishTimeString = await FlutterForegroundTask.getData(key: FINISH_TIME_CUSTOM_DATA_KEY) as String?;

  if(finishTimeString == null){
    debugPrint("FinishTime could not be received from custom data!");
    return;
  }

  DateTime finishTime = DateTime.parse(finishTimeString);

  FlutterForegroundTask.setTaskHandler(TimerTaskHandler(finishTime));
}

Future<bool> updateForegroundServiceNotification(DateTime finishTime, DateTime currentTime){
  return FlutterForegroundTask.updateService(
      notificationTitle: getNotificationTitle(finishTime),
      notificationText: getNotificationDescription(currentTime, finishTime)
  );
}

Future<bool> storeForegroundSessionData(DateTime finishTime) async{
  // You can save data using the saveData function.
  // Here saving the App-Name and the Duration
  bool finishTimeSet = await FlutterForegroundTask.saveData(key: FINISH_TIME_CUSTOM_DATA_KEY, value: finishTime.toString());
  if(!finishTimeSet){
    debugPrint("FinishTime could not be set in custom data!");
    return false;
  }
  return true;
}

Future<void> killOngoingServiceIfAny() async {
  debugPrint("Killing timer service");
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

Future<bool> getCurrentRunningAppId() {
  return isTimerServiceRunning();
}