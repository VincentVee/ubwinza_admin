import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../../core/models/category_model.dart';
import '../../../core/services/firebase_paths.dart';
import '../../../core/services/storage_service.dart';
import '../data/category_repository.dart';


class CategoryViewModel extends ChangeNotifier {
  final repo = CategoryRepository();
  late final Stream<List<CategoryModel>> stream = repo.watch();

  bool busy = false;
  String? error;

  Future<void> create(String idOrName, {Uint8List? imageBytes}) async {
    try {
      busy = true; error = null; notifyListeners();

      final id = idOrName.trim().toLowerCase().replaceAll(' ', '-');
      if (id.isEmpty) throw Exception('Category name required');

      String? url;
      if (imageBytes != null) {
        url = await StorageService.I.uploadBytes(
          FirebasePaths.categoryFile(id),
          imageBytes,
        );
      }

      final m = CategoryModel(
        id: id,
        name: idOrName.trim(),
        imageUrl: url,
        active: true,
      );
      await repo.upsert(m);
    } catch (e) {
      error = e.toString();
    } finally {
      busy = false; notifyListeners();
    }
  }

  Future<void> toggleActive(String id, bool active) async {
    await repo.updateActive(id, active);
  }

  Future<void> remove(String id) => repo.remove(id);
}