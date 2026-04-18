import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/utils/message.dart';

import '../../../../core/utils/screen_size.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/date_picker.dart';
import '../../../../core/widgets/dropdown.dart';
import '../../../../core/widgets/input_box.dart';
import '../controllers/auth_controller.dart';

class RegisterUserInfoWidget extends StatefulWidget {
  const RegisterUserInfoWidget({super.key});

  @override
  State<RegisterUserInfoWidget> createState() => _RegisterUserInfoWidgetState();
}

class _RegisterUserInfoWidgetState extends State<RegisterUserInfoWidget> {
  final AuthController _authController = Get.find();

  final List<String> genderOptions = ['Male', 'Female'];

  final formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  RxnString selectedGender = RxnString(null);

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _birthDateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _firstNameController.value = TextEditingValue(text: _authController.firstName.value ?? '');
    _middleNameController.value = TextEditingValue(text: _authController.middleName.value ?? '');
    _lastNameController.value = TextEditingValue(text: _authController.lastName.value ?? '');
    _birthDateController.value = TextEditingValue(text: _authController.birthDate.value ?? '');
    selectedGender.value = _authController.gender.value;
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
                        Get.back();
                      },
                      child: const Icon(Icons.arrow_back, size: 26),
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: getScreenHeight(context) * 0.025),
                Text("auth.profile.user_info_title".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                const SizedBox(height: 5),
                Text("auth.profile.user_info_subtitle".tr,style: const TextStyle(fontSize: 13,color: Colors.black54),),
                SizedBox(height: getScreenHeight(context) * 0.02),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputBoxWidget(
                        inputType: InputType.text,
                        label: "auth.profile.first_name".tr,
                        placeHolder: "auth.profile.first_name_placeholder".tr,
                        controller: _firstNameController,
                        focus: _firstNameFocusNode,
                        focusNext: _middleNameFocusNode,
                        showLabel: true,
                      ),
                      SizedBox(height: getScreenHeight(context)*0.01),
                      InputBoxWidget(
                        inputType: InputType.text,
                        label: "auth.profile.middle_name".tr,
                        placeHolder: "auth.profile.middle_name_placeholder".tr,
                        controller: _middleNameController,
                        focus: _middleNameFocusNode,
                        focusNext: _lastNameFocusNode,
                        showLabel: true,
                      ),
                      SizedBox(height: getScreenHeight(context)*0.01),
                      InputBoxWidget(
                        inputType: InputType.text,
                        label: "auth.profile.last_name".tr,
                        placeHolder: "auth.profile.last_name_placeholder".tr,
                        controller: _lastNameController,
                        focus: _lastNameFocusNode,
                        focusNext: _birthDateFocusNode,
                        showLabel: true,
                      ),
                      SizedBox(height: getScreenHeight(context)*0.01),
                      DatePickerWidget(
                        label: "auth.profile.birth_date".tr,
                        placeHolder: "auth.profile.birth_date_placeholder".tr,
                        controller: _birthDateController,
                        focus: _birthDateFocusNode,
                        focusNext: null,
                        showLabel: true,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ),
                      SizedBox(height: getScreenHeight(context)*0.01),
                      DropdownBoxWidget<String>(
                        label: "auth.profile.gender".tr,
                        items: genderOptions,
                        selectedItem: selectedGender.value,
                        showLabel: true,
                        isOptional: false,
                        placeHolder: "auth.profile.gender_placeholder".tr,
                        displayText: (String text) {
                          return text == 'Male' ? "auth.profile.gender_male".tr : "auth.profile.gender_female".tr;
                        },
                        onChanged: (String? value) {
                          if (value != null) {
                            selectedGender.value = value;
                          } else {
                            selectedGender.value = null;
                          }
                        },
                      ),
                      SizedBox(height: getScreenHeight(context)*0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ButtonWidget(
          text: "Continue".tr,
          loadingText: "Continuing".tr,
          fontSize: 16,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _authController.saveFirstStage(_firstNameController.value.text.trim(),
                  _middleNameController.value.text.trim(),
                  _lastNameController.value.text.trim(),
                  _birthDateController.value.text.trim(),
                  selectedGender.value!,
              );
            }
          },
        ),
        SizedBox(height: getScreenHeight(context)*0.025),
      ],
    );
  }
}
