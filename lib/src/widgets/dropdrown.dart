// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class AppDropDown extends StatefulWidget {
  final String? value;
  final String hinttext;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final double height;
  final FormFieldValidator<String?>? validator;

  const AppDropDown({
    super.key,
    required this.value,
    required this.hinttext,
    this.items = const [],
    this.onChanged,
    this.height = 50,
    this.validator,
  });

  @override
  State<AppDropDown> createState() => _AppDropDown();
}

class _AppDropDown extends State<AppDropDown> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: DropdownButtonFormField2<String>(
        value: null,
        onChanged: widget.onChanged,
        validator: widget.validator,
        barrierColor: Colors.black12,
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w400, fontSize: 12),
          errorStyle: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: Colors.red,
            fontSize: 10,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(8),
          ),
          isDense: true,
          filled: true,
          fillColor: KColors.white,
          contentPadding: EdgeInsets.zero,
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.zero,
          offset: const Offset(0, -5),
          maxHeight: 250,
          elevation: 0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        buttonStyleData: const ButtonStyleData(elevation: 10),
        customButton: Container(
          constraints: BoxConstraints(minHeight: widget.height),
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          child: Row(
            children: [
              if (widget.value != null) ...[
                Expanded(
                  child: AppText(
                    widget.value!,
                    maxLines: 1,
                    height: 0,
                    color: Colors.black,
                  ),
                ),
              ],
              if (widget.value == null) ...[
                Expanded(
                  child: AppText(
                    widget.hinttext,
                    fontSize: 12,
                    maxLines: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
              const SizedBox(width: 5),
              Transform.rotate(angle: _isOpened ? 0 : pi, child: const Icon(Icons.arrow_drop_up)),
            ],
          ),
        ),
        onMenuStateChange: (isOpen) {
          _isOpened = isOpen;
          setState(() {});
        },
        items: [
          ...widget.items.map(
            (item) {
              return DropdownMenuItem<String>(
                value: item,
                child: AppText(
                  item,
                  height: 0,
                  color: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
