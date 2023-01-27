
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:ade/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:usage_stats/usage_stats.dart';

@pragma('vm:entry-point')
onServiceStart(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  Set<String> appNames = {};
  Map<String, UsageInfo> usageInfo = {};

  service.on('stop').listen((event) {
    service.stopSelf();
  });

  service.on('setAppNames').listen((event) {
    if(event!=null && event.isNotEmpty) {
      appNames = Set.from(event['appNames'] as List);
    }
    else {
      print('Event is null or empty!');
    }
  });

  service.on('timer').listen((event) {
    print('timer callback');
  });

  int count = 0;
  Timer.periodic(const Duration(seconds: 2), (timer) {
    print('periodic');
    process(service, appNames, usageInfo);
  });

}

process(ServiceInstance service, Set<String> appPackageNames, Map<String, UsageInfo> previousUsageStats) async {
  var usageStats = await _getUsageStats();
  usageStats = _pruneUsageStats(appPackageNames, usageStats);

  for(String appName in appPackageNames) {
    if(usageStats.containsKey(appName) && previousUsageStats.containsKey(appName)) {
      if(usageStats[appName]!.lastTimeUsed != previousUsageStats[appName]!.lastTimeUsed) {
        print("invoked");
        service.invoke('showDialog');
        FlutterOverlayWindow.showOverlay();
        //FlutterOverlayWindow.shareData(service);
        //showOverlayWindow(service);
      }
      else {
        print("handle other conditions in internal");
      }
    } else if(usageStats.containsKey(appName) || previousUsageStats.containsKey(appName)) {
      service.invoke('showDialog');
    } else {
      print("handle other conditions in external");
    }
  }

  _copyUsageStats(previousUsageStats, usageStats);

}

Future<Map<String, UsageInfo>> _getUsageStats() async {

  UsageStats.grantUsagePermission();

  DateTime endDate = DateTime.now();
  DateTime startDate = endDate.subtract(const Duration(hours: 1));

  Map<String, UsageInfo> queryAndAggregateUsageStats = await UsageStats.queryAndAggregateUsageStats(startDate, endDate);

  return queryAndAggregateUsageStats;
}

Map<String, UsageInfo> _pruneUsageStats(Set<String> appPackageNames, Map<String, UsageInfo> usageStats) {
  Map<String, UsageInfo> result = {};
  for(String appPackageName in appPackageNames) {
    if(usageStats.containsKey(appPackageName)) {
      result[appPackageName] = usageStats[appPackageName]!;
    }
  }
  return result;
}

_copyUsageStats(Map<String, UsageInfo> previous, Map<String, UsageInfo> current) {
  previous.clear();
  for(String key in current.keys) {
    previous[key] = current[key]!;
  }
}