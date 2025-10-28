import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';


class StorageService {
  StorageService._();
  static final StorageService I = StorageService._();


  final _storage = FirebaseStorage.instance;


  Future<String> uploadBytes(String path, Uint8List bytes) async {
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }


  Future<void> delete(String path) => _storage.ref(path).delete();
}