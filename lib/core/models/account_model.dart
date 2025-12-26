import 'package:flutter/material.dart';

class AccountModel {
  final String id; // uid
  final String name;
  final String email;
  final String role; // user | seller | rider
  final String status; // approved | pending | blocked | deactivated
  final String? imageUrl; // <--- Corrected property name

  AccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.imageUrl, // <--- Corrected name in constructor
  });

  bool get isApproved => status == 'approved';
  bool get isBlocked => status == 'blocked' || status == 'deactivated';

  factory AccountModel.fromMap(String id, String role, Map<String, dynamic> map) {
    final st = (map['status'] as String?)?.toLowerCase() ?? 'pending';

    return AccountModel(
      id: id,
      name: (map['name'] ?? map['fullName'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      role: role,
      status: st,
      // <--- CORRECTED: Now uses the 'imageUrl' field from the database map
      imageUrl: (map['imageUrl']) as String?,
    );
  }
}