String miliSecondsToMinutesFormat(int? miliseconds) {
  if (miliseconds == null) {
    return 'Unknown';
  }
  // * Calculate the Minute

  double minutes = (miliseconds / 60000);

  int indexOfDot = minutes.toString().lastIndexOf('.');

  String finalMinutes = minutes.toString().substring(0, indexOfDot);

  // * Calculate the Seconds

  double milisecondsRemaining = double.parse(
      '0.${minutes.toString().substring(indexOfDot + 1, minutes.toString().length)}');

  String finalSeconds = (milisecondsRemaining * 60)
      .toString()
      .substring(0, (milisecondsRemaining * 60).toString().indexOf('.'));

  return '$finalMinutes:${finalSeconds.length < 2 ? '0' : ''}$finalSeconds';
}
