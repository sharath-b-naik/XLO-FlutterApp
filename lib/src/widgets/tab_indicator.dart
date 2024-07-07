import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';

enum TabPosition { top, bottom }

class MaterialIndicator extends Decoration {
  final double height;
  final TabPosition tabPosition;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  const MaterialIndicator({
    this.height = 4,
    this.tabPosition = TabPosition.bottom,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeWidth = 2,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      height: height,
      tabPosition: tabPosition,
      paintingStyle: paintingStyle,
      strokeWidth: strokeWidth,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final MaterialIndicator decoration;
  final double height;
  final TabPosition tabPosition;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged, {
    required this.height,
    required this.tabPosition,
    required this.paintingStyle,
    required this.strokeWidth,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(strokeWidth >= 0 &&
        strokeWidth < configuration.size!.width / 2 &&
        strokeWidth < configuration.size!.height / 2);

    Size mysize = Size(configuration.size!.width - 0, height);

    Offset myoffset = Offset(
      offset.dx,
      offset.dy + (tabPosition == TabPosition.bottom ? configuration.size!.height - height : 0),
    );

    final Rect rect = myoffset & mysize;
    final Paint paint = Paint();
    paint.color = KColors.white;
    paint.style = paintingStyle;
    paint.strokeWidth = strokeWidth;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          bottomRight: const Radius.circular(0),
          bottomLeft: const Radius.circular(0),
          topLeft: const Radius.circular(5),
          topRight: const Radius.circular(5),
        ),
        paint);
  }
}
