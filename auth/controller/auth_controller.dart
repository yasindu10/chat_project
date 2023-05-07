import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/auth/repository/auth_repository.dart';

final authController =
    Provider((ref) => AuthController(repo: ref.watch(authRepository)));

class AuthController {
  AuthRepository repo;
  AuthController({
    required this.repo,
});

  Future<void> logIn(String email, String password, context) async {
    await repo.logIn(email, password, context);
  }

  Future<void> createUser({
    required String name,
    required String gender,
    required File image,
    required String email,
    required String password,
    required String profession,
    required String school,
    required context,
    required String bio,
  }) async {
    await repo.createUser(
      name: name,
      gender: gender,
      image: image,
      email: email,
      password: password,
      profession: profession,
      school: school,
      context: context,
      bio: bio,
    );
  }

  Future<void> signOut() async {
    await repo.signOutApp();
  }
}
