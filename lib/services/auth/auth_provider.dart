/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:sweatpals/services/auth/auth_user.dart';
/// Abstract Authenticator Provider Class
abstract class AuthProvider {
  Future<void> initialize();
  /// Login
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  /// Retrieve Current User Authenticate Info
  AuthUser? get currentUser;
  /// Create User
  Future<AuthUser> createUser({
    required String username,
    required String email,
    required String password,
  });
  /// Logout
  Future<void> logOut();
  /// Send Email Verification
  Future<void> sendEmailVerification();
  /// Login Anonymous
  Future<AuthUser> logInAnon({
    required String username,
  });
  /// Update Display Name
  Future<void> updateDisplayName(String username);
  /// Update Photo URL
  Future<void> updatePhotoURL(String photoURL);
}
