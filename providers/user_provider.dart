import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/models/user.dart' as model;
import 'package:project_chat/services/firebase_services.dart';

final userProvider = ChangeNotifierProvider((ref) => UserProvider());

final getUserDataProvider =
    FutureProvider((ref) => ref.read(userProvider).getUserData());

class UserProvider extends ChangeNotifier {
  model.User? _user;

  model.User? get user => _user;

  Future<void> getUserData() async {
    final _auth = FirebaseAuth.instance;

    await FirebaseService.accounts
        .doc(_auth.currentUser?.uid)
        .get()
        .then((value) {
      _user = model.User.fromJson(value.data()!);
    });
  }
}
