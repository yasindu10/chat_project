import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_chat/res/storage_methos.dart';
import 'package:project_chat/services/firebase_services.dart';
import 'package:project_chat/widgets/custom_alerts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/models/user.dart' as model;

final authRepository = Provider((ref) => AuthRepository());

class AuthRepository {
  final _auth = FirebaseAuth.instance;


  Future<void> logIn(String email, String password, context) async {
    try {
      final data = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorSnakbar(context, e.code);
    }
  }

  Future<void> createUser(
      {required String name,
      required String gender,
      required File image,
      required String email,
      required String password,
      required String profession,
      required String school,
      required context,
      required String bio}) async {
    if (name.isNotEmpty &&
        gender.isNotEmpty &&
        image != null &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        profession.isNotEmpty &&
        school.isNotEmpty) {
      try {
        UserCredential _userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String profilePic = await StorageMethods()
            .storeImage('accounts/$name/profile/profilePic', image);

        model.User userModel = model.User(
          bio: bio,
          gender: gender,
          profession: profession,
          profilePic: profilePic,
          school: school,
          userName: name,
          uid: _userCredential.user!.uid,
        );

        await FirebaseService.accounts
            .doc(_userCredential.user?.uid)
            .set(userModel.toJson());

        if (_userCredential.user?.emailVerified ?? false) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/verfy', (route) => false);
        }
      } on FirebaseAuthException catch (e) {
        errorSnakbar(context, e.code);
      }
    } else {
      errorSnakbar(context, 'Please fill all the fields');
    }
  }

  Future<void> signOutApp() async {
    await _auth.signOut();
  }
}
