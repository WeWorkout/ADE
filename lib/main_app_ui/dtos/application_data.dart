import 'dart:typed_data';

class ApplicationData{
  String appName;
  String appId;
  Uint8List? icon;

  ApplicationData(this.appName, this.appId, this.icon);
}