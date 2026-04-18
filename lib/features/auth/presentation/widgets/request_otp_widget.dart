import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/screen_size.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/input_box.dart';
import '../controllers/auth_controller.dart';

class RequestOtpWidget extends StatefulWidget {

  const RequestOtpWidget({super.key});

  @override
  State<RequestOtpWidget> createState() => _RequestOtpWidgetState();
}

class _RequestOtpWidgetState extends State<RequestOtpWidget> {
  final AuthController _authController = Get.find();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("auth.forgot_password.title".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900,color: Colors.black),),
          SizedBox(height: getScreenHeight(context)*0.01,),
          Text("auth.forgot_password.subtitle".tr,style: const TextStyle(fontSize: 13,color: Colors.black54),),
          SizedBox(height: getScreenHeight(context)*0.02,),
          PhoneInputBoxWidget(
            controller: _phoneNumberController,
            focus: _phoneNumberFocusNode,
            placeHolder: "auth.forgot_password.phone_placeholder".tr,
            showLabel: false,
          ),
          SizedBox(height: getScreenHeight(context)*0.02,),
          Obx(()=> ButtonWidget(
            text: "auth.forgot_password.request_button".tr,
            loadingText: "auth.forgot_password.request_loading".tr,
            fontSize: 16,
            isLoading: _authController.isRequestingOtp.value,
            onPressed: (){
              if(_formKey.currentState!.validate()){
                _authController.requestOtp(_phoneNumberController.text.trim());
              }
            },
          ))
        ],
      ),
    );
  }
}
