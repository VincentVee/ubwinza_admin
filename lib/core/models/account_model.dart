class AccountModel {
  final String id; // uid
  final String name;
  final String email;
  final String role; // user | seller | rider
  final String status; // approved | pending | blocked | deactivated


  AccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
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
    );
  }
}
