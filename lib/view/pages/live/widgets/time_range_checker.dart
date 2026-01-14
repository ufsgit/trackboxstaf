import 'dart:async';

class TimeRangeChecker {
  Timer? _timer;
  final _canGoLiveController = StreamController<bool>.broadcast();
  Stream<bool> get canGoLiveStream => _canGoLiveController.stream;

  DateTime _parseTimeString(String timeString) {
    try {
      // Handle HH:mm format
      final now = DateTime.now();
      final timeParts = timeString.split(':');

      if (timeParts.length == 2) {
        final hours = int.parse(timeParts[0]);
        final minutes = int.parse(timeParts[1]);

        return DateTime(
          now.year,
          now.month,
          now.day,
          hours,
          minutes,
        );
      }

      print('[TimeParser] Invalid time format: $timeString');
      return now;
    } catch (e) {
      print('[TimeParser Error] ${e.toString()}');
      return DateTime.now();
    }
  }

  bool isCurrentTimeInRange(String startTimeStr, String endTimeStr) {
    try {
      final DateTime now = DateTime.now();
      final DateTime startTime = _parseTimeString(startTimeStr);
      final DateTime endTime = _parseTimeString(endTimeStr);

      // If end time is before start time, it means the class spans midnight
      if (endTime.isBefore(startTime)) {
        endTime.add(const Duration(days: 1));
      }

      bool isInRange = now.isAfter(startTime) && now.isBefore(endTime);

      print('[TimeCheck] Current Time: ${_formatTimeForLog(now)}');
      print('[TimeCheck] Start Time: ${_formatTimeForLog(startTime)}');
      print('[TimeCheck] End Time: ${_formatTimeForLog(endTime)}');
      print('[TimeCheck] Is In Range: $isInRange');

      return isInRange;
    } catch (e) {
      print('[TimeCheck Error] ${e.toString()}');
      return false;
    }
  }

  String _formatTimeForLog(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  void startTimeRangeMonitoring(String startTime, String endTime) {
    _timer?.cancel();

    void checkAndUpdateStatus() {
      final canGoLive = isCurrentTimeInRange(startTime, endTime);
      if (!_canGoLiveController.isClosed) {
        _canGoLiveController.add(canGoLive);
      }

      // Check if we're past end time
      if (DateTime.now().isAfter(_parseTimeString(endTime))) {
        _timer?.cancel();
        _timer = null;
      }
    }

    checkAndUpdateStatus();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      checkAndUpdateStatus();
    });
  }

  void dispose() {
    _timer?.cancel();
    _canGoLiveController.close();
  }
}
