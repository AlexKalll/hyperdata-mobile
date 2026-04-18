import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';


Future<void> showSuccessMessage(String message) async {
  Get.snackbar(
    'common.success'.tr,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.green,
    colorText: Colors.white,
    borderRadius: 8,
    duration: const Duration(seconds: 2),
  );
}

void showErrorMessage(String message) {
  Get.snackbar(
    'common.error'.tr,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.red,
    colorText: Colors.white,
    borderRadius: 8,
    duration: const Duration(seconds: 3),
  );
}


void showInternetConnectionError() {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
    titleSize: 20,
    messageSize: 17,
    messageColor: Colors.white,
    backgroundColor: Colors.red,
    borderRadius: BorderRadius.circular(8),
    message: 'error.no_internet'.tr,
    duration: const Duration(seconds: 1),
  ).show(Get.context!);
}