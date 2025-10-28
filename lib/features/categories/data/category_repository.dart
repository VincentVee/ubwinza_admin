import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/category_model.dart';
import '../../../core/services/firebase_paths.dart';
import '../../../core/services/firebase_service.dart';

class CategoryRepository {
  final _db = FirebaseService.I.db;

  Stream<List<CategoryModel>> watch() => _db
      .collection(FirebasePaths.categories)
      .orderBy(FieldPath.documentId)
      .snapshots()
      .map((s) => s.docs
      .map((d) => CategoryModel.fromMap(d.id, d.data()))
      .toList());

  Future<void> upsert(CategoryModel m) async {
    await _db.collection(FirebasePaths.categories).doc(m.id).set(m.toMap());
  }

  /// ✅ Only updates the `active` flag (won't clobber name/imageUrl)
  Future<void> updateActive(String id, bool active) async {
    await _db.collection(FirebasePaths.categories).doc(id).update({'active': active});
  }

  Future<void> remove(String id) =>
      _db.collection(FirebasePaths.categories).doc(id).delete();
}