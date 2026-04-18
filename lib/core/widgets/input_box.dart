
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/image.dart';


enum InputType{
  text,password,email,confirmPass,money,number,other
}

String? validateInput(String? value,String label,{bool shouldValidate = true}) {
  if(!shouldValidate){
    return null;
  }
  if (value == null || value.isEmpty || value.isBlank!) {
    return 'validation.field_required'.trParams({'field': label});
  }
  return null;
}

String? validatePassword(String? value,String label , {bool shouldValidate = true}) {
  if (value == null || value.isEmpty || value.isBlank!) {
    return 'validation.field_required'.trParams({'field': label});
  }
  if(shouldValidate && value.length < 8) {
    return 'validation.password_min_8'.trParams({'field': label});
  }
  if (shouldValidate && !RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
    return 'validation.password_uppercase'.trParams({'field': label});
  }
  if (shouldValidate && !RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
    return 'validation.password_lowercase'.trParams({'field': label});
  }
  if (shouldValidate && !RegExp(r'^(?=.*[0-9])').hasMatch(value)) {
    return 'validation.password_number'.trParams({'field': label});
  }
  if (shouldValidate && !RegExp(r'^(?=.*[!@#$%^&*()_+{}:"<>?])').hasMatch(value)) {
    return 'validation.password_special'.trParams({'field': label});
  }
  return null;
}

String? validateConfirmPass(String? value ,String label, TextEditingController pass) {
  if (value == null || value.isEmpty|| value.isBlank!) {
    return 'validation.confirm_password_required'.tr;
  }
  if(value != pass.text){
    return 'validation.passwords_not_match'.tr;
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty|| value.isBlank!) {
    return 'validation.phone_required'.tr;
  }

  final phoneRegex = RegExp(r'^[0-9]{9}$'); // Phone number format: +251 followed by 9 additional digits

  if (!phoneRegex.hasMatch(value)) {
    if (value.length != 9) {
      return 'validation.phone_9_digits'.tr;
    }
    else {
      return 'validation.phone_format_incorrect'.tr;
    }
  }

  return null;
}

String? validateEmail(String? value){
  if (value == null || value.isEmpty || value.isBlank!) {
    return null;
  }

  // Regular expression for validating an Email
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return 'validation.invalid_email_format'.tr;
  }
  return null;
}

String? validateNumber(String? value, String label) {
  if (value == null || value.isEmpty || value.isBlank!) {
    return 'validation.field_required'.trParams({'field': label});
  }

  // Try to parse the string as a number
  final number = double.tryParse(value);
  if (number == null) {
    return '$label ${'validation.is_not_number'.tr}';
  }

  return null;
}

class InputBoxWidget extends StatefulWidget {
  InputType inputType;
  String label;
  String? placeHolder;
  TextEditingController controller;
  FocusNode? focus;
  FocusNode? focusNext;
  EdgeInsets? padding;
  TextEditingController? pass;
  VoidCallback? onEnter;
  bool showLabel;
  bool isOptional;
  int maxLines;
  double? height;
  double borderRadius;
  bool shouldValidate;
  bool enabled;

  InputBoxWidget({super.key,
    required this.inputType,
    required this.label,
    required this.controller,
    this.focus,
    this.focusNext,
    this.padding,
    this.pass,
    this.onEnter,
    this.showLabel = false,
    this.placeHolder,
    this.isOptional = false,
    this.maxLines = 1,
    this.height,
    this.borderRadius = 18.0,
    this.shouldValidate = true,
    this.enabled = true,
  });

  @override
  State<InputBoxWidget> createState() => _InputBoxWidgetState();
}

class _InputBoxWidgetState extends State<InputBoxWidget> {

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.inputType == InputType.password || widget.inputType == InputType.confirmPass;

    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.showLabel
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0,bottom: 3.0),
                  child: Row(
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      !widget.isOptional
                          ? const Text(
                              " *",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.red),
                            )
                          : Container(),
                    ],
                  ),
                )
              : Container(),
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focus,
            enabled: widget.enabled,
            keyboardType: _getKeyboardType(widget.inputType),
            obscureText: isPasswordField && !isPasswordVisible,
            maxLines: widget.maxLines,
            style: const TextStyle(fontSize: 15),
            cursorColor: AppColors.primary,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: (value) {
              if (widget.focusNext != null) {
                FocusScope.of(context).requestFocus(widget.focusNext);
                Scrollable.ensureVisible(widget.focusNext!.context!, alignment: 0.5);
              } else {
                FocusScope.of(context).unfocus();
                widget.onEnter?.call();
              }
            },
            validator: (value) => _getValidator(widget.inputType, value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputBgColor,
              hintText: widget.placeHolder ?? 'validation.enter_field'.trParams({'field': widget.label}),
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              errorStyle: const TextStyle(fontSize:10, color: AppColors.red),
              suffixIcon: isPasswordField
                  ? IconButton(
                icon: Icon(
                  size: 20,
                  isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF79747E),
                ),
                onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
              )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.red),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.red),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(InputType type) {
    switch (type) {
      case InputType.password:
      case InputType.confirmPass:
        return Icons.lock_outline;
      case InputType.money:
        return Icons.monetization_on_outlined;
      case InputType.number:
        return Icons.numbers;
      case InputType.other:
      default:
        return Icons.library_add_check_outlined;
    }
  }

  TextInputType _getKeyboardType(InputType type) {
    switch (type) {
      case InputType.number:
      case InputType.money:
        return const TextInputType.numberWithOptions(signed: true);
      default:
        return TextInputType.text;
    }
  }

  String? _getValidator(InputType type, String? value) {
    switch (type) {
      case InputType.text:
        return widget.isOptional ? null : validateInput(value, widget.label,shouldValidate: widget.shouldValidate);
      case InputType.password:
        return validatePassword(value, widget.label , shouldValidate: widget.shouldValidate);
      case InputType.confirmPass:
        return validateConfirmPass(value, "Confirm Password", widget.pass!);
      case InputType.email:
        return validateEmail(value);
      case InputType.money:
      case InputType.number:
        return widget.isOptional ? null : validateNumber(value, widget.label);
      case InputType.other:
        return widget.isOptional ? null : validateInput(value, widget.label);
    }
  }


}


class SearchInputBoxWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  double height;
  double radius;
  String label = "Search";
  VoidCallback onChange;

  SearchInputBoxWidget({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onChange,
    this.height = 50,
    this.radius = 70,
    this.label = "Search",});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.only(top: 0),
          child: ClipRRect(
            child:TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 15),
              textAlignVertical: TextAlignVertical.center,
              cursorColor: Colors.black,
              onChanged: (String changedText) {
                onChange();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: label,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search,color: Colors.black,),
                contentPadding: const EdgeInsets.only(left: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(radius),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(radius)),
                border: InputBorder.none,
              ),
              onFieldSubmitted: ((value) {
                onChange();
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class PhoneInputBoxWidget extends StatelessWidget {
  TextEditingController controller;
  FocusNode? focus;
  FocusNode? focusNext;
  String? placeHolder;
  double height;
  double radius;
  String label = "Phone Number";
  bool showLabel = true;
  bool enabled;

  PhoneInputBoxWidget({
    super.key,
    required this.controller,
    this.focus,
    this.focusNext,
    this.placeHolder,
    this.height = 50,
    this.radius = 16,
    this.label = "Phone Number",
    this.showLabel = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        showLabel?Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text(" *", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.red),)
              ],
            ),
          ),):Container(),
        showLabel?const SizedBox(height: 3):Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height,
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              margin: const EdgeInsets.only(right: 7.5),
              decoration: BoxDecoration(
                color: AppColors.inputBgColor,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Center(
                child: Row(
                  children: [
                    assetSvgImageWidget("eth-flag.svg",width: 16,height: 16,fit: BoxFit.scaleDown),
                    const SizedBox(width:10),
                    const Text(
                      "+251",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: controller,
                enabled: enabled,
                focusNode: focus,
                style: const TextStyle(fontSize: 15),
                textAlignVertical: TextAlignVertical.center,
                autovalidateMode: AutovalidateMode.onUnfocus,
                cursorColor: Colors.black,
                validator: (value) {
                  return validatePhone(value);
                },
                onFieldSubmitted: (value) {
                  if (focusNext != null) {
                    FocusScope.of(context).requestFocus(focusNext);
                    Scrollable.ensureVisible(focusNext!.context!, alignment: 0.5);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.inputBgColor,
                  hintText: placeHolder ?? 'validation.enter_phone'.tr,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(radius)),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.red),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(radius)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.red),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
