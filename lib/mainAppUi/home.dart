
import 'package:ade/mainAppUi/utils/user_apps_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:usage_stats/usage_stats.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  late Map<String, UsageInfo> _usageStats;
  final Set<String> _selectedPackages = {'com.android.chrome'};
  int count = 0;
  final service = FlutterBackgroundService();

  @override
  void initState() {
    service.on("showDialog").listen((event) {
      print("received");
      if(_selectedPackages.contains("com.android.chrome")) {
        _selectedPackages.remove("com.android.chrome");
      } else {
        _selectedPackages.add("com.android.chrome");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text("ADE App", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25)),
        actions: [
          Icon(Icons.question_mark_rounded, color: Colors.blue, size: screenWidth*0.06,),
          SizedBox(width: screenWidth*0.04,)],
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight*0.03,),
          _addAppsButton(context),
          SizedBox(height: screenHeight*0.03,),
          _listOfMonitoringApps(context, ["Chrome", "Youtube"])
        ],
      )
    );
  }

  Widget _addAppsButton(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: InkWell(
        onTap: (){
          showInstalledAppsListViewDialog(context, _selectedPackages);
        },
        child: Column(
          children: [
            Icon(Icons.add_circle_outline_outlined, size: screenWidth*0.15,),
            SizedBox(height: screenHeight*0.01,),
            const Text("Add an Application")
          ],
        ),
      ),
    );
  }

  Widget _listOfMonitoringApps(BuildContext context, List<String> applicationsList){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Card(
        elevation: 10.0,
        child: Container(
          height: screenHeight*0.5,
          width: screenWidth*0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)
          ),
          padding: EdgeInsets.all(screenWidth*0.05),
          child: applicationsList.isNotEmpty
              ? ListView.separated(
              separatorBuilder: (BuildContext context, int index){
                return SizedBox(height: screenHeight*0.02,);
              },
              itemCount: applicationsList.length,
              itemBuilder: (BuildContext context, int index){
                  String applicationName = applicationsList[index];
                  return ListTile(
                    leading: Icon(Icons.arrow_forward_ios, size: screenWidth*0.05,),
                    title: Text(applicationName, style: const TextStyle(fontStyle: FontStyle.italic),),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                    tileColor: Colors.pinkAccent.withOpacity(0.3),
                    trailing: Icon(Icons.delete, color: Colors.red, size: screenWidth*0.07,),
                  );
                }
              )
              : Column(
                children: [
                  SizedBox(height: screenHeight*0.08,),
                  Icon(Icons.filter_none, size: screenWidth*0.35, color: Colors.black54),
                  SizedBox(height: screenHeight*0.03,),
                  const Text("No Applications have been added!")
                ],
              )
        ),
      ),
    );
  }

  Widget _body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count.toString()),
          OutlinedButton(
              onPressed: () {service.startService();},
              child: const Text("Start")),
          OutlinedButton(
              onPressed: () {service.invoke('stop');},
              child: const Text("Stop")),
          OutlinedButton(
              onPressed: () {service.invoke('setAppNames', {'appNames' : _selectedPackages.toList()});},
              child: const Text("Add chrome")),
          OutlinedButton(
              onPressed: () {service.invoke('timer');},
              child: const Text("Call Timer")),
          //_getInstalledAppsListView(context)
        ],
      ),
    );
  }
}