import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mahder_mobile/core/utils/screen_size.dart';
import 'package:mahder_mobile/core/widgets/button.dart';
import 'package:mahder_mobile/core/widgets/input_box.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final ProfileController _profileController = Get.find();
  final formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getScreenHeight(context) * 0.02),
              if (Get.arguments is Map && Get.arguments['required'] == true)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                      'Enter the temporary password from your email, then choose your own password to continue.'),
                ),

              // Current Password Field
              InputBoxWidget(
                inputType: InputType.password,
                label: 'profile.current_password'.tr,
                placeHolder: 'profile.current_password_placeholder'.tr,
                controller: _currentPasswordController,
                shouldValidate: false,
                focus: _currentPasswordFocusNode,
                focusNext: _newPasswordFocusNode,
                showLabel: true,
                isOptional: false,
              ),
              SizedBox(height: getScreenHeight(context) * 0.015),

              // New Password Field
              InputBoxWidget(
                inputType: InputType.password,
                label: 'profile.new_password'.tr,
                placeHolder: 'profile.new_password_placeholder'.tr,
                controller: _newPasswordController,
                focus: _newPasswordFocusNode,
                focusNext: _confirmPasswordFocusNode,
                showLabel: true,
                isOptional: false,
              ),
              SizedBox(height: getScreenHeight(context) * 0.015),

              // Confirm Password Field
              InputBoxWidget(
                inputType: InputType.confirmPass,
                label: 'profile.confirm_password'.tr,
                placeHolder: 'profile.confirm_password_placeholder'.tr,
                controller: _confirmPasswordController,
                focus: _confirmPasswordFocusNode,
                pass: _newPasswordController,
                showLabel: true,
                isOptional: false,
              ),
              SizedBox(height: getScreenHeight(context) * 0.03),

              // Save Button
              Obx(() => ButtonWidget(
                    text: 'profile.change_password_button'.tr,
                    loadingText: 'profile.changing_password'.tr,
                    isLoading: _profileController.isChangingPassword.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _profileController.changePassword(
                          _currentPasswordController.text.trim(),
                          _newPasswordController.text.trim(),
                        );
                      }
                    },
                    fontSize: 16,
                  )),
              SizedBox(height: getScreenHeight(context) * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
