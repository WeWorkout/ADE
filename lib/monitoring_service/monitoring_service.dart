import 'dart:async';


import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/monitoring_service/utils/user_usage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:usage_stats/usage_stats.dart';


const String STOP_MONITORING_SERVICE_KEY = "stop";
const String SET_APP_NAME_FOR_MONITORING_KEY = "setAppNames";
const String APP_NAMES_LIST_KEY = "appNames";

// Entry Point for Monitoring Isolate
@pragma('vm:entry-point')
onMonitoringServiceStart(ServiceInstance service) async{
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();
  // UsageStats.grantUsagePermission();

  Set<String> appNames = {};
  Set<String> appsOpenedStateSet = {};

  _registerAllListeners(service, appNames);

  // Monitor all Apps periodically to trigger alert window service
  Map<String, UsageInfo> previousUsageSession = await getCurrentUsageStats();
  Timer.periodic(const Duration(seconds: 2), (timer) async{
    Map<String, UsageInfo> currentUsageSession = await getCurrentUsageStats();
    String? appOpened = checkIfAnyAppHasBeenOpened(currentUsageSession, previousUsageSession, appNames, appsOpenedStateSet);
    if(appOpened != null){
      // Open Alert Window overlay
      AlertDialogService.createAlertDialog(appOpened, false);
    }
    previousUsageSession = currentUsageSession;
  });

}

_registerAllListeners(ServiceInstance service, Set<String> appNames){
  // Register a listener to stop the monitoring service
  service.on(STOP_MONITORING_SERVICE_KEY).listen((event) {
    service.stopSelf();
  });

  // Register a listener to add Apps that need to be monitored
  service.on(SET_APP_NAME_FOR_MONITORING_KEY).listen((event) {
    if(event!=null && event.isNotEmpty) {
      List appNamesList = event[APP_NAMES_LIST_KEY] as List;
      for(dynamic appName in appNamesList){
        appNames.add(appName as String);
      }
    }
    else {
      debugPrint('App Names list was empty');
    }
  });
}

