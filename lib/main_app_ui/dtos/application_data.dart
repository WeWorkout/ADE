import 'dart:typed_data';

class ApplicationData{
  String appName;
  String appId;
  Uint8List? icon;

  ApplicationData.name(this.appName, this.appId, this.icon);
}