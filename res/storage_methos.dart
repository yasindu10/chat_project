import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  Future<String> storeImage(String path, File file) async {
    final image = await FirebaseStorage.instance.ref(path).putFile(file);

    return await image.ref.getDownloadURL();
  }
}
