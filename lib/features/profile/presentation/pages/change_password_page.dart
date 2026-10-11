import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mahder_mobile/core/theme/app_colors.dart';
import '../widgets/change_password_widget.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requiredChange =
        Get.arguments is Map && Get.arguments['required'] == true;
    return PopScope(
      canPop: !requiredChange,
      child: Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              // Content
              const Expanded(
                child: ChangePasswordWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (Get.arguments is Map && Get.arguments['required'] == true) {
                Get.find<ProfileController>().logout();
              } else {
                Get.back();
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.darkGray,
              size: 24,
            ),
          ),
          Text(
            'profile.change_password'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
