import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/fare_model.dart';
import '../../../core/services/firebase_paths.dart';
import '../../../core/services/firebase_service.dart';

class FareRepository {
  final _db = FirebaseService.I.db;

  Stream<List<FareModel>> watch() {
    return _db
        .collection(FirebasePaths.fares)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FareModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<FareModel?> getByRideType(String rideType) async {
    final snapshot = await _db
        .collection(FirebasePaths.fares)
        .where('rideType', isEqualTo: rideType)
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) return null;
    
    return FareModel.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
  }

  Future<void> create(FareModel model) async {
    await _db.collection(FirebasePaths.fares).doc(model.id).set(model.toMap());
  }

  Future<void> update(String id, Map<String, dynamic> updates) async {
    await _db.collection(FirebasePaths.fares).doc(id).update(updates);
  }

  Future<void> updatePrice(String id, double newPrice) async {
    await _db.collection(FirebasePaths.fares).doc(id).update({
      'pricePerKilometer': newPrice,
    });
  }

  Future<void> remove(String id) async {
    await _db.collection(FirebasePaths.fares).doc(id).delete();
  }
}