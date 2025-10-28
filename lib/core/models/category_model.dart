import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final bool active;


  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.active,
  });


  Map<String, dynamic> toMap() => {
    'name': name,
    'imageUrl': imageUrl,
    'active': active,
  };


  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) =>
      CategoryModel(
        id: id,
        name: (map['name'] ?? '') as String,
        imageUrl: map['imageUrl'] as String?,
        active: (map['active'] as bool?) ?? true,
      );
}