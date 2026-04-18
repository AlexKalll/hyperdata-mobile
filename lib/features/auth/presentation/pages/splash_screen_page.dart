
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';

import '../../../../../core/widgets/image.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with SingleTickerProviderStateMixin {

  final SplashScreenController _splashScreenController = Get.find<SplashScreenController>();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  void repeatOnce() async {
    await _controller.forward();
    _splashScreenController.checkAuthStatus();
  }

  @override
  void initState() {
    repeatOnce();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
      return  Scaffold(
        backgroundColor: AppColors.appBgColor,
          body: Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Center(
                      child: assetImageWidget("logo.png")
                  ),
                );
              },
            ),
          )
      );
  }
}
