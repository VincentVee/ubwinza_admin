import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService {
  FirebaseService._();
  static final FirebaseService I = FirebaseService._();


  final db = FirebaseFirestore.instance;
}