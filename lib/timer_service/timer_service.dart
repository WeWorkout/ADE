import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';

Future<void> createTimerServiceForApp(DateTime finishTime) async {
  debugPrint("Timer Service started for time : $finishTime!");
  // Creates a foreground service with a notification
  initNotificationForegroundTask(finishTime);

  // Initialize the receiver port
  final receivePort = await getForegroundServiceReceivePort();

  // Start the foreground Service
  _startForegroundTask(receivePort, finishTime);
}

// Isolate Code
@pragma('vm:entry-point')
void startCallback() async{
  debugPrint("Starting Timer Service Isolate!");
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // Start the Task through the handler..
  // Make sure appName and finishTime are initialized!
  setTaskHandlerWithSessionData();

}

Future<bool> _startForegroundTask(ReceivePort? receivePort, DateTime finishTime) async {
  // Ask for permissions for overlay if not yet granted!
  bool isOverlayPermissionGranted = await checkForOverlayPermissions();
  if(!isOverlayPermissionGranted){
    return false;
  }
  // Will Override service if already running
  bool reqResult;
  await killOngoingServiceIfAny();

  bool sessionDataStored = await storeForegroundSessionData(finishTime);
  if(!sessionDataStored){
    return false;
  }


  // Start the Foreground Service
  reqResult = await startForegroundService(finishTime, startCallback);

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