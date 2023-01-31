import 'dart:async';

import 'package:ade/database/database_service.dart';
import 'package:ade/main_app_ui/home.dart';
import 'package:ade/timer_service/utils/foreground_service_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usage_stats/usage_stats.dart';

class PermissionsScreen extends StatefulWidget{

  DatabaseService dbService;
  PermissionsScreen(this.dbService);

  @override
  State<StatefulWidget> createState() {
    return _PermissionsScreenState();
  }
}

class _PermissionsScreenState extends State<PermissionsScreen>{

  bool usagePermissionGranted = false;
  bool drawOverOtherAppsPermissionGranted = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async{
      usagePermissionGranted = (await UsageStats.checkUsagePermission())!;
      drawOverOtherAppsPermissionGranted = await FlutterForegroundTask.canDrawOverlays;
      setState(() {});
    });
  }

  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.greenAccent,
        body: Column(
                children: [
                  SizedBox(height: screenHeight*0.07,),
                  Text("Permissions Required", style: TextStyle(fontSize: screenWidth*0.06,),),
                  SizedBox(height: screenHeight*0.05,),
                  _aboutPermissionsSection(),
                  SizedBox(height: screenHeight*0.04,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _usagePermissionWidget(),
                      SizedBox(width: screenWidth*0.07,),
                      _overlayWidgetPermissionWidget(),
                    ],
                  ),
                  const Spacer(),
                  drawOverOtherAppsPermissionGranted && usagePermissionGranted ? _continueToAppButton() : const SizedBox.shrink(),
                  SizedBox(height: screenHeight*0.04,)
                ],
              )
             );

    }

    Widget _aboutPermissionsSection(){
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;

      return Center(
        child: SizedBox(
          height: screenHeight*0.4,
          width: screenWidth*0.95,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.03,),
                Row(
                  children: [
                    SizedBox(width: screenWidth*0.1,),
                    CircleAvatar(
                      backgroundColor:Colors.blue,
                      radius: screenWidth*0.09,
                      child: Icon(Icons.query_stats, size: screenWidth*0.13, color: Colors.white,)
                    ),
                    SizedBox(width: screenWidth*0.04,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Usage Stats", style: TextStyle(fontSize: screenWidth*0.04,fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                        Text("To determine Application startup", style: TextStyle(fontSize: screenWidth*0.03, fontStyle: FontStyle.italic),)
                      ],
                    )
                  ],
                ),
                SizedBox(height: screenHeight*0.03,),
                Row(
                  children: [
                    SizedBox(width: screenWidth*0.1,),
                    CircleAvatar(
                        backgroundColor:Colors.blue,
                        radius: screenWidth*0.09,
                        child: Icon(Icons.timer, size: screenWidth*0.13, color: Colors.white,)
                    ),
                    SizedBox(width: screenWidth*0.04,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Display Over Apps", style: TextStyle(fontSize: screenWidth*0.04,fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                        Text("To popup a timer display", style: TextStyle(fontSize: screenWidth*0.03, fontStyle: FontStyle.italic),)
                      ],
                    )
                  ],
                ),
                SizedBox(height: screenHeight*0.04,),
                InkWell(
                  onTap: () => _openGithubSourceCodeLink(),
                  child: Column(
                    children: [
                      SizedBox(
                          height: screenHeight*0.07,
                          width: screenWidth*0.5,
                          child: const Image(image: AssetImage("assets/icons/githubIcon.png"))
                      ),
                      Text("Source Code link", style: TextStyle(fontSize: screenWidth*0.03, decoration: TextDecoration.underline),)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget _continueToAppButton(){
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;

      return MaterialButton(
          padding: const EdgeInsets.all(10),
          onPressed: (drawOverOtherAppsPermissionGranted && usagePermissionGranted)
              ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home(widget.dbService)))
              : null,
          color: Colors.white,
          disabledColor: Colors.grey,
          child: Text("Continue to App", style: TextStyle(fontSize: screenWidth*0.04),),
      );
    }
    Widget _usagePermissionWidget(){
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;

      return SizedBox(
        height: screenHeight*0.15,
        width: screenWidth*0.35,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          elevation: 10,
          color: Colors.blue,
          child: Column(
            children: [
              SizedBox(height: screenHeight*0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.query_stats, size: screenWidth*0.1, color: Colors.white,),
                  Text(" : ", style: TextStyle(fontSize: screenWidth*0.045),),
                  Icon(
                      usagePermissionGranted
                          ? Icons.check_circle_sharp
                          : Icons.close_rounded,
                      color: usagePermissionGranted
                          ? Colors.green
                          : Colors.red,
                      size: screenWidth*0.1,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight*0.01,
              ),
              MaterialButton(
                color: Colors.white,
                disabledColor: Colors.grey,
                onPressed: usagePermissionGranted
                    ? null
                    : () async{
                  await _askForUsagePermission();
                  setState(() {});
                },
                child: Text("Grant", style: TextStyle(fontSize: screenWidth*0.03),),
              )
            ],
          ),
        ),
      );
    }

    Widget _overlayWidgetPermissionWidget(){
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;

      return SizedBox(
        height: screenHeight*0.15,
        width: screenWidth*0.35,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          elevation: 10,
          color: Colors.blue,
          child: Column(
            children: [
              SizedBox(height: screenHeight*0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer, size: screenWidth*0.1, color: Colors.white,),
                  Text(" : ", style: TextStyle(fontSize: screenWidth*0.045),),
                  Icon(
                    drawOverOtherAppsPermissionGranted
                        ? Icons.check_circle_sharp
                        : Icons.close_rounded,
                    color: drawOverOtherAppsPermissionGranted
                        ? Colors.green
                        : Colors.red,
                    size: screenWidth*0.1,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight*0.01,
              ),
              MaterialButton(
                color: Colors.white,
                disabledColor: Colors.grey,
                onPressed: drawOverOtherAppsPermissionGranted
                    ? null
                    : () async{
                  await _askForDisplayOverWidgetsPermission();
                  setState(() {});
                },
                child: Text("Grant", style: TextStyle(fontSize: screenWidth*0.03),),
              )
            ],
          ),
        ),
      );
    }

    _askForUsagePermission() async{
      UsageStats.grantUsagePermission();
    }

    _askForDisplayOverWidgetsPermission() async{
      bool overlayPermissionsGranted = await checkForOverlayPermissions();
      if(!overlayPermissionsGranted){
        debugPrint("Overlay Permissions not granted!");
      }
    }

    _openGithubSourceCodeLink() async{
      String url = "https://github.com/WeWorkout/ADE/tree/master";
      try{
        if (await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url));
      }

      else {
      throw "Could not launch $url";
      }
      }
      catch(e){
      debugPrint("Error while launching URL: $e");
      }
    }

}