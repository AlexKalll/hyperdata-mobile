import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/core/widgets/image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/screen_size.dart';

class TakeTestWidget extends StatelessWidget {
  final VoidCallback onStart;
  const TakeTestWidget({required this.onStart , super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScreenHeight(context) * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getScreenHeight(context) * 0.015),
              Text('home.tasks.test.title'.tr, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w900),),
              SizedBox(height: getScreenHeight(context) * 0.005),
              Text('home.tasks.test.description'.tr, style: const TextStyle(fontSize: 13,color: Colors.black54),),
              SizedBox(height: getScreenHeight(context) * 0.02),
            ]
          ),
          Center(
            child: assetSvgImageWidget('take_test.svg',
              width: getScreenWidth(context) * 0.5,
              height: getScreenHeight(context) * 0.4,
            ),
          ),
          Column(
            children: [
              ButtonWidget(text: 'home.tasks.test.take_test'.tr, onPressed: onStart , fontSize: 15,),
              const SizedBox(height: 10,),
              ButtonWidget(
                text: 'common.cancel'.tr,
                onPressed: () {
                  Get.back();
                },
                fontSize: 15,
                color: AppColors.darkGray,
                fill: false,
              ),
              const SizedBox(height: 20,),
            ]
          )
        ],
      ),
    );
  }
}
