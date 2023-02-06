import 'package:sweatpals/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  AuthUser? get currentUser;

  Future<AuthUser> createUser({
    required String username,
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<AuthUser> logInAnon({
    required String username,
  });

  // Future<void> updateDisplayName(String username);
}
