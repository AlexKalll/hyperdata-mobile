import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/core/widgets/image.dart';

import '../../../../core/utils/screen_size.dart';

class TestUnderReviewWidget extends StatelessWidget {
  const TestUnderReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScreenHeight(context) * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                assetSvgImageWidget('test_under_review.svg', width: getScreenWidth(context) * 0.3, height: getScreenHeight(context) * 0.25,),
                const SizedBox(height: 10),
                Text('home.tasks.test.under_review_title'.tr, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w900),),
                const SizedBox(height: 10),
                Text('home.tasks.test.under_review_message'.tr, style: const TextStyle(fontSize: 13,color: Colors.black54),),
              ],
            ),
          ),
          Column(
            children: [
              ButtonWidget(text: 'home.tasks.test.back_to_tasks'.tr, onPressed: () {
                Get.back();
              }, fontSize: 15,),
              const SizedBox(height: 20,),
            ]
          )
        ],
      ),
    );
  }
}
