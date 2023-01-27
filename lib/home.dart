
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
  Set<String> _selectedPackages = {'com.android.chrome'};
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
    return Scaffold(
      body: _body()
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
              onPressed: () {FlutterBackgroundService().startService();},
              child: const Text("Start")),
          OutlinedButton(
              onPressed: () {FlutterBackgroundService().invoke('stop');},
              child: const Text("Stop")),
          OutlinedButton(
              onPressed: () {FlutterBackgroundService().invoke('setAppNames', {'appNames' : _selectedPackages.toList()});},
              child: const Text("Add chrome")),
          OutlinedButton(
              onPressed: () {FlutterBackgroundService().invoke('timer');},
              child: const Text("Call Timer")),
          //_getInstalledAppsListView(context)
        ],
      ),
    );
  }

  Widget _getInstalledAppsListView(BuildContext context) {
    //List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
    return FutureBuilder<List<AppInfo>>(
        future: InstalledApps.getInstalledApps(true, true),
        builder: (context, AsyncSnapshot<List<AppInfo>> appsList) {
          if(appsList.data == null) {
            return const CircularProgressIndicator();
          } else if(appsList.data!.isEmpty) {
            return const Text("No DATAA!");
          }
          List<AppInfo> apps = appsList.data!;
          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              return ListTile(
                selectedColor: Colors.green,
                selected: _selectedPackages.contains(apps[index].packageName),
                onTap: () => {
                  print(apps[index].packageName)
                },
                leading: Image.memory(apps[index].icon!),
                title: Text(apps[index].name!),
              );
            });
        }
    );
  }



  _showDialog() async {
    FlutterBackgroundService().on("showDialog").listen((event) {
      print("received");
      if(_selectedPackages.contains("com.android.chrome")) {
        _selectedPackages.remove("com.android.chrome");
      } else {
        _selectedPackages.add("com.android.chrome");
      }
      setState(() {});
    });
  }
}