import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/features/auth/domain/entities/dialect_entity.dart';
import 'package:leyu_mobile/features/auth/domain/entities/language_entity.dart';

import '../../../../core/utils/screen_size.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/dropdown.dart';
import '../../../../core/widgets/input_box.dart';
import '../controllers/auth_controller.dart';

class RegisterAdditionalInfoWidget extends StatefulWidget {
  const RegisterAdditionalInfoWidget({super.key});

  @override
  State<RegisterAdditionalInfoWidget> createState() => _RegisterAdditionalInfoWidgetState();
}

class _RegisterAdditionalInfoWidgetState extends State<RegisterAdditionalInfoWidget> {
  final AuthController _authController = Get.find();

  final formKey = GlobalKey<FormState>();

  Rxn<LanguageEntity> selectedLanguage = Rxn<LanguageEntity>(null);
  Rxn<DialectEntity> selectedDialect = Rxn<DialectEntity>(null);
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if(_authController.languages.isEmpty){
      _authController.getLanguages();
    }
    else{
      selectedLanguage.value = _authController.languages.toList().firstWhereOrNull((lang) => lang.id == _authController.selectedLanguageId.value);
      if(selectedLanguage.value != null) {
        if(_authController.dialects.isEmpty){
          _authController.getDialects(selectedLanguage.value!.id).then((_) {
            selectedDialect.value = _authController.dialects.toList().firstWhereOrNull((dialect) => dialect.id == _authController.selectedDialectId.value);
          });
        }
        else{
          selectedDialect.value = _authController.dialects.toList().firstWhereOrNull((dialect) => dialect.id == _authController.selectedDialectId.value);
        }
      }
    }
    _emailController.value = TextEditingValue(text: _authController.email.value ?? '');
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
                        _authController.currentPage.value = 1;
                      },
                      child: const Icon(Icons.arrow_back, size: 26),
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: getScreenHeight(context) * 0.025),
                Text("auth.profile.additional_info_title".tr,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                const SizedBox(height: 5),
                Text("auth.profile.additional_info_subtitle".tr,style: const TextStyle(fontSize: 13,color: Colors.black54),),
                SizedBox(height: getScreenHeight(context) * 0.02),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Obx(()=> DropdownBoxWidget<LanguageEntity>(
                        label: "auth.profile.language_spoken".tr,
                        items: _authController.languages.toList(),
                        selectedItem: selectedLanguage.value,
                        isItemsLoading: _authController.isLoadingLanguages.value,
                        showLabel: true,
                        isOptional: false,
                        placeHolder: "auth.profile.language_placeholder".tr,
                        displayText: (LanguageEntity language) {
                          return language.name??"N/A";
                        },
                        reFetch: () {
                           _authController.getLanguages();
                        },
                        onChanged: (LanguageEntity? value) {
                          if (value != null) {
                            selectedLanguage.value = value;
                            selectedDialect.value = null;
                            _authController.getDialects(selectedLanguage.value!.id);
                          } else {
                            selectedLanguage.value = null;
                          }
                        },
                      ),),
                      SizedBox(height: getScreenHeight(context)*0.01),
                      Obx(() => DropdownBoxWidget<DialectEntity>(
                        label: "auth.profile.dialect".tr,
                        items: _authController.dialects.toList(),
                        selectedItem: selectedDialect.value,
                        isItemsLoading: _authController.isLoadingDialects.value,
                        showLabel: true,
                        isOptional: false,
                        placeHolder: "auth.profile.dialect_placeholder".tr,
                        displayText: (DialectEntity dialect) {
                          return dialect.name ?? "N/A";
                        },
                        reFetch: () {
                          if(selectedLanguage.value != null) {
                            _authController.getDialects(selectedLanguage.value!.id);
                          }
                          else{
                            showErrorMessage("auth.profile.dialect_error".tr);
                          }
                        },
                        onChanged: (DialectEntity? value) {
                          if (value != null) {
                            selectedDialect.value = value;
                          } else {
                            selectedDialect.value = null;
                          }
                        },
                      )),
                      SizedBox(height: getScreenHeight(context)*0.01),
                      InputBoxWidget(
                        inputType: InputType.text,
                        label: "auth.profile.email".tr,
                        placeHolder: "auth.profile.email_placeholder".tr,
                        controller: _emailController,
                        focus: _emailFocusNode,
                        showLabel: true,
                        isOptional: true,
                      ),
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
              _authController.saveThirdStage(
                selectedLanguage.value?.id ?? '',
                selectedDialect.value?.id ?? '',
                _emailController.text.trim(),
              );
            }
          },
        ),
        SizedBox(height: getScreenHeight(context)*0.025),
      ],
    );
  }
}
