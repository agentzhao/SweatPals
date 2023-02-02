import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';

import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/views/login_view.dart';
import 'package:sweatpals/views/register_view.dart';
import 'package:sweatpals/views/verify_email_view.dart';
import 'package:sweatpals/views/navi_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // have to initialize firebase before running the app
  await AuthService.firebase().initialize();
  runApp(
    MaterialApp(
      title: 'SweatPals',
      theme: ThemeData(
        // #079A4B
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        primaryColor: Colors.greenAccent[400],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        primaryColor: Colors.greenAccent[400],
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        naviBarRoute: (context) => const NaviBar(),
        // homeRoute: (context) => const HomeView(),
        // mapRoute: (context) => const MapView(),
        // profileRoute: (context) => const ProfileView(),
      },
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                // main page
                return const NaviBar();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
