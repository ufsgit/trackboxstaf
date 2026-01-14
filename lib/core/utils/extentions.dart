extension DurationFormatter on int {
  String toMinSecond() {
    final minutes = this ~/ 60;
    final seconds = this % 60;

    // Pad minutes and seconds with leading zeros if necessary
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    return "$formattedMinutes:$formattedSeconds";
  }


}

extension StringExtensions on String? {

  // String capitalize() {
  //   if (this.isEmpty) return this;
  //   return this[0].toUpperCase() + this.substring(1);
  // }
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }
}