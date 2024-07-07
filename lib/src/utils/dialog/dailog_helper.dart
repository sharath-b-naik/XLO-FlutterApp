import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/kcolors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/loading_indicator.dart';

abstract class DialogHelper {
  static removeLoading(BuildContext context) => GoRouter.of(context).pop();

  static showloading(BuildContext context, [String text = 'Please hold on']) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: KColors.white,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 120,
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoadingIndicator(),
                    const SizedBox(height: 10),
                    AppText(
                      text,
                      height: 1,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
