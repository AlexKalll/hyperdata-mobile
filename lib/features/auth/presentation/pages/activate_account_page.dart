import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/screen_size.dart';
import '../../../../../core/widgets/button.dart';
import '../controllers/auth_controller.dart';

class ActivateAccountPage extends StatefulWidget {

  const ActivateAccountPage({super.key});

  @override
  State<ActivateAccountPage> createState() => _ActivateAccountPageState();
}

class _ActivateAccountPageState extends State<ActivateAccountPage> {
  final AuthController _authController = Get.find();
  String? verificationCode;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=> PopScope(
      canPop: !_authController.isRegistering.value || !_authController.isActivatingAccount.value,
      child: LoadingOverlayWidget(
        isLoading: [
          _authController.isRegistering,
          _authController.isActivatingAccount
        ],
        reason: _authController.registerLoadingReason,
        child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.appBgColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: getScreenHeight(context)*0.03,),
                            InkWell(
                              onTap: (){
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back,size: 26,),
                            ),
                            SizedBox(height: getScreenHeight(context)*0.075,),
                            Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("auth.otp.title".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900,color: Colors.black),),
                            const SizedBox(height: 8,),
                            Text("auth.otp.subtitle".tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black54),textAlign: TextAlign.center,),
                            const SizedBox(height: 4,),
                            Text("+251-${_authController.registeredPhone.value}",style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                            SizedBox(height: getScreenHeight(context)*0.04,),
                            OtpTextField(
                              numberOfFields: 6,
                              filled: true,
                              fillColor: AppColors.inputBgColor,
                              enabledBorderColor: AppColors.inputBgColor,
                              focusedBorderColor: AppColors.primary,
                              cursorColor: AppColors.primary,
                              textStyle: const TextStyle(color: AppColors.primary,fontSize: 22,fontWeight: FontWeight.bold),
                              contentPadding: const EdgeInsets.only(bottom: 15,top: 15),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              showFieldAsBox: true,
                              borderRadius: BorderRadius.circular(10),
                              fieldWidth: 50,
                              onSubmit: (String code){
                                setState(() {
                                  verificationCode = code;
                                });
                                _authController.activateAccount(code);
                              },
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(vertical: getScreenHeight(context)*0.015),
                              child: Obx(() {
                                if (!_authController.canResend.value) {
                                  final mins = (_authController.countdown.value ~/ 60).toString().padLeft(2, '0');
                                  final secs = (_authController.countdown.value % 60).toString().padLeft(2, '0');
                                  return Text("auth.otp.resend_timer".trParams({'time': '$mins:$secs'}),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey));
                                } else {
                                  return InkWell(
                                      onTap: () {
                                        if (!_authController.isRegistering.value) {
                                          _authController.register(_authController.registeredPhone.value,isActivating: true);
                                        }
                                      },
                                      child: Text("auth.otp.resend".tr,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.primary,decoration: TextDecoration.underline)));
                                }
                              }),

                            ),
                            SizedBox(height: getScreenHeight(context)*0.025,),
                          ],
                        ),
                      ),
                          ],
                        ),
                      ),
                    ),
                    Obx(()=> ButtonWidget(
                      text: "auth.otp.button".tr,
                      loadingText: "auth.otp.loading".tr,
                      isLoading: _authController.isActivatingAccount.value,
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          if (verificationCode != null && verificationCode!.length == 6) {
                            _authController.activateAccount(verificationCode!);
                          } else {
                            showErrorMessage("auth.otp.error_invalid".tr);
                          }
                        }
                      },
                    )),
                    SizedBox(height: getScreenHeight(context)*0.025,),
                  ],
                ),
              )
              ),
            ),
      ),
      ),
    );
  }
}
