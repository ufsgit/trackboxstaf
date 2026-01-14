import 'package:flutter/material.dart';

class CustomLivePage extends StatelessWidget {
  final String? roomId;
  final String? studentId;
  final String? teacherName;
  final String? studentName;
  final String? profileURL;
  final bool outgoingCall;

  const CustomLivePage({
    super.key,
    this.teacherName,
    this.studentName,
    this.roomId,
    this.profileURL,
    this.studentId,
    this.outgoingCall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Call'),
      ),
      body: const Center(
        child: Text(
          'Live Call feature has been removed.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
