import 'dart:async';

import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/main_app_ui/dtos/application_data.dart';
import 'package:ade/monitoring_service/utils/user_usage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:usage_stats/usage_stats.dart';


const String STOP_MONITORING_SERVICE_KEY = "stop";
const String SET_APPS_NAME_FOR_MONITORING_KEY = "setAppsNames";
const String APP_NAMES_LIST_KEY = "appNames";

// Entry Point for Monitoring Isolate
@pragma('vm:entry-point')
onMonitoringServiceStart(ServiceInstance service) async{
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();
  // UsageStats.grantUsagePermission();

  // Using AppIds as reference here
  Set<String> monitoredApplicationSet = {};
  Set<String> openedApplicationsSet = {};

  _registerAllListeners(service, monitoredApplicationSet);

  // Monitor all Apps periodically to trigger alert window service
  Map<String, UsageInfo> previousUsageSession = await getCurrentUsageStats();
  Timer.periodic(const Duration(seconds: 2), (timer) async{
    Map<String, UsageInfo> currentUsageSession = await getCurrentUsageStats();
    String? appOpened = checkIfAnyAppHasBeenOpened(currentUsageSession, previousUsageSession, monitoredApplicationSet, openedApplicationsSet);
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
  service.on(SET_APPS_NAME_FOR_MONITORING_KEY).listen((event) {
    if(event!=null && event.isNotEmpty) {
      List appDataList = event[APP_NAMES_LIST_KEY] as List;
      for(dynamic appDataObject in appDataList){
        ApplicationData appData = appDataObject as ApplicationData;
        appNames.add(appData.appId);
      }
    }
    else {
      debugPrint('Applications list was empty');
    }
  });
}

