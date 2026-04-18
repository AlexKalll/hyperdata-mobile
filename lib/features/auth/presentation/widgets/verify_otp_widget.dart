import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';

import '../../../../../core/utils/screen_size.dart';
import '../../../../../core/widgets/button.dart';
import '../controllers/auth_controller.dart';

class VerifyOtpWidget extends StatefulWidget {

  const VerifyOtpWidget({super.key});

  @override
  State<VerifyOtpWidget> createState() => _VerifyOtpWidgetState();
}

class _VerifyOtpWidgetState extends State<VerifyOtpWidget> {
  final AuthController _authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("auth.forgot_password.verify_title".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900,color: Colors.black),),
          const SizedBox(height: 8,),
          Text("auth.forgot_password.verify_subtitle".tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black54),textAlign: TextAlign.left,),
          const SizedBox(height: 4,),
          Text("+251-${_authController.forgotPhoneNumber.value}",style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
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
              _authController.verifyOtp(code);
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
                      if (!_authController.isRequestingOtp.value) {
                        _authController.requestOtp(_authController.forgotPhoneNumber.value);
                      }
                    },
                    child: Text("auth.otp.resend".tr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.primary,decoration: TextDecoration.underline)));
              }
            }),
          ),
          SizedBox(height: getScreenHeight(context)*0.025,),
          Obx(()=> ButtonWidget(
            text: "auth.forgot_password.verify_button".tr,
            loadingText: "auth.forgot_password.verify_loading".tr,
            fontSize: 16,
            isLoading: _authController.isVerifyingOtp.value,
            onPressed: (){},
          ))
        ],
      ),
    );
  }
}