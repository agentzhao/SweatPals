/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

/// Authenticate User Class
@immutable
class AuthUser {
  /// Text for UID
  final String uid;
  /// Text for Username
  final String? username;
  /// Text For Email Address
  final String? email;
  /// Check Email Verify Status
  final bool isEmailVerified;
  /// Text for Photo URL
  final String? photoURL;
  /// Contrustor
  const AuthUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.isEmailVerified,
    required this.photoURL,
  });
  /// Convert User object to AuthUser object
  factory AuthUser.fromFirebase(User user) => AuthUser(
        uid: user.uid,
        username: user.displayName,
        email: user.email,
        isEmailVerified: user.emailVerified,
        photoURL: user.photoURL,
      );
}
