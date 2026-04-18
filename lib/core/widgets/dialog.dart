import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/button.dart';

import '../utils/screen_size.dart';

void showConfirmationDialog({required String title, required String description, required VoidCallback onSubmit, Color theme = AppColors.primary}) {
  showDialog(
      context: Get.context!,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 2,),
                    Text(title,style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: theme)),
                    InkWell(
                        onTap:(){
                          Get.back();
                        },
                        child: const Icon(Icons.close,size: 22,color: Colors.black,))
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              const Divider(thickness: 1,color: Colors.black,)
            ],
          ),
          titlePadding: const EdgeInsets.only(top: 12,bottom: 10),
          contentPadding: const EdgeInsets.symmetric(horizontal:15 ),
          content: SizedBox(
              width: getScreenWidth(context),
              child: SingleChildScrollView(
                  child: Text(description,textAlign: TextAlign.center))
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonWidget(text: 'common.confirm'.tr, onPressed: (){
                    onSubmit();
                    Get.back();
                  },fontSize: 15,height: 40,color: theme,),
                  const SizedBox(height: 10,),
                  ButtonWidget(text: 'common.cancel'.tr, fill: false,fontSize: 15, height: 40,color: theme, onPressed: (){
                    Get.back();},),
                ],
              ),
            )
          ],
          actionsPadding: const EdgeInsets.only(bottom: 20,top: 20,left: 20,right: 20),
        );
      });
}