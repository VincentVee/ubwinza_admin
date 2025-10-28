import 'package:flutter/foundation.dart';
import '../../../core/models/account_model.dart';
import '../data/account_repository.dart';


class AccountsViewModel extends ChangeNotifier {
  final String role; // user | seller | rider
  final bool verified; // true = verified list, false = blocked list


  AccountsViewModel({required this.role, required this.verified});


  final repo = AccountRepository();


  late final Stream<List<AccountModel>> stream =
  repo.watch(role, verified: verified);


  Future<void> toggle(String id, {required bool makeVerified}) async {
    await repo.setStatus(role, id, makeVerified ? 'approved' : 'blocked');
  }
}