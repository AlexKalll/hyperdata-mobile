import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../utils/screen_size.dart';

class DatePickerWidget extends StatefulWidget {
  final String label;
  final String? placeHolder;
  final TextEditingController controller;
  final FocusNode? focus;
  final FocusNode? focusNext;
  final EdgeInsets? padding;
  final VoidCallback? onEnter;
  final bool showLabel;
  final bool isOptional;
  final double borderRadius;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerWidget({
    super.key,
    required this.label,
    required this.controller,
    this.focus,
    this.focusNext,
    this.padding,
    this.onEnter,
    this.showLabel = false,
    this.placeHolder,
    this.isOptional = false,
    this.borderRadius = 18.0,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    String label = widget.label;
    TextEditingController controller = widget.controller;
    EdgeInsets? padding = widget.padding;
    FocusNode? focus = widget.focus;
    FocusNode? focusNext = widget.focusNext;
    VoidCallback? onEnter = widget.onEnter;
    bool showLabel = widget.showLabel;
    String? placeHolder = widget.placeHolder;
    bool isOptional = widget.isOptional;
    double radius = widget.borderRadius;

    Widget icon = const Icon(Icons.calendar_today, color: AppColors.primary, size: 18);

    return Container(
      padding: padding??const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          showLabel
              ? Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 5, left: 3),
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 3),
                !isOptional
                    ? const Text(
                  "*",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: AppColors.red,
                  ),
                )
                    : Container(),
              ],
            ),
          )
              : Container(),
          Container(
            width: getScreenWidth(context) < 500 ? double.infinity : 500,
            margin: const EdgeInsets.only(top: 0),
            child: ClipRRect(
              child: TextFormField(
                selectionHeightStyle: BoxHeightStyle.tight,
                focusNode: focus,
                controller: controller,
                style: const TextStyle(fontSize: 15),
                textAlignVertical: TextAlignVertical.center,
                cursorColor: AppColors.primary,
                readOnly: true, // Make field read-only to prevent manual input
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.inputBgColor,
                  hintText: placeHolder ?? 'validation.enter_field'.trParams({'field': label}),
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  // prefixIcon: icon,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  errorStyle: const TextStyle(fontSize: 10),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(radius)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(radius)),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.red),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  border: InputBorder.none,
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.red),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
                onTap: () async {
                  // Show date picker on tap
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: widget.firstDate ?? DateTime(1900),
                    lastDate: widget.lastDate ?? DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            onSurface: AppColors.primary,
                          ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    // Format the date and update the controller
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    controller.text = formattedDate;
                  }
                },
                onFieldSubmitted: (value) {
                  if (focusNext != null) {
                    FocusScope.of(context).requestFocus(focusNext);
                    Scrollable.ensureVisible(focusNext.context!, alignment: 0.5);
                  } else {
                    FocusScope.of(context).unfocus();
                    if (onEnter != null) {
                      onEnter();
                    }
                  }
                },
                validator: (value) {
                  if (isOptional) return null;
                  return validateDate(value, label);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? validateDate(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'validation.date_required'.trParams({'field': label});
    }
    try {
      DateFormat('yyyy-MM-dd').parseStrict(value);
      return null;
    } catch (e) {
      return 'validation.date_invalid_format'.tr;
    }
  }
}