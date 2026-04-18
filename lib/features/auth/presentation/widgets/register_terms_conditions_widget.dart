import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/screen_size.dart';
import '../../../../core/widgets/button.dart';
import '../controllers/auth_controller.dart';

class RegisterTermsConditionsWidget extends StatelessWidget {
  RegisterTermsConditionsWidget({super.key});

  final AuthController _authController = Get.find();

  List<Map<String, String>> get termsAndConditions => [
    {
      "title": "auth.profile.terms_1_title".tr,
      "content": "auth.profile.terms_1_content".tr
    },
    {
      "title": "auth.profile.terms_2_title".tr,
      "content": "auth.profile.terms_2_content".tr
    },
    {
      "title": "auth.profile.terms_3_title".tr,
      "content": "auth.profile.terms_3_content".tr
    },
    {
      "title": "auth.profile.terms_4_title".tr,
      "content": "auth.profile.terms_4_content".tr
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getScreenHeight(context)*0.025,),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _authController.currentPage.value = 0;
                      },
                      child: const Icon(Icons.arrow_back, size: 26),
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: getScreenHeight(context) * 0.025),
                Text("auth.profile.terms_title".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                const SizedBox(height: 5),
                Text("auth.profile.terms_subtitle".tr,style: const TextStyle(fontSize: 13,color: Colors.black54),),
                SizedBox(height: getScreenHeight(context) * 0.02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Column(
                    children: [
                      ...termsAndConditions.map((term) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(term["title"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(term["content"]!, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                          ],
                        ),
                      ))],
                  )
                )

              ],
            ),
          ),
        ),
        ButtonWidget(
          text: "Continue".tr,
          loadingText: "Continuing".tr,
          fontSize: 16,
          onPressed: () {
           _authController.currentPage.value = 2;
          },
        ),
        SizedBox(height: getScreenHeight(context)*0.025),
      ],
    );
  }
}
