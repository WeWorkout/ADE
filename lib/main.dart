
import 'package:ade/alert_dialog_service/overlay_widget.dart';
import 'package:ade/database/database_service.dart';
import 'package:ade/main_app_ui/home.dart';
import 'package:ade/main_app_ui/permissions_screen.dart';
import 'package:ade/startup.dart';
import 'package:ade/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:usage_stats/usage_stats.dart';


// This is the isolate entry for the Alert Window Service
// It needs to be added in the main.dart file with the name "overlayMain"...(jugaadu code max by plugin dev)
@pragma("vm:entry-point")
void overlayMain() async {
  debugPrint("Starting Alerting Window Isolate!");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      theme: Themes.mainTheme(),
      debugShowCheckedModeBanner: false,
      home: OverlayWidget()
  ));
}

void main() async {
  debugPrint("Starting main Isolate!");
  // Start the monitoring service
  await onStart();
  DatabaseService dbService = await DatabaseService.instance();
  bool permissionsAvailable = (await UsageStats.checkUsagePermission())! &&
      await FlutterForegroundTask.canDrawOverlays;
  runApp(MyApp(
      permissionsAvailable ? Home(dbService) : PermissionsScreen(dbService),
      dbService));
}

class MyApp extends StatelessWidget {
  Widget screenToDisplay;

  DatabaseService dbService;

  MyApp(this.screenToDisplay, this.dbService);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.mainTheme(),
      home: screenToDisplay,
    );
  }
}
