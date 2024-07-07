import 'package:flutter/cupertino.dart';

import '../core/constants/kcolors.dart';
import '../core/constants/svg_icons.dart';
import 'svg_icon.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  const AppBackButton({super.key, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        child: Container(
          height: 35,
          width: 35,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD6D6D6)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgIcon(
                icon: SvgIcons.arrowBack,
                color: color ?? KColors.deepNavyBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
