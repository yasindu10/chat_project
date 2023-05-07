import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final accounts = FirebaseFirestore.instance.collection('accounts');
  static final groups = FirebaseFirestore.instance.collection('groups');
}
