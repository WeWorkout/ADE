import 'dart:async';
import 'dart:isolate';

import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class TimerTaskHandler extends TaskHandler {
  final DateTime finishTime;
  final String appName;

  TimerTaskHandler(this.appName, this.finishTime);

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      bool isDone = false;
      DateTime currentTime = DateTime.now();

      if(finishTime.isBefore(currentTime) || finishTime.isAtSameMomentAs(currentTime)){
        timer.cancel();
        await _finalizeTimerService(appName);
        isDone = true;
      }
      if(!isDone){
        bool updateNotification = await updateForegroundServiceNotification(appName, finishTime, currentTime);
        if(!updateNotification){
          debugPrint("Notification was not updated!");
        }
      }

    });

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {

  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await killOngoingServiceIfAny();
  }

  @override
  void onButtonPressed(String id) {

  }

  @override
  void onNotificationPressed() {
  }
}

_finalizeTimerService(String appName) async{
  debugPrint("Timer for ${appName} is complete!");
  AlertDialogService.createAlertDialog(appName, true);
  await killOngoingServiceIfAny();
}