String getNotificationTitle(DateTime finishTime) {
  if(finishTime.minute < 10 ) {
    return 'Timer set till ${finishTime.hour % 12}:0${finishTime.minute} ';
  }
  return 'Timer set till ${finishTime.hour % 12}:${finishTime.minute} ';
}

String getNotificationDescription(DateTime currentTime, DateTime finishTime){
  int minutesLeft = finishTime.difference(currentTime).inMinutes;
  int secondsLeft = finishTime.difference(currentTime).inSeconds - minutesLeft * 60;
  if(minutesLeft == 0) {
    return 'Time Left: ${secondsLeft}s';
  } else {
    if(secondsLeft<10) {
      return 'Time Left: $minutesLeft:0${secondsLeft}s';
    }
    return 'Time Left: $minutesLeft:${secondsLeft}s';
  }
}
