import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String get username => AuthService.firebase().currentUser!.username!;

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
            Text('Logged in as $username'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
