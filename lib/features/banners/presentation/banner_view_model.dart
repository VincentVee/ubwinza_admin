import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../../core/models/banner_model.dart';
import '../../../core/services/firebase_paths.dart';
import '../../../core/services/storage_service.dart';
import '../data/banner_repository.dart';


class BannerViewModel extends ChangeNotifier {
  final repo = BannerRepository();
  late final Stream<List<BannerModel>> stream = repo.watch();


  bool busy = false;
  String? error;


  Future<void> createFromBytes(Uint8List bytes, {String? targetCategoryId}) async {
    try {
      busy = true;
      error = null;
      notifyListeners();


      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final path = FirebasePaths.bannerFile(id);
      final url = await StorageService.I.uploadBytes(path, bytes);
      final model = BannerModel(
        id: id,
        imageUrl: url,
        targetCategoryId: targetCategoryId,
        active: true,
        createdAt: DateTime.now(),
      );
      await repo.create(model);
    } catch (e) {
      error = e.toString();
    } finally {
      busy = false;
      notifyListeners();
    }
  }
  
  Future<void> toggleActive(String id, bool active) => repo.toggleActive(id, active);
  Future<void> remove(String id) => repo.remove(id);
}