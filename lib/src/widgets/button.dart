import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color backgroundColor;
  final Color? textColor;
  final Color borderColor;
  final double? radius;
  final VoidCallback? onTap;
  final double? width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    this.text,
    this.child,
    this.backgroundColor = KColors.instaGreen,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.radius,
    this.onTap,
    this.width,
    this.height = 45,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.isLoading = false,
    this.padding,
  }) : assert(text == null || child == null);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onTap,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: "Poppins",
          color: Colors.white,
        ),
        elevation: 0,
        padding: padding,
        minimumSize: Size(width ?? double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
          side: BorderSide(color: borderColor),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Builder(
        builder: (context) {
          if (isLoading) {
            return const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
            );
          } else if (child != null) {
            return child!;
          } else {
            return AppText(
              text!,
              textAlign: TextAlign.center,
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            );
          }
        },
      ),
    );
  }
}
