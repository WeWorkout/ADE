
import 'package:ade/monitor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  IosConfiguration iosConfiguration = IosConfiguration();

  AndroidConfiguration androidConfiguration = AndroidConfiguration(
      onStart: onServiceStart, autoStart: true, isForegroundMode: true);

  await service.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration);

  service.startService();
}


