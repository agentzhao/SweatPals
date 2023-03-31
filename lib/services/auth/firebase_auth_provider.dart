/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:sweatpals/firebase_options.dart';
import 'package:sweatpals/services/auth/auth_user.dart';
import 'package:sweatpals/services/auth/auth_provider.dart';
import 'package:sweatpals/services/auth/auth_exceptions.dart';

/// Firebase Authenticator Provider class
class FirebaseAuthProvider implements AuthProvider {
  /// Default Profile Img URL
  String defaultProfileImg =
      "https://pngimg.com/uploads/github/github_PNG80.png";

  /// Initalise Firebase app
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      name: "dev project",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  /// Create Users
  @override
  Future<AuthUser> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      await updateDisplayName(username);
      await updatePhotoURL(defaultProfileImg);

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  /// Retrieve Current User Authenticate Status
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }
  /// Login 
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  /// Logout
  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
  /// Send Email Verification 
  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
  /// Login Annonymously
  @override
  Future<AuthUser> logInAnon({
    required String username,
  }) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      final user = currentUser;
      await updateDisplayName(username);
      await updatePhotoURL(defaultProfileImg);

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  /// Update Display Name
  @override
  Future<void> updateDisplayName(String username) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(username);
    } else {
      throw DisplayNameNotUpdatedException();
    }
  }
  /// Update User Photo URL
  @override
  Future<void> updatePhotoURL(String photoURL) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoURL);
    } else {
      throw PhotoNotUpdatedException();
    }
  }
}
