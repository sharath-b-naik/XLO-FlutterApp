import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final List<RichItem> texts;

  const AppRichText({
    super.key,
    required this.texts,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: texts.map(
          (text) {
            return TextSpan(
              text: text.text,
              recognizer: TapGestureRecognizer()..onTap = text.onTap,
              style: TextStyle(
                fontFamily: text.fontFamily ?? "Poppins",
                color: text.color ?? Colors.black,
                decoration: text.decoration,
                fontSize: (text.fontSize ?? 14),
                fontWeight: text.fontWeight,
                height: text.height,
                fontStyle: text.fontStyle,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class RichItem {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final double? height;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final VoidCallback? onTap;

  RichItem(
    this.text, {
    this.onTap,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.decoration,
    this.height,
    this.fontFamily,
    this.fontStyle,
  });
}
