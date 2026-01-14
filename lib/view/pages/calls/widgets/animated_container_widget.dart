import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/core/utils/image_constants.dart';
import 'package:flutter/material.dart';

class AnimatedPhoneCallContainer extends StatefulWidget {
  const AnimatedPhoneCallContainer({super.key});

  @override
  AnimatedPhoneCallContainerState createState() =>
      AnimatedPhoneCallContainerState();
}

class AnimatedPhoneCallContainerState extends State<AnimatedPhoneCallContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.colorgrey800,
      child: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 170 + (_animation.value * 20),
              height: 170 + (_animation.value * 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      Colors.white.withOpacity(0.5 - (_animation.value * 0.3)),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white
                          .withOpacity(0.3 - (_animation.value * 0.1)),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorResources.colorgrey700,
                            blurRadius: 40,
                          )
                        ],
                        color: ColorResources.colorBlue600,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            ImageConstant.breffniLogo,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
