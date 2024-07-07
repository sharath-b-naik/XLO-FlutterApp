import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../widgets/app_text.dart';

abstract class Toast {
  static void success(String message) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: const Color(0xFF017442),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AppText(
              message,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 3),
    );
  }

  static void failure(String message) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: const Color(0xFFCD0E00),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AppText(
              message,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 3),
    );
  }

  static void warning(String message) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AppText(
              message,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 3),
    );
  }

  static void info(String message) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: const Color(0xFF02355F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AppText(
              message,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 3),
    );
  }
}
