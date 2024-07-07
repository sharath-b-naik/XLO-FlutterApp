// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';
import 'expansion_tile.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final String? icon;
  final bool enabled;
  final Color? hintColor;
  final int? maxLines;
  final int? minLines;
  final String? Function(String value)? validator;
  final double radius;
  final Color? borderColor;
  final bool isPassword;
  final String? initialValue;
  final int? maxCharacters;
  final List<TextInputFormatter> inputFormatters;
  final Widget? leading;
  final Widget? trailing;
  final double? height;
  final Color? filledColor;
  final FocusNode? focusNode;
  final bool hideKeyboardOnTapOutside;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.controller,
    this.onChanged,
    required this.hintText,
    this.keyboardType,
    this.textAlign,
    this.icon,
    this.enabled = true,
    this.hintColor,
    this.maxLines,
    this.minLines,
    this.validator,
    this.radius = 0,
    this.borderColor,
    this.isPassword = false,
    this.initialValue,
    this.maxCharacters,
    this.inputFormatters = const [],
    this.leading,
    this.trailing,
    this.height,
    this.filledColor,
    this.focusNode,
    this.hideKeyboardOnTapOutside = false,
    this.autofocus = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String? validateValue;
  bool showPassword = true;
  int typedCharacters = 0;

  void onValueChanged(String value) {
    if (widget.validator == null) widget.onChanged;

    widget.onChanged?.call(value);
    setState(() {
      validateValue = widget.validator?.call(value);
      if (widget.maxCharacters != null) typedCharacters = value.length;
    });
  }

  bool get isValidationError => widget.validator != null && validateValue != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: widget.key,
          initialValue: widget.initialValue,
          controller: widget.controller,
          onChanged: onValueChanged,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          enabled: widget.enabled,
          cursorWidth: 1,
          obscureText: widget.isPassword ? showPassword : false,
          maxLines: widget.isPassword ? 1 : widget.maxLines ?? 1,
          minLines: widget.minLines,
          cursorColor: KColors.deepNavyBlue,
          obscuringCharacter: "•",
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          style: const TextStyle(
            height: 1.3,
            fontSize: 14,
            color: KColors.deepNavyBlue,
            fontWeight: FontWeight.w400,
          ),
          onTapOutside: (event) {
            if (widget.hideKeyboardOnTapOutside) FocusManager.instance.primaryFocus?.unfocus();
          },
          inputFormatters: [
            if (widget.maxCharacters != null) LengthLimitingTextInputFormatter(widget.maxCharacters),
            ...widget.inputFormatters,
          ],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            filled: true,
            constraints: BoxConstraints(maxHeight: widget.height ?? double.infinity),
            fillColor: widget.filledColor ?? Colors.white12,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: widget.hintColor ?? KColors.deepNavyBlue,
              fontWeight: FontWeight.w300,
            ),
            prefixIcon: widget.leading == null
                ? null
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [widget.leading!],
                  ),
          ),
        ),
        if (isValidationError) ...[
          AppExpansionTile(
            expand: widget.validator != null && validateValue != null,
            content: Padding(
              padding: const EdgeInsets.all(5.0).copyWith(left: 20),
              child: AppText(
                validateValue!,
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
        ],
        if (widget.maxCharacters != null) ...[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, top: 5),
              child: AppText(
                "$typedCharacters/${widget.maxCharacters}",
                fontWeight: FontWeight.w400,
                height: 0,
                fontSize: 10,
                color: KColors.deepNavyBlue,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
