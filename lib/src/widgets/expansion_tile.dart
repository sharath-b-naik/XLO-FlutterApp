import 'package:flutter/material.dart';

class AppExpansionTile extends StatefulWidget {
  final Widget? child;
  final Widget content;
  final bool? expand;
  final Axis? axis;
  final Duration duration;
  const AppExpansionTile({
    super.key,
    this.child,
    required this.content,
    this.expand,
    this.axis,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AppExpansionTile> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  late bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand ?? isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(AppExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.child != null)
          GestureDetector(
            onTap: () {
              if (widget.expand == null) {
                setState(() => isExpanded = !isExpanded);
                _runExpandCheck();
              }
            },
            behavior: HitTestBehavior.translucent,
            child: widget.child!,
          ),
        SizeTransition(
          axisAlignment: 1.0,
          axis: widget.axis ?? Axis.vertical,
          sizeFactor: animation,
          child: widget.content,
        ),
      ],
    );
  }
}
