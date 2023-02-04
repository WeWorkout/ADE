import 'dart:async';

import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/database/database_service.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:ade/monitoring_service/utils/user_usage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:usage_stats/usage_stats.dart';


const String STOP_MONITORING_SERVICE_KEY = "stop";
const String SET_APPS_NAME_FOR_MONITORING_KEY = "setAppsNames";
const String APP_NAMES_LIST_KEY = "appNames";

// Entry Point for Monitoring Isolate
@pragma('vm:entry-point')
onMonitoringServiceStart(ServiceInstance service) async {
  debugPrint("Starting Monitoring Service Isolate!");
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService dbService = await DatabaseService.instance();
  await AlertDialogService.refreshDatabase();

  // Using AppIds as reference here
  Map<String, ApplicationData> monitoredApplicationSet = {};
  Set<String> openedApplicationsSet = {};

  _registerAllListeners(service);


  // Monitor all Apps periodically to trigger alert window service
  Map<String, UsageInfo> previousUsageSession = await getCurrentUsageStats(monitoredApplicationSet);
  Timer.periodic(const Duration(seconds: 2), (timer) async{
    _setMonitoringApplicationsInSetFromBox(dbService, monitoredApplicationSet);
    Map<String, UsageInfo> currentUsageSession = await getCurrentUsageStats(monitoredApplicationSet);
    String? appOpened = checkIfAnyAppHasBeenOpened(currentUsageSession, previousUsageSession, monitoredApplicationSet, openedApplicationsSet);
    if(appOpened != null){
      // Open Alert Window overlay
      AlertDialogService.createAlertDialog(monitoredApplicationSet[appOpened]!);
    }
    previousUsageSession = currentUsageSession;
  });

}

_registerAllListeners(ServiceInstance service){
  // Register a listener to stop the monitoring service
  service.on(STOP_MONITORING_SERVICE_KEY).listen((event) {
    service.stopSelf();
  });

}

_setMonitoringApplicationsInSetFromBox(DatabaseService dbService, Map<String, ApplicationData> monitoredApplicationSet) async {
  List<ApplicationData> monitoredApps = dbService.getAllAppData();
  monitoredApplicationSet.clear();
  for(ApplicationData app in monitoredApps) {
    monitoredApplicationSet[app.appId] = app;
  }
}

