import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String icon;
  final Color? color;
  final double? size;
  final BoxFit fit;

  const SvgIcon({super.key, required this.icon, this.color, this.size, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      height: size,
      fit: fit,
      // ignore: deprecated_member_use
      color: color,
    );
  }
}
