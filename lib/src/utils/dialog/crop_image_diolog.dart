import 'dart:io';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_text.dart';

Future<File?> cropImageDialog(BuildContext context, String path) async {
  return await showDialog<File?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.9,
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: CropImagePage(
            path: path,
            onFinished: (value) => Navigator.of(context).pop<File?>(value),
          ),
        ),
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      );
    },
  );
}

class CropImagePage extends StatefulWidget {
  final String path;
  final ValueChanged<File> onFinished;
  const CropImagePage({
    super.key,
    required this.path,
    required this.onFinished,
  });

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  bool isGeneratingImage = false;
  late final controller = CropController(aspectRatio: 1);
  Image? croppedImage;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> onFinished() async {
    setState(() => isGeneratingImage = !isGeneratingImage);
    ui.Image bitmap = await controller.croppedBitmap(maxSize: 1024);
    final data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    final bytes = data!.buffer.asUint8List();
    final file = File(widget.path);
    await file.writeAsBytes(bytes);
    widget.onFinished(file);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        AppText(
          croppedImage == null ? 'Crop image' : 'Cropped image',
          fontSize: 16,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 320,
          width: 320,
          child: croppedImage ??
              CropImage(
                controller: controller,
                paddingSize: 10,
                image: Image.file(File(widget.path)),
                alwaysMove: true,
                minimumImageSize: 512,
                maximumImageSize: 512,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF585858)),
              splashRadius: 20,
              onPressed: () => GoRouter.of(context).pop(),
            ),
            if (croppedImage == null) ...[
              IconButton(
                icon: const Icon(Icons.rotate_90_degrees_ccw_outlined, color: Color(0xFF585858)),
                splashRadius: 20,
                onPressed: () async => controller.rotateLeft(),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_90_degrees_cw_outlined, color: Color(0xFF585858)),
                splashRadius: 20,
                onPressed: () async => controller.rotateRight(),
              ),
            ],
            if (croppedImage != null) ...[const SizedBox(), const SizedBox()],
            TextButton(
              onPressed: () async {
                if (isGeneratingImage) return;

                if (croppedImage != null) return onFinished();
                croppedImage = await controller.croppedImage();
                setState(() {});
              },
              child: Builder(builder: (context) {
                if (isGeneratingImage) {
                  return const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  );
                } else {
                  return AppText(
                    croppedImage == null ? 'Crop' : 'Done',
                    color: const Color(0xFF585858),
                  );
                }
              }),
            ),
          ],
        ),
      ],
    );
  }
}
