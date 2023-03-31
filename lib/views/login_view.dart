/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/services/auth/auth_exceptions.dart';
import 'package:sweatpals/utilities/show_error_dialog.dart';
import 'package:sweatpals/services/map/location.dart';

/// Login Page
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}
/// Login Page Background
class _LoginViewState extends State<LoginView> {
  /// Text Box Controller for Email Address
  late final TextEditingController _email;
  /// Text Box Controller for Password
  late final TextEditingController _password;
  /// Inital State
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    getLocationPermission();
  }
  /// Exit State
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }
  /// Process for Login Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        // todo: add app logo
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: TextFormField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: TextFormField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user's email is verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.naviBarRoute,
                      (route) => false,
                    );
                  }
                } else {
                  // user's email is NOT verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.verifyEmailRoute,
                      (route) => false,
                    );
                  }
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong credentials',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
