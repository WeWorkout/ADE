
import 'package:ade/alert_dialog_service/overlay_widget.dart';
import 'package:ade/main_app_ui/permissions_screen.dart';
import 'package:ade/startup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:usage_stats/usage_stats.dart';

import 'main_app_ui/home.dart';

// This is the isolate entry for the Alert Window Service
// It needs to be added in the main.dart file with the name "overlayMain"...(jugaadu code max by plugin dev)
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: true,
      home: OverlayWidget()
  ));
}

void main() async {
  // Startup the app
  await onStart();
  bool permissionsAvailable = (await UsageStats.checkUsagePermission())! && await FlutterForegroundTask.canDrawOverlays;
  runApp(MyApp(permissionsAvailable ? Home() : PermissionsScreen()));
}

class MyApp extends StatelessWidget {
  Widget screenToDisplay;

  MyApp(this.screenToDisplay);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: screenToDisplay,
    );
  }
}
