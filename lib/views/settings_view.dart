/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5

import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';

/// Setting Page
class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  SettingsViewState createState() => SettingsViewState();
}
/// Setting Page Background
class SettingsViewState extends State<SettingsView> {
  /// Username 
  String get username => AuthService.firebase().currentUser!.username!;
  // email might be null
  /// Email Address
  String get email =>
      AuthService.firebase().currentUser!.email ?? 'guest (no email)';

  // todo: reset password and change email
  /// Process for Setting Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if email is empty, use username
            Text("Logged in as ${email.isEmpty ? username : email}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.loginRoute,
                    (_) => false,
                  );
                }
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
