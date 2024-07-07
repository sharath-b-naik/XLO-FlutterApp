import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileServiceX {
  static Future<bool> _checkStoragePermission() async {
    if (Platform.isIOS) return true;

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) return true;

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) return true;

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  static Future<void> saveImageToGallary(File file) async {
    if (!await _checkStoragePermission()) return;
    final filename = file.path.split("/").last;
    File("/storage/emulated/0/Download/$filename")
      ..createSync(recursive: true)
      ..writeAsBytesSync(file.readAsBytesSync());
  }

  static Future<String?> pickGallaryImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (picked == null) return null;
    return picked.path;
  }

  static Future<List<String>?> pickMultiImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 50);
    return picked.map((e) => e.path).toList();
  }
}
