import 'package:flutter/material.dart';

class FirebasePaths {
  static const banners = 'banners';
  static const categories = 'categories';
  static const users = 'users';
  static const sellers = 'sellers';
  static const riders = 'riders';
  static const String fares = 'fares';



// Storage folders
  static String bannerFile(String id) => 'banners/$id.jpg';
  static String categoryFile(String id) => 'categories/$id.jpg';

}