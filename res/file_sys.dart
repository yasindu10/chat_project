import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fsProvider = Provider((ref) => FileSystemMethods());

class FileSystemMethods {
  Future<File?> picFile() async {
    final image = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['jpg', 'png'],
        type: FileType.custom);

    if (image != null) {
      return File(image.files.single.path!);
    } else {
      return null;
    }
  }
}
