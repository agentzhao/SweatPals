import 'package:sweatpals/services/auth/auth_provider.dart';
import 'package:sweatpals/services/auth/auth_user.dart';
import 'package:sweatpals/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

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

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> logInAnon({
    required String username,
  }) =>
      provider.logInAnon(
        username: username,
      );
}
