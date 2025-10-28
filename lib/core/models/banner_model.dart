import 'package:flutter/material.dart';

class BannerModel {
  final String id;
  final String imageUrl;
  final String? targetCategoryId;
  final bool active;
  final DateTime createdAt;


  BannerModel({
    required this.id,
    required this.imageUrl,
    this.targetCategoryId,
    required this.active,
    required this.createdAt,
  });


  Map<String, dynamic> toMap() => {
    'imageUrl': imageUrl,
    'targetCategoryId': targetCategoryId,
    'active': active,
    'createdAt': createdAt,
  };


  factory BannerModel.fromMap(String id, Map<String, dynamic> map) =>
      BannerModel(
        id: id,
        imageUrl: map['imageUrl'] as String,
        targetCategoryId: map['targetCategoryId'] as String?,
        active: (map['active'] as bool?) ?? true,
        createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      );
}