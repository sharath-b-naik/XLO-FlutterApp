import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/kcolors.dart';
import '../../core/shared/shared.dart';
import '../../widgets/app_text.dart';
import '../../widgets/loading_indicator.dart';

void previewDocument(
  BuildContext context,
  String path, {
  bool isNetwork = false,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                maxHeight: MediaQuery.sizeOf(context).height * 0.7,
              ),
              child: Center(
                child: Builder(
                  builder: (context) {
                    if (isNetwork) {
                      return CachedNetworkImage(
                        imageUrl: path,
                        fit: BoxFit.fill,
                        imageBuilder: (context, imageProvider) {
                          return FittedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: InteractiveViewer(
                                    child: Image(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: InteractiveViewer(
                                  child: Image.asset(
                                    appLogo,
                                    fit: BoxFit.fill,
                                    color: const Color(0x0B000000),
                                  ),
                                ),
                              ),
                              const AppText("Failed to load file", color: KColors.deepNavyBlue),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                        placeholder: (context, url) => const LoadingIndicator(),
                      );
                    } else {
                      return InteractiveViewer(
                        child: Image.file(
                          File(path),
                          fit: BoxFit.fill,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      );
    },
  );
}
