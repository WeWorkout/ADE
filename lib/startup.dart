import 'dart:ui';

import 'package:ade/monitoring_service/utils/flutter_background_service_utils.dart';
import 'package:flutter/material.dart';

onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await startMonitoringService();
}

