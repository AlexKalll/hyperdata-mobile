import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/core/widgets/image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/screen_size.dart';

class TestRejectedWidget extends StatelessWidget {
  final VoidCallback onStart;
  const TestRejectedWidget({required this.onStart , super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScreenHeight(context) * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                assetSvgImageWidget('test_rejected.svg', width: getScreenWidth(context) * 0.3, height: getScreenHeight(context) * 0.25,),
                const SizedBox(height: 10),
                Text('home.tasks.test.rejected_title'.tr, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w900,color: AppColors.red),),
                const SizedBox(height: 10),
                Text('home.tasks.test.rejected_message'.tr, style: const TextStyle(fontSize: 13.4,color: Colors.black54),),
              ],
            ),
          ),
          Column(
              children: [
                ButtonWidget(text: 'home.tasks.test.take_test_again'.tr, onPressed: onStart , fontSize: 15,),
                const SizedBox(height: 10,),
                ButtonWidget(
                  text: 'home.tasks.test.do_other_tasks'.tr,
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
