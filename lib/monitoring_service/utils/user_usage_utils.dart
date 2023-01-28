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
    Set<String> appNamesSet,
    Set<String> appsOpenedStateSet){

  for(String appName in appNamesSet) {
    if(currentUsage.containsKey(appName) && previousUsage.containsKey(appName)) {
      UsageInfo currentAppUsage = currentUsage[appName]!;
      UsageInfo previousAppUsage = previousUsage[appName]!;

      if(currentAppUsage.lastTimeUsed != previousAppUsage.lastTimeUsed) {
        debugPrint("App last time used changed from ${previousAppUsage.lastTimeUsed} to ${currentAppUsage.lastTimeUsed}");
        // Case of user using the app and then closing it
        if(appsOpenedStateSet.contains(appName)){
          appsOpenedStateSet.remove(appName);
          return null;
        }
        // User opened the app
        else{
          appsOpenedStateSet.add(appName);
          return appName;
        }
      }
    }
  }

  return null;
}