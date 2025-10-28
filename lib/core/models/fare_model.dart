import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class FareModel {
  final String id;
  final String rideType;
  final double pricePerKilometer;
  final DateTime createdAt;

  FareModel({
    required this.id,
    required this.rideType,
    required this.pricePerKilometer,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'rideType': rideType,
        'pricePerKilometer': pricePerKilometer,
        'createdAt': createdAt,
      };

  factory FareModel.fromMap(String id, Map<String, dynamic> map) => FareModel(
        id: id,
        rideType: map['rideType'] as String,
        pricePerKilometer: (map['pricePerKilometer'] as num).toDouble(),
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      );

  FareModel copyWith({
    String? id,
    String? rideType,
    double? pricePerKilometer,
    DateTime? createdAt,
  }) {
    return FareModel(
      id: id ?? this.id,
      rideType: rideType ?? this.rideType,
      pricePerKilometer: pricePerKilometer ?? this.pricePerKilometer,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}