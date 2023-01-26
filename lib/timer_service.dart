

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';


createTimerService() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  IosConfiguration iosConfiguration = IosConfiguration();

  AndroidConfiguration androidConfiguration = AndroidConfiguration(
      onStart: onTimerServiceStart, autoStart: true, isForegroundMode: true,
      foregroundServiceNotificationId: 112234
  );

  await service.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration);

  service.startService();
}

@pragma('vm:entry-point')
onTimerServiceStart(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();


  service.on('stop').listen((event) {
    service.stopSelf();
  });


  int count = 0;
  Timer.periodic(const Duration(seconds: 1), (timer) {
    print('periodic $count');
    count++;
  });

}