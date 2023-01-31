String getNotificationTitle(String appName, DateTime finishTime){
  return 'Timer for $appName till ${finishTime.hour % 12}:${finishTime.minute} ';
}

String getNotificationDescription(DateTime currentTime, DateTime finishTime){
  int minutesLeft = finishTime.difference(currentTime).inMinutes;
  int secondsLeft = finishTime.difference(currentTime).inSeconds - minutesLeft * 60;
  if(minutesLeft == 0) {
    return 'Time Left: ${secondsLeft}s';
  } else {
    return 'Time Left: $minutesLeft:${secondsLeft}s';
  }
}
