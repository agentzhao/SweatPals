import 'package:flutter/material.dart';
import 'package:sweatpals/constants/routes.dart';

import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/views/login_view.dart';
import 'package:sweatpals/views/register_view.dart';
import 'package:sweatpals/views/verify_email_view.dart';
import 'package:sweatpals/views/navi_bar.dart';
import 'package:sweatpals/services/db/db_service.dart';

import 'package:sweatpals/views/home_view.dart';
import 'package:sweatpals/views/map_view.dart';
import 'package:sweatpals/views/profile_view.dart';
import 'package:sweatpals/views/settings_view.dart';
import 'package:sweatpals/views/edit_profile_view.dart';
import 'package:sweatpals/views/user_view.dart';
import 'package:sweatpals/views/gym_view.dart';

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
        Routes.loginRoute: (context) => const LoginView(),
        Routes.registerRoute: (context) => const RegisterView(),
        Routes.verifyEmailRoute: (context) => const VerifyEmailView(),
        Routes.naviBarRoute: (context) => const NaviBar(),
        Routes.homeRoute: (context) => const HomeView(),
        Routes.mapRoute: (context) => const MapView(),
        Routes.profileRoute: (context) => const ProfileView(),
        Routes.editProfileRoute: (context) => const EditProfileView(),
        Routes.settingsRoute: (context) => const SettingsView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.userRoute) {
          final args = settings.arguments as UserInfo;
          return MaterialPageRoute(
            builder: (context) => UserView(
              user: args,
            ),
          );
        }
        if (settings.name == Routes.gymRoute) {
          final args = settings.arguments as GymInfo;
          return MaterialPageRoute(
            builder: (context) => GymView(
              gym: args,
            ),
          );
        }
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
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
              // main
              return const NaviBar();
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
