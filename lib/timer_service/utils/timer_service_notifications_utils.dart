const String NOTIFICATION_PREFIX_TEXT = "Awareness Nudge till:";

String getNotificationTitle(DateTime finishTime) {
  String prefixText = "Awareness Nudge till:";
  String timeText = finishTime.minute < 10 ? '${finishTime.hour % 12}:0${finishTime.minute}' : '${finishTime.hour % 12}:${finishTime.minute}';
  return "$prefixText $timeText";
}

String getNotificationDescription(DateTime currentTime, DateTime finishTime){
  int minutesLeft = finishTime.difference(currentTime).inMinutes;
  int secondsLeft = finishTime.difference(currentTime).inSeconds - minutesLeft * 60;
  if(minutesLeft == 0) {
    return '$NOTIFICATION_PREFIX_TEXT ${secondsLeft}s';
  } else {
    if(secondsLeft<10) {
      return '$NOTIFICATION_PREFIX_TEXT $minutesLeft:0${secondsLeft}s';
    }
    return '$NOTIFICATION_PREFIX_TEXT $minutesLeft:${secondsLeft}s';
  }
}
