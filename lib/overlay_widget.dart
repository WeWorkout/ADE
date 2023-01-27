import 'package:ade/timer_service.dart';
import 'package:ade/timer_service/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWidget extends StatefulWidget {
  @override
  State<OverlayWidget> createState() => _OverlayWidget();
}

class _OverlayWidget extends State<OverlayWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: OutlinedButton(
          onPressed: () {
            createTimerServiceForApp(DateTime.now().add(const Duration(minutes: 1)), "Chrome");
            FlutterOverlayWindow.closeOverlay();
          },
          child: const Text("Press me!"),
        ),
      ),
    );
  }
}
