import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/account_model.dart';
import '../../../core/services/firebase_paths.dart';
import '../../../core/services/firebase_service.dart';


class AccountRepository {
  final _db = FirebaseService.I.db;


  String _colForRole(String role) {
    final r = role.toLowerCase().trim();
    if (r == 'user' || r == 'users') return FirebasePaths.users;
    if (r == 'seller' || r == 'sellers') return FirebasePaths.sellers;
    if (r == 'rider' || r == 'riders') return FirebasePaths.riders;
    return FirebasePaths.users; // fallback
  }


  /// Watch accounts by role and status bucket.
  /// - verified: status == approved
  /// - blocked: status in [blocked, deactivated]
  Stream<List<AccountModel>> watch(String role, {required bool verified}) {
    final collection = _colForRole(role);


    Query<Map<String, dynamic>> q = _db.collection(collection);
    if (verified) {
      q = q.where('status', isEqualTo: 'approved');
    } else {
      q = q.where('status', whereIn: ['blocked', 'deactivated']);
    }


    return q.snapshots().map((s) =>
        s.docs.map((d) => AccountModel.fromMap(d.id, role, d.data())).toList());
  }


  Future<void> setStatus(String role, String id, String status) async {
    final collection = _colForRole(role);
    await _db.collection(collection).doc(id).update({'status': status});
  }
}