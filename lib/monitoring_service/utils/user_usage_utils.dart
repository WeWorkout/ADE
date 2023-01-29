import 'package:ade/main_app_ui/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

Future<Map<String, UsageInfo>> getCurrentUsageStats() async{
  DateTime endDate = DateTime.now();
  DateTime startDate = endDate.subtract(const Duration(hours: 1));

  Map<String, UsageInfo> queryAndAggregateUsageStats = await UsageStats.queryAndAggregateUsageStats(startDate, endDate);

  return queryAndAggregateUsageStats;
}

String? checkIfAnyAppHasBeenOpened(
    Map<String, UsageInfo> currentUsage,
    Map<String, UsageInfo> previousUsage,
    Map<String, ApplicationData> monitoredApplicationSet,
    Set<String> openedApplicationsSet){

  for(String appId in monitoredApplicationSet.keys) {
    if(currentUsage.containsKey(appId) && previousUsage.containsKey(appId)) {
      UsageInfo currentAppUsage = currentUsage[appId]!;
      UsageInfo previousAppUsage = previousUsage[appId]!;

      if(currentAppUsage.lastTimeUsed != previousAppUsage.lastTimeUsed) {
        debugPrint("App last time used changed from ${previousAppUsage.lastTimeUsed} to ${currentAppUsage.lastTimeUsed}");
        // Case of user using the app and then closing it
        if(openedApplicationsSet.contains(appId)){
          openedApplicationsSet.remove(appId);
          return null;
        }
        // User opened the app
        else{
          openedApplicationsSet.add(appId);
          return appId;
        }
      }
    }
  }

  return null;
}