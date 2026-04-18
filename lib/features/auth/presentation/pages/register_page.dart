import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/core/widgets/language_changer.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';
import 'package:leyu_mobile/routes/app_routes.dart';
import '../../../../../core/utils/message.dart';
import '../../../../../core/utils/screen_size.dart';
import '../../../../../core/widgets/image.dart';
import '../../../../../core/widgets/input_box.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = Get.find();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();


  final FocusNode _phoneNumberFocusNode = FocusNode();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
      canPop: !_authController.isRegistering.value,
      child: Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: SafeArea(
          child: LoadingOverlayWidget(
            isLoading: [_authController.isRegistering],
            reason: _authController.registerLoadingReason,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
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
                                  Get.back();
                                },
                                child: const Icon(Icons.arrow_back, size: 26),
                              ),
                              const Spacer(),
                              const LanguageChanger()
                            ],
                          ),
                          SizedBox(height: getScreenHeight(context) * 0.025),
                          Text("auth.register.welcome".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                          SizedBox(height: getScreenHeight(context) * 0.01),
                          Text("auth.register.subtitle".tr,style: const TextStyle(fontSize: 13,color: Colors.black54),),
                          SizedBox(height: getScreenHeight(context) * 0.02),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                PhoneInputBoxWidget(
                                  controller: _phoneNumberController,
                                  focus: _phoneNumberFocusNode,
                                  placeHolder: "auth.register.phone_placeholder".tr,
                                  showLabel: false,
                                ),
                                SizedBox(height: getScreenHeight(context)*0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("auth.register.have_account".tr,overflow: TextOverflow.clip,),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.login);
                                      },
                                      child: Text(
                                        "auth.register.login".tr,
                                        style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline,color: AppColors.primary),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() => ButtonWidget(
                    text: "auth.register.button".tr,
                    loadingText: "auth.register.loading".tr,
                    fontSize: 16,
                    isLoading: _authController.isRegistering.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _authController.register(
                          _phoneNumberController.text.trim(),
                        );
                      }
                    },
                  )),
                  SizedBox(height: getScreenHeight(context)*0.025),
                ],
              ),
            ),
          )
        ),
      ),
    ));
  }
}
