
import 'package:ade/alert_dialog_service/overlay_widget.dart';
import 'package:ade/startup.dart';
import 'package:flutter/material.dart';

import 'main_app_ui/home.dart';

void main() async {
  // Startup the app
  await onStart();

  runApp(const MyApp());
}


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


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(),
    );
  }
}
