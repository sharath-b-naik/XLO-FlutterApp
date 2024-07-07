// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';
import '../core/constants/svg_icons.dart';
import 'svg_icon.dart';

class ProfileAvatar extends StatelessWidget {
  final String? image;
  final double scale;
  final double? errorIconSize;
  const ProfileAvatar({
    super.key,
    required this.image,
    required this.scale,
    this.errorIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        cacheKey: image,
        imageUrl: image ?? '',
        fit: BoxFit.cover,
        height: scale,
        width: scale,
        errorWidget: (context, url, error) {
          return Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(26, 173, 173, 173),
            ),
            child: const SvgIcon(
              icon: SvgIcons.person,
              color: KColors.textColor,
            ),
          );
        },
      ),
    );
  }
}
