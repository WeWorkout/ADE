import 'dart:async';
import 'dart:isolate';

import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class TimerTaskHandler extends TaskHandler {
  final DateTime finishTime;

  TimerTaskHandler(this.finishTime);

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    debugPrint("OnStart of timer service started!");
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      bool isDone = false;
      DateTime currentTime = DateTime.now();

      if(finishTime.isBefore(currentTime) || finishTime.isAtSameMomentAs(currentTime)){
        timer.cancel();
        await _finalizeTimerService();
        isDone = true;
      }
      if(!isDone){
        bool updateNotification = await updateForegroundServiceNotification(finishTime, currentTime);
        if(!updateNotification){
          debugPrint("Notification was not updated!");
        }
      }

    });

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    debugPrint("OnEvent of timer service started!");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    debugPrint("OnDestroy of timer service started!");
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

_finalizeTimerService() async{
  debugPrint("Timer is complete!");
  await AlertDialogService.createAlertDialog();
  await killOngoingServiceIfAny();
}