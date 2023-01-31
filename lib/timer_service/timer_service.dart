import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';

createTimerServiceForApp(DateTime finishTime, String appName, String appId) async {
  debugPrint("Timer Service started!");
  // Creates a foreground service with a notification
  initNotificationForegroundTask(finishTime, appName);

  // Initialize the receiver port
  final receivePort = await getForegroundServiceReceivePort();

  // Start the foreground Service
  _startForegroundTask(receivePort, appName, appId, finishTime);
}

// Isolate Code
@pragma('vm:entry-point')
void startCallback() async{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // Start the Task through the handler..
  // Make sure appName and finishTime are initialized!
  setTaskHandlerWithSessionData();

}

Future<bool> _startForegroundTask(ReceivePort? receivePort, String appName, String appId, DateTime finishTime) async {
  // Ask for permissions for overlay if not yet granted!
  bool isOverlayPermissionGranted = await checkForOverlayPermissions();
  if(!isOverlayPermissionGranted){
    return false;
  }

  bool sessionDataStored = await storeForegroundSessionData(appName, appId, finishTime);
  if(!sessionDataStored){
    return false;
  }

  // Will Override service if already running
  bool reqResult;
  await killOngoingServiceIfAny();

  // Start the Foreground Service
  reqResult = await startForegroundService(appName, finishTime, startCallback);

  // Check if it was successful and register listener
  if (reqResult) {
    receivePort = await getForegroundServiceReceivePort();
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