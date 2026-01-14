import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveCallScreen extends StatelessWidget {
  final String courseId;
  final String batchId;
  final String slotId;
  final String liveLink;
  final String liveClassId;

  const LiveCallScreen({
    super.key,
    required this.liveClassId,
    required this.batchId,
    required this.courseId,
    required this.slotId,
    required this.liveLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Call'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
