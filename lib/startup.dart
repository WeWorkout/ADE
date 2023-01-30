import 'dart:ui';

import 'package:ade/monitoring_service/utils/flutter_background_service_utils.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await startMonitoringService();
}

