import 'dart:ui';

import 'package:ade/monitoring_service/utils/flutter_background_service_utils.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usage_stats/usage_stats.dart';

onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await Hive.initFlutter();

  await _getAllPermissions();

  await startMonitoringService();
}

_getAllPermissions() async{
  // Get all permissions
  // Maintain order to avoid fuck up of usage stats permission
  bool overlayPermissionsGranted = await checkForOverlayPermissions();
  if(!overlayPermissionsGranted){
    debugPrint("Overlay Permissions not granted!");
  }
  UsageStats.grantUsagePermission();
}
