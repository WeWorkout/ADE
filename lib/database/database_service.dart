
import 'package:ade/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path;

class DatabaseService {

  bool _isInitialized = false;
  static final Finalizer<Box<ApplicationData>> _finalizer =
  Finalizer((box) => box.close());


  final String _boxName = "application-data";
  late final Box<ApplicationData> _box;

  static Future<DatabaseService> instance() async {
    DatabaseService dbService = DatabaseService();
    await dbService.initializeHive();
    await dbService.registerAdapters();
    await dbService.openBox();
    return dbService;
  }

  initializeHive() async {
    await Hive.initFlutter();
  }

  registerAdapters() {
    if(!_isInitialized) {
      Hive.registerAdapter(ApplicationDataAdapter());
      _isInitialized = true;
    }
  }

  openBox() async {
    if(Hive.isBoxOpen(_boxName)) {
      await _box.close();
      _box = Hive.box(_boxName);
    } else {
      _box = await Hive.openBox(_boxName);
    }
  }

  close() async {
    if(Hive.isBoxOpen(_boxName)) {
      _box.close();
      _finalizer.detach(this);
    } else {
      debugPrint("Box not open!");
    }
  }

  ApplicationData? getAppData(String appId) {
    return _box.get(appId);
  }

  List<ApplicationData> getAllAppData() {
    return _box.values.toList();
  }

  addAppData(ApplicationData appData) async {
    debugPrint("Adding ${appData.appId}");
    await _box.put(appData.appId, appData);
  }

  addAllAppData(List<ApplicationData> appDatas) async {
    for(ApplicationData appData in appDatas) {
      debugPrint("Adding ${appData.appId}");
      await _box.put(appData.appId, appData);
    }
  }

  Map<dynamic, ApplicationData> getBoxAsMap() {
    return _box.toMap();
  }

  removeAppData(String appId) async {
    debugPrint("Removing $appId");
    await _box.delete(appId);
  }
}