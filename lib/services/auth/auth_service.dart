/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:sweatpals/services/auth/auth_provider.dart';
import 'package:sweatpals/services/auth/auth_user.dart';
import 'package:sweatpals/services/auth/firebase_auth_provider.dart';

/// Authenticate Service Class
class AuthService implements AuthProvider {
  /// Initalise Authenticate Provider Class
  final AuthProvider provider;

  /// Contrustor
  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  /// Create User
  @override
  Future<AuthUser> createUser({
    required String username,
    required String email,
    required String password,
  }) =>
      provider.createUser(
        username: username,
        email: email,
        password: password,
      );

  /// Retrieve Current User Authenticate Info
  @override
  AuthUser? get currentUser => provider.currentUser;

  /// Login
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  /// Logout
  @override
  Future<void> logOut() => provider.logOut();

  /// Send Email Verification to User email
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
  /// Initialise Authenticator Provider
  @override
  Future<void> initialize() => provider.initialize();
  /// Log in annonmyously
  @override
  Future<AuthUser> logInAnon({
    required String username,
  }) =>
      provider.logInAnon(
        username: username,
      );
  /// Update Display User Name 
  @override
  Future<void> updateDisplayName(String username) async {
    return await provider.updateDisplayName(username);
  }
  /// Update User Photo URL 
  @override
  Future<void> updatePhotoURL(String photoURL) async {
    return await provider.updatePhotoURL(photoURL);
  }

  // todo save user to database
  // Future<void> saveUserInfo() async {
  //   return await provider.saveUserInfo(username, email);
  // }
}
