import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';
import '../core/shared/shared.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2, color: KColors.deepNavyBlue),
          Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: ClipOval(child: Image.asset(appLogo)),
          ),
        ],
      ),
    );
  }
}
