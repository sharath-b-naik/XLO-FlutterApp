import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDatePicker extends StatelessWidget {
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? selectedDate;
  final Color textColor;
  final ValueChanged<DateTime?> onChanged;
  final String dateFormatPattern;
  final Widget? trailing;

  const AppDatePicker({
    super.key,
    this.hintText = "Select date",
    this.textColor = const Color(0xFFFFFFFF),
    required this.onChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.dateFormatPattern = 'd LLLL y',
    this.trailing,
    this.selectedDate,
  });

  String get _text {
    if (selectedDate == null) return hintText;
    return DateFormat(dateFormatPattern).format(DateTime.parse(selectedDate!).toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? result = await datePicker(context);
        if (result != null) onChanged(result);
      },
      child: Text(
        _text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'Avenir',
          fontSize: 14,
          color: selectedDate == null ? const Color(0xff808080) : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2300),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onSecondary: textColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
