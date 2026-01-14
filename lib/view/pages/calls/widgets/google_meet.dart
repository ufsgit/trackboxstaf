import 'dart:async';

import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetCallTracker {
  Timer? _activityCheckTimer;
  DateTime? _callStartTime;
  final Function() onCallEnded;

  MeetCallTracker({required this.onCallEnded});

  Future<void> startMeetCall({required String meetCode}) async {
    final Uri meetUrl = Uri.parse('https://meet.google.com/$meetCode');

    try {
      if (!await canLaunchUrl(meetUrl)) {
        throw 'Could not launch Google Meet call';
      }

      // Store the call start time
      _callStartTime = DateTime.now();

      // Launch the URL
      final bool launched = await launchUrl(
        meetUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Could not launch Google Meet call';
      }

      // Start periodic check for app focus
      _startActivityCheck();
    } catch (e) {
      debugPrint('Error launching Google Meet call: $e');
      rethrow;
    }
  }

  void _startActivityCheck() {
    // Check every 5 seconds if the app regained focus
    _activityCheckTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        // If app regained focus and sufficient time has passed (e.g., 1 minute)
        // we can assume the call has ended
        if (_callStartTime != null &&
            DateTime.now().difference(_callStartTime!) >
                const Duration(minutes: 1)) {
          _handleCallEnded();
        }
      }
    });
  }

  void _handleCallEnded() {
    _activityCheckTimer?.cancel();
    _callStartTime = null;
    onCallEnded();
  }

  void dispose() {
    _activityCheckTimer?.cancel();
  }
}
