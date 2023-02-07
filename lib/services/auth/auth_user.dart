import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String uid;
  final String? username;
  final String? email;
  final bool isEmailVerified;
  final String? photoUrl;

  const AuthUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.isEmailVerified,
    required this.photoUrl,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        uid: user.uid,
        username: user.displayName,
        email: user.email,
        isEmailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
}
