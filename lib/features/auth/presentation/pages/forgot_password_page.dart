import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';
import '../../../../../core/utils/screen_size.dart';
import '../controllers/auth_controller.dart';
import '../widgets/request_otp_widget.dart';
import '../widgets/reset_password_widget.dart';
import '../widgets/verify_otp_widget.dart';

class ForgotPasswordPage extends StatelessWidget {
  final AuthController _authController = Get.find();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=> PopScope(
      canPop: !_authController.isRequestingOtp.value ||
          !_authController.isVerifyingOtp.value ||
          !_authController.isResettingPassword.value,
      child: Scaffold(
          backgroundColor: AppColors.appBgColor,
          body: SafeArea(
            child: LoadingOverlayWidget(
              isLoading: [_authController.isRequestingOtp , _authController.isVerifyingOtp , _authController.isResettingPassword],
              reason: _authController.forgotLoadingReason,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getScreenHeight(context)*0.03,),
                      InkWell(
                        onTap: (){
                          if(_authController.forgotPasswordPage.value == 0) {
                            Get.back();
                          }
                          else if(_authController.forgotPasswordPage.value == 1) {
                            _authController.forgotPasswordPage.value = 0;
                          }
                          else if(_authController.forgotPasswordPage.value == 2) {
                            _authController.forgotPasswordPage.value = 1;
                          }
                        },
                        child: const Icon(Icons.arrow_back,size: 26,),
                      ),
                      SizedBox(height: getScreenHeight(context)*0.075,),
                      if(_authController.forgotPasswordPage.value == 0)
                        const RequestOtpWidget()
                      else if(_authController.forgotPasswordPage.value == 1)
                        const VerifyOtpWidget()
                      else if(_authController.forgotPasswordPage.value == 2)
                          const ResetPasswordWidget()
                    ],
                  ),
                ),
              ),
            ),
          )
          ),
    ),
    );
  }
}
