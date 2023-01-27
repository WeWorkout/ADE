

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:ade/timer_service/utils/timer_service_notifications_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

const String APP_NAME_CUSTOM_DATA_KEY = "App_Name";
const String FINISH_TIME_CUSTOM_DATA_KEY = "Duration_Time";
const String SERVICE_RUNNING_STATUS_MESSAGE_KEY = "isServiceRunning";

createTimerServiceForApp(DateTime finishTime, String appName) async {
  debugPrint("Timer Service started!");
  // Creates a foreground service with a notification
  _initNotificationForegroundTask(finishTime, appName);
  final receivePort = await FlutterForegroundTask.receivePort;
  _startForegroundTask(receivePort, appName, finishTime);
}

@pragma('vm:entry-point')
void startCallback() async{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // The setTaskHandler function must be called to handle the task in the background.
  String? appName = await FlutterForegroundTask.getData(key: APP_NAME_CUSTOM_DATA_KEY) as String?;
  String? finishTimeString = await FlutterForegroundTask.getData(key: FINISH_TIME_CUSTOM_DATA_KEY) as String?;

  if(appName == null || finishTimeString == null){
    debugPrint("Appname/FinishTime could not be received!");
    return;
  }

  DateTime finishTime = DateTime.parse(finishTimeString);

  FlutterForegroundTask.setTaskHandler(MyTaskHandler(appName, finishTime));
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;

  final DateTime finishTime;
  final String appName;

  MyTaskHandler(this.appName, this.finishTime);

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      bool isDone = false;
      debugPrint("Timer service periodic statement...");
      DateTime currentTime = DateTime.now();
      if(finishTime.isBefore(currentTime) || finishTime.isAtSameMomentAs(currentTime)){
        timer.cancel();
        debugPrint("Timer for ${appName} is complete!");

        //ToDo: Re-trigger Alert Window to extend

        FlutterForegroundTask.clearAllData();
        FlutterForegroundTask.stopService();
        isDone = true;
      }
      if(!isDone){
        FlutterForegroundTask.updateService(
            notificationTitle: getNotificationTitle(appName, finishTime),
            notificationText: getNotificationDescription(currentTime, finishTime)
        );
      }

    });

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {

  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    if(await FlutterForegroundTask.isRunningService){
      bool dataCleared = await FlutterForegroundTask.clearAllData();
      bool serviceStopped = await FlutterForegroundTask.stopService();
      if(dataCleared && serviceStopped){
        debugPrint("Something went wrong in OnDestroy()");
      }
    }
  }

  @override
  void onButtonPressed(String id) {

  }

  @override
  void onNotificationPressed() {
  }
}

void _initNotificationForegroundTask(DateTime finishTime, String appName) {
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

Future<bool> _startForegroundTask(ReceivePort? receivePort, String appName, DateTime finishTime) async {
  // Ask for permissions for overlay if not yet granted!
  if (!await FlutterForegroundTask.canDrawOverlays) {
    final isGranted = await FlutterForegroundTask.openSystemAlertWindowSettings();
    if (!isGranted) {
      debugPrint('SYSTEM_ALERT_WINDOW permission denied!');
      return false;
    }
  }

  // You can save data using the saveData function.
  // Here saving the App-Name and the Duration
  bool appNameSet = await FlutterForegroundTask.saveData(key: APP_NAME_CUSTOM_DATA_KEY, value: appName);
  bool finishTimeSet = await FlutterForegroundTask.saveData(key: FINISH_TIME_CUSTOM_DATA_KEY, value: finishTime.toString());
  if(!(appNameSet && finishTimeSet)){
    debugPrint("Appname/FinishTime could not be set!");
    return false;
  }

  // Will Override service if already running
  bool reqResult;
  if (await FlutterForegroundTask.isRunningService) {
    reqResult = await FlutterForegroundTask.stopService();
  }
  reqResult = await FlutterForegroundTask.startService(
    notificationTitle:  getNotificationTitle(appName, finishTime),
    notificationText: getNotificationDescription(DateTime.now(), finishTime),
    callback: startCallback,
  );

  if (reqResult) {
    receivePort = await FlutterForegroundTask.receivePort;
  }
  else{
    debugPrint("Timer foreground service did not start!");
  }

  return _registerReceivePort(receivePort);
}

Future<bool> _stopForegroundTask() async {
  return await FlutterForegroundTask.stopService();
}

bool _registerReceivePort(ReceivePort? receivePort) {

  if (receivePort != null) {
    receivePort.listen((message) {
      if (message is String) {
        if (message == SERVICE_RUNNING_STATUS_MESSAGE_KEY) {

        }
      }
    });

    return true;
  }
  return false;
}