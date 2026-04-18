import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/core/widgets/image.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';
import 'package:leyu_mobile/features/home/presentation/controllers/home_controller.dart';

class WalletWidget extends StatelessWidget {
  WalletWidget({super.key});

  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF095FAF),
            Color(0xFF0B70A8),
            Color(0xFF086CA8),
            Color(0xEB0779A2),
            Color(0xD2089B99),
            Color(0x8202C27D),
          ],
          stops: [
            0.0,
            0.0,
            0.1634,
            0.6405,
            1.3382,
            2.9221,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.wallet.balance'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              assetSvgImageWidget("wallet.svg", width: 30, height: 30)
            ],
          ),
          const SizedBox(height: 5),
          Obx(()=>
             _homeController.isBalanceLoading.value?
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const LoadingWidget(isTransparent: true, size: 25,height: 30,width: 30,color: Colors.white,),
                  ):
              Text(
            _formatBalance(_homeController.userBalance.value),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),),
          const SizedBox(height: 15),
          // add broken line
          BrokenLineWidget(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  print('Withdrawing:');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // blur strength
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15), // translucent
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          assetSvgImageWidget("withdraw.svg", width: 16, height: 16),
                          const SizedBox(width: 5),
                          Text(
                            'home.wallet.withdraw'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () {
                  print('History:');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.history, color: Colors.white, size: 17),
                          const SizedBox(width: 5),
                          Text(
                            'home.wallet.history'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatBalance(double balance) {
    return '${'home.wallet.currency'.tr} ${balance.toStringAsFixed(2)}';
  }
}

class BrokenLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 10.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BrokenLineWidget extends StatelessWidget {
  const BrokenLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 10),
      painter: BrokenLinePainter(),
    );
  }
}
