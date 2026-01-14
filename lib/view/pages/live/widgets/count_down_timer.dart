import 'dart:async';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onCountdownComplete;

  const CountdownTimer({
    super.key,
    required this.duration,
    required this.onCountdownComplete,
  });

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late int _remainingTime;
  Timer? _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  void _startCountdown() {
    _remainingTime = widget.duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _controller.stop();
          widget.onCountdownComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: 200.w,
      child: CircleAvatar(
        radius: 50.r,
        backgroundColor: ColorResources.colorBlue500,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$_remainingTime',
              style: GoogleFonts.plusJakartaSans(
                color: ColorResources.colorwhite,
                fontSize: 80.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(_controller.value),
                  size: Size(150.w, 150.h),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      double currentProgress = (progress + i * 0.3) % 1.0;
      double currentRadius = radius * (1 + currentProgress * 0.3);
      canvas.drawCircle(center, currentRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
