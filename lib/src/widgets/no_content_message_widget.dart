import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class NoContentMessageWidget extends StatelessWidget {
  final String message;
  final Widget child;
  const NoContentMessageWidget({super.key, required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          AppText(
            message,
            color: KColors.deepNavyBlue,
            fontWeight: FontWeight.w300,
          ),
        ],
      ),
    );
  }
}
