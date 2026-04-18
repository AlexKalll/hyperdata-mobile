import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/utils/message.dart';

import '../../../../core/utils/screen_size.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/date_picker.dart';
import '../../../../core/widgets/dropdown.dart';
import '../../../../core/widgets/input_box.dart';
import '../controllers/auth_controller.dart';

class RegisterPasswordWidget extends StatefulWidget {
  const RegisterPasswordWidget({super.key});

  @override
  State<RegisterPasswordWidget> createState() => _RegisterPasswordWidgetState();
}

class _RegisterPasswordWidgetState extends State<RegisterPasswordWidget> {
  final AuthController _authController = Get.find();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    _passwordController.value = TextEditingValue(text: _authController.password.value ?? '');
    _confirmPasswordController.value = TextEditingValue(text: _authController.password.value ?? '');
    super.initState();
  }

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
                        if (_authController.isRegistering.value) return;
                        _authController.currentPage.value = 2;
                      },
                      child: const Icon(Icons.arrow_back, size: 26),
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: getScreenHeight(context) * 0.025),
                Text("auth.profile.password_title".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                const SizedBox(height: 5),
                Text("auth.profile.password_subtitle".tr,style: const TextStyle(fontSize: 13,color: Colors.black54),),
                SizedBox(height: getScreenHeight(context) * 0.02),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputBoxWidget(
                        inputType: InputType.password,
                        label: "auth.profile.password".tr,
                        placeHolder: "auth.profile.password_placeholder".tr,
                        controller: _passwordController,
                        focus: _passwordFocusNode,
                        focusNext: _confirmPasswordFocusNode,
                        showLabel: true,
                      ),
                      SizedBox(height: getScreenHeight(context)*0.01),
                      InputBoxWidget(
                        inputType: InputType.confirmPass,
                        label: "auth.profile.confirm_password".tr,
                        placeHolder: "auth.profile.confirm_password_placeholder".tr,
                        controller: _confirmPasswordController,
                        focus: _confirmPasswordFocusNode,
                        pass: _passwordController,
                        showLabel: true,
                      ),
                      SizedBox(height: getScreenHeight(context)*0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() => ButtonWidget(
          text: "auth.profile.create_button".tr,
          loadingText: "auth.profile.create_loading".tr,
          fontSize: 16,
          isLoading: _authController.isRegistering.value,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _authController.password.value = _passwordController.text.trim();
              _authController.registerProfile();
            }
          },
        )),
        SizedBox(height: getScreenHeight(context)*0.025),
      ],
    );
  }
}
