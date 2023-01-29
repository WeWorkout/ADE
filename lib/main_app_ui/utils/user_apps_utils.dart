import 'package:ade/main_app_ui/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

showInstalledAppsListViewDialog(BuildContext context, Set<ApplicationData> selectedPackages) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;

  return showDialog(
      barrierDismissible: true,
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context){
        return Dialog(
          child: SizedBox(
            height: screenHeight*0.75,
            width: screenHeight*0.8,
            child: FutureBuilder<List<AppInfo>>(
                future: InstalledApps.getInstalledApps(true, true),
                builder: (context, AsyncSnapshot<List<AppInfo>> appsList) {
                  if(appsList.data == null) {
                    return Align(
                      child: SizedBox(
                          height: screenHeight*0.07,
                          width: screenWidth*0.15,
                          child: const CircularProgressIndicator()
                      ),
                    );
                  }
                  else if(appsList.data!.isEmpty) {
                    return const Text("No App data found!");
                  }
                  List<AppInfo> apps = appsList.data!;
                  return ListView.builder(
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          selectedColor: Colors.green,
                          selected: selectedPackages.contains(apps[index].packageName),
                          onTap: () => {
                            print(apps[index].packageName)
                          },
                          leading: Image.memory(apps[index].icon!),
                          title: Text(apps[index].name!),
                        );
                      });
                }
            ),
          ),
        );
      }
  );
}