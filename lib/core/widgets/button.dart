import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double fontSize;
  final double borderRadius;
  final bool fill;
  final bool isLoading;
  final String loadingText;
  final Color color;
  final Widget? icon;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize = 17,
    this.borderRadius = 100.0,
    this.fill = true,
    this.isLoading = false,
    this.loadingText = "",
    this.color = AppColors.primary,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 45,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: fill ? color : Colors.transparent,
            foregroundColor: fill ? Colors.white : color,
            shadowColor: fill?null:Colors.transparent,
            side: (!fill || isDisabled) ? BorderSide(style: BorderStyle.solid, color: color) : null,
            padding: fontSize < 15 ? const EdgeInsets.symmetric(vertical: 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: isLoading
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(color: color, size: 16),
              const SizedBox(width: 10),
              Text("$loadingText...", style: TextStyle(fontSize: fontSize - 2, color: color)),
            ],)
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon != null ? Row(
                    children: [
                      icon!,
                      const SizedBox(width: 7,)
                    ],
                  ):Container(),
                  Text(text, style: TextStyle(fontSize: fontSize,fontWeight: icon != null ? FontWeight.bold:FontWeight.normal)),
                ],
              ),
        ),
      )

    );
  }
}
