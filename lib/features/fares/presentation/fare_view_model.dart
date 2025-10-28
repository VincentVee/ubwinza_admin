import 'package:flutter/foundation.dart';
import '../../../core/models/fare_model.dart';
import '../data/fare_repository.dart';

class FareViewModel extends ChangeNotifier {
  final FareRepository repo = FareRepository();
  late final Stream<List<FareModel>> stream = repo.watch();

  bool busy = false;
  String? error;

  Future<void> createFare({
    required String rideType,
    required double pricePerKilometer,
  }) async {
    try {
      busy = true;
      error = null;
      notifyListeners();

      // Check if fare for this ride type already exists
      final existingFare = await repo.getByRideType(rideType);
      if (existingFare != null) {
        error = 'Fare for $rideType already exists';
        return;
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final model = FareModel(
        id: id,
        rideType: rideType,
        pricePerKilometer: pricePerKilometer,
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

  Future<void> updatePrice(String id, double newPrice) async {
    try {
      busy = true;
      error = null;
      notifyListeners();

      await repo.updatePrice(id, newPrice);
    } catch (e) {
      error = e.toString();
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> remove(String id) => repo.remove(id);

  void clearError() {
    error = null;
    notifyListeners();
  }
}