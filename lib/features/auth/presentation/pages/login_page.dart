import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';
import 'package:leyu_mobile/features/auth/presentation/widgets/logo_widget.dart';
import 'package:leyu_mobile/routes/app_routes.dart';
import '../../../../../core/utils/screen_size.dart';
import '../../../../../core/widgets/image.dart';
import '../../../../../core/widgets/input_box.dart';
import '../../../../core/widgets/language_changer.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.find();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
      canPop: !_authController.isLoggingIn.value,
      child: Scaffold(
        backgroundColor: AppColors.appBgColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LoadingOverlayWidget(
            isLoading: [_authController.isLoggingIn],
            reason: _authController.loginLoadingReason,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: getScreenHeight(context)*0.025,),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back, size: 26),
                            ),
                            const Spacer(),
                            const LanguageChanger()
                          ],
                        ),
                        SizedBox(height: getScreenHeight(context) * 0.02),
                        assetImageWidget("logo.png",scale: 1.5,),
                        SizedBox(height: getScreenHeight(context)*0.02,),
                        Text("auth.login.welcome".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                        SizedBox(height: getScreenHeight(context) * 0.01),
                        Text("auth.login.subtitle".tr,style: const TextStyle(fontSize: 13,color: Colors.black54),),
                        SizedBox(height: getScreenHeight(context) * 0.02),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              PhoneInputBoxWidget(
                                controller: _phoneNumberController,
                                focus: _phoneNumberFocusNode,
                                focusNext: _passwordFocusNode,
                                placeHolder: "auth.login.phone_placeholder".tr,
                                showLabel: true,
                              ),
                              const SizedBox(height: 8),
                              InputBoxWidget(
                                inputType: InputType.password,
                                label: "auth.login.password".tr,
                                placeHolder: "auth.login.password_placeholder".tr,
                                controller: _passwordController,
                                focus: _passwordFocusNode,
                                showLabel: true,
                                shouldValidate: false,
                              ),
                              SizedBox(height: getScreenHeight(context)*0.005),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.forgotPassword);
                                    },
                                    child: Text(
                                      "auth.login.forgot_password".tr,
                                      style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline,color: AppColors.primary),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: getScreenHeight(context)*0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("auth.login.no_account".tr),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.register);
                                    },
                                    child: Text(
                                      "auth.login.sign_up".tr,
                                      style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline,color: AppColors.primary),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getScreenHeight(context)*0.03),
                        Obx(() => ButtonWidget(
                          text: "auth.login.button".tr,
                          loadingText: "auth.login.loading".tr,
                          fontSize: 16,
                          isLoading: _authController.isLoggingIn.value,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              _authController.login(
                                  _phoneNumberController.text.trim(),
                                  _passwordController.text.trim()
                              );
                            }
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
