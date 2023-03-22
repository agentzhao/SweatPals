import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';
import 'package:sweatpals/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  VerifyEmailViewState createState() => VerifyEmailViewState();
}

class VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              "An email with a verification link has been sent to your email address"),
          const Text(
              "Please open it and click on the link to verify your email address"),
          ElevatedButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();

              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.verifyEmailRoute,
                  (route) => false,
                );
              }
            },
            child: const Text('Send email verification'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.loginRoute,
                  (route) => false,
                );
              }
            },
            child: const Text('Login'),
          )
        ],
      ),
    );
  }
}
