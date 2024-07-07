import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double height;

  const ShimmerWidget({super.key, required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return FadeShimmer(
      width: width ?? double.infinity,
      height: height,
      fadeTheme: FadeTheme.light,
      baseColor: Colors.grey,
      highlightColor: Colors.grey,
      radius: 10,
    );
  }
}
