import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? height;
  final FontStyle? fontStyle;
  final TextStyle? style;
  final String? fontFamily;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.decoration,
    this.height,
    this.fontStyle,
    this.style,
    this.fontFamily,
  });

  AppText copyWith({
    String? text,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextDecoration? decoration,
    double? height,
    FontStyle? fontStyle,
    TextStyle? style,
    String? fontFamily,
  }) {
    return AppText(
      text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      color: color ?? this.color,
      textAlign: textAlign ?? this.textAlign,
      maxLines: maxLines ?? this.maxLines,
      decoration: decoration ?? this.decoration,
      height: height ?? this.height,
      fontStyle: fontStyle ?? this.fontStyle,
      style: style ?? this.style,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: style ??
          TextStyle(
            fontFamily: fontFamily ?? "Poppins",
            fontSize: fontSize ?? 14,
            fontStyle: fontStyle,
            decoration: decoration,
            height: height,
            fontWeight: fontWeight ?? FontWeight.w500,
            color: color ?? KColors.deepNavyBlue,
            letterSpacing: 0.2,
          ),
    );
  }
}

class EmojiText extends StatelessWidget {
  const EmojiText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildText(text),
    );
  }

  TextSpan _buildText(String text) {
    final children = <TextSpan>[];
    final runes = text.runes;

    for (int i = 0; i < runes.length; /* empty */) {
      int current = runes.elementAt(i);

      // we assume that everything that is not
      // in Extended-ASCII set is an emoji...
      final isEmoji = current > 255;
      final shouldBreak = isEmoji ? (x) => x <= 255 : (x) => x > 255;

      final chunk = <int>[];
      while (!shouldBreak(current)) {
        chunk.add(current);
        if (++i >= runes.length) break;
        current = runes.elementAt(i);
      }

      children.add(
        TextSpan(
          text: String.fromCharCodes(chunk),
          style: TextStyle(
            color: KColors.deepNavyBlue,
            fontFamily: isEmoji ? 'EmojiOne' : "Poppins",
          ),
        ),
      );
    }

    return TextSpan(children: children);
  }
}
