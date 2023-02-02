
import 'package:ade/alert_dialog_service/overlay_widget.dart';
import 'package:ade/database/database_service.dart';
import 'package:ade/main_app_ui/home.dart';
import 'package:ade/main_app_ui/permissions_screen.dart';
import 'package:ade/startup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:usage_stats/usage_stats.dart';


// This is the isolate entry for the Alert Window Service
// It needs to be added in the main.dart file with the name "overlayMain"...(jugaadu code max by plugin dev)
@pragma("vm:entry-point")
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService dbService = await DatabaseService.instance();
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: true,
      home: OverlayWidget(dbService)
  ));
}

void main() async {
  // Startup the app
  await onStart();
  DatabaseService dbService = await DatabaseService.instance();
  bool permissionsAvailable = (await UsageStats.checkUsagePermission())! && await FlutterForegroundTask.canDrawOverlays;
  runApp(MyApp(permissionsAvailable ? Home(dbService) : PermissionsScreen(dbService), dbService));
}

class MyApp extends StatelessWidget {
  Widget screenToDisplay;

  DatabaseService dbService;
  MyApp(this.screenToDisplay, this.dbService);


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
