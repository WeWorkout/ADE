
import 'package:ade/database/database_service.dart';
import 'package:ade/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class Home extends StatefulWidget {

  DatabaseService dbService;
  Home(this.dbService);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final service = FlutterBackgroundService();

  @override
  void initState() {
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
                _listOfMonitoringApps(context)
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
          showInstalledAppsListViewDialog(context);
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

  Widget _listOfMonitoringApps(BuildContext context){
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
          child: widget.dbService.getAllAppData().isNotEmpty
              ? ListView.separated(
              separatorBuilder: (BuildContext context, int index){
                return SizedBox(height: screenHeight*0.02,);
              },
              itemCount: widget.dbService.getAllAppData().length,
              itemBuilder: (BuildContext context, int index){
                  ApplicationData appInfo = widget.dbService.getAllAppData().elementAt(index);
                  return ListTile(
                    leading: Icon(Icons.arrow_forward_ios, size: screenWidth*0.05,),
                    title: Text(appInfo.appName, style: const TextStyle(fontStyle: FontStyle.italic),),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                    tileColor: Colors.pinkAccent.withOpacity(0.3),
                    trailing: InkWell(
                        onTap: () async {
                          await widget.dbService.removeAppData(appInfo.appId);
                          setState(() {});
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: screenWidth*0.07,)
                    ),
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

  showInstalledAppsListViewDialog(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    Map<dynamic, ApplicationData> selectedApps = widget.dbService.getBoxAsMap();

    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context, Function(void Function()) setStateDialog){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                elevation: 15,
                child: Container(
                  padding: EdgeInsets.all(screenWidth*0.02),
                  height: screenHeight*0.85,
                  width: screenHeight*0.95,
                  child: FutureBuilder<List<AppInfo>>(
                      future: InstalledApps.getInstalledApps(true, true),
                      builder: (context, AsyncSnapshot<List<AppInfo>> appsList) {
                        if(appsList.data == null) {
                          return _showCircularLoading(context);
                        }
                        else if(appsList.data!.isEmpty) {
                          return const Text("No App data found!");
                        }

                        List<AppInfo> apps = appsList.data!;
                        return _listOfInstalledApps(context, apps, selectedApps, setStateDialog);
                      }
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget _listOfInstalledApps(BuildContext context, List<AppInfo> apps, Map<dynamic, ApplicationData> selectedApps, Function(void Function()) setStateDialog){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenHeight*0.02,),
        Text("Select Applications here", style: TextStyle(fontSize: screenWidth*0.04, decoration: TextDecoration.underline),),
        SizedBox(height: screenHeight*0.04,),
        SizedBox(
          height: screenHeight*0.65,
          width: screenWidth*0.85,
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      AppInfo appInfo = apps[index];
                      return Card(
                        elevation: 12,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(screenWidth*0.01),
                          selectedColor: Colors.black,
                          selectedTileColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black, width: 1),
                          ),
                          selected: selectedApps.containsKey(appInfo.packageName),
                          onTap: selectedApps.containsKey(appInfo.packageName)
                              ? (){
                            // SetState for dialog and the parent
                            setStateDialog((){
                              selectedApps.remove(appInfo.packageName!);
                            });
                          }
                              :() {
                            // SetState for dialog and the parent
                            setStateDialog((){
                              selectedApps.putIfAbsent(appInfo.packageName!, () => ApplicationData(appInfo.name!, appInfo.packageName!, appInfo.icon));
                            });
                          },
                          leading: Image.memory(apps[index].icon!),
                          title: Text(apps[index].name!),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight*0.02,),
        MaterialButton(
          onPressed: () async {
            await widget.dbService.addAllAppData(selectedApps.values.toList());
            setState(() {});
            Navigator.of(context).pop();
          },
          color: Colors.greenAccent,
          child: const Text("Done"),
        )
      ],
    );
  }

  Widget _showCircularLoading(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      child: SizedBox(
          height: screenHeight*0.1,
          width: screenWidth*0.4,
          child: Column(
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: screenHeight*0.02,),
              const Text("Loading Installed Apps")
            ],
          )
      ),
    );
  }

}