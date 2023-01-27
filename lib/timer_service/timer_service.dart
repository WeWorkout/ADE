import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:ade/timer_service/handler/timer_task_handler.dart';
import 'package:ade/timer_service/utils/ForegroundServiceUtils.dart';
import 'package:ade/timer_service/utils/timer_service_notifications_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

createTimerServiceForApp(DateTime finishTime, String appName) async {
  debugPrint("Timer Service started!");
  // Creates a foreground service with a notification
  initNotificationForegroundTask(finishTime, appName);

  // Initialize the receiver port
  final receivePort = await FlutterForegroundTask.receivePort;

  // Start the foreground Service
  _startForegroundTask(receivePort, appName, finishTime);
}

// Isolate Code
@pragma('vm:entry-point')
void startCallback() async{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // The setTaskHandler function must be called to handle the task in the background.
  String? appName = await FlutterForegroundTask.getData(key: APP_NAME_CUSTOM_DATA_KEY) as String?;
  String? finishTimeString = await FlutterForegroundTask.getData(key: FINISH_TIME_CUSTOM_DATA_KEY) as String?;

  if(appName == null || finishTimeString == null){
    debugPrint("Appname/FinishTime could not be received from custom data!");
    return;
  }

  DateTime finishTime = DateTime.parse(finishTimeString);

  // Start the Task through the handler
  FlutterForegroundTask.setTaskHandler(TimerTaskHandler(appName, finishTime));
}

Future<bool> _startForegroundTask(ReceivePort? receivePort, String appName, DateTime finishTime) async {
  // Ask for permissions for overlay if not yet granted!
  bool isOverlayPermissionGranted = await checkForOverlayPermissions();
  if(!isOverlayPermissionGranted){
    return false;
  }

  bool sessionDataStored = await storeForegroundSessionData(appName, finishTime);
  if(!sessionDataStored){
    return false;
  }

  // Will Override service if already running
  bool reqResult;
  if (await FlutterForegroundTask.isRunningService) {
    reqResult = await FlutterForegroundTask.clearAllData();
    reqResult = await FlutterForegroundTask.stopService();
  }

  // Start the Foreground Service
  reqResult = await FlutterForegroundTask.startService(
    notificationTitle:  getNotificationTitle(appName, finishTime),
    notificationText: getNotificationDescription(DateTime.now(), finishTime),
    callback: startCallback,
  );

  // Check if it was successful and register listener
  if (reqResult) {
    receivePort = await FlutterForegroundTask.receivePort;
  }
  else{
    debugPrint("Timer foreground service did not start!");
  }

  return _registerReceivePort(receivePort);
}


// Can be used to listen to messages and take actions
bool _registerReceivePort(ReceivePort? receivePort) {

  if (receivePort != null) {
    receivePort.listen((message) {
      if (message is String) {

      }
    });

    return true;
  }
  return false;
}