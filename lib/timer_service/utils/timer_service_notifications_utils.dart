String getNotificationTitle(String appName, DateTime finishTime){
  return 'Timer for $appName till ${finishTime.toString()}';
}

String getNotificationDescription(DateTime currentTime, DateTime finishTime){
  return 'Time Left: ${finishTime.difference(currentTime).inSeconds} seconds';
}
