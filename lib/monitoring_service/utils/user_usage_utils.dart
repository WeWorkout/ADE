import 'package:ade/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

Future<Map<String, UsageInfo>> getCurrentUsageStats() async{
  DateTime endDate = DateTime.now();
  DateTime startDate = endDate.subtract(const Duration(minutes: 3));

  Map<String, UsageInfo> queryAndAggregateUsageStats = await UsageStats.queryAndAggregateUsageStats(startDate, endDate);
  return queryAndAggregateUsageStats;
}

String? checkIfAnyAppHasBeenOpened(
    Map<String, UsageInfo> currentUsage,
    Map<String, UsageInfo> previousUsage,
    Map<String, ApplicationData> monitoredApplicationSet){

  /*
      (i) Last used time updates when an app is opened as well as well then app is closed [Point a and Point b]
      (ii) Foreground total time changes when an app is closed [Point b]
      So to determine the startup, we can check for (i) first, and then to confirm that its not a "App Closing" use case
      we can crosscheck it with the foreground total time use case as well
     */

  for(String appId in monitoredApplicationSet.keys) {
    if(currentUsage.containsKey(appId) && previousUsage.containsKey(appId)) {
      UsageInfo currentAppUsage = currentUsage[appId]!;
      UsageInfo previousAppUsage = previousUsage[appId]!;

      // debugPrint("Current Last Time Stamp: ${currentAppUsage.lastTimeStamp}");
      // debugPrint("Current Last Time Used: ${currentAppUsage.lastTimeUsed}");
      // debugPrint("Current Foreground Time: ${currentAppUsage.totalTimeInForeground}");
      // debugPrint("-----------------------------------------");

      if(currentAppUsage.lastTimeUsed != previousAppUsage.lastTimeUsed) {
        if(currentAppUsage.totalTimeInForeground != previousAppUsage.totalTimeInForeground){
          debugPrint("App was closed!");
          return null;
        }
        else{
          debugPrint("App was opened: ${currentAppUsage.totalTimeInForeground} &&&& ${currentAppUsage.lastTimeUsed}");
          return appId;
        }
      }
    }
  }

  return null;
}