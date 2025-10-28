import '../../../core/models/banner_model.dart';
import '../../../core/services/firebase_paths.dart';
import '../../../core/services/firebase_service.dart';


class BannerRepository {
  final _db = FirebaseService.I.db;


  Stream<List<BannerModel>> watch() {
    return _db
        .collection(FirebasePaths.banners)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
        .map((d) => BannerModel.fromMap(d.id, d.data()))
        .toList());
  }


  Future<void> create(BannerModel model) async {
    await _db.collection(FirebasePaths.banners).doc(model.id).set(model.toMap());
  }


  Future<void> toggleActive(String id, bool active) async {
    await _db.collection(FirebasePaths.banners).doc(id).update({'active': active});
  }


  Future<void> remove(String id) async {
    await _db.collection(FirebasePaths.banners).doc(id).delete();
  }
}