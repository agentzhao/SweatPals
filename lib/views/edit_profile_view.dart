import 'package:flutter/material.dart';
import 'package:sweatpals/services/auth/auth_service.dart';
import 'package:sweatpals/components/text_field_widget.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final String _uid;
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final bool _isUserVerified;
  late final TextEditingController _photoUrl;

  String get uid => AuthService.firebase().currentUser!.uid;
  String get username => AuthService.firebase().currentUser!.username!;
  String get email =>
      AuthService.firebase().currentUser?.email ?? "no email (guest)";
  bool get isUserVerified =>
      AuthService.firebase().currentUser!.isEmailVerified;
  // String get photoUrl => AuthService.firebase().currentUser!.photoUrl!;

  @override
  void initState() {
    _uid = uid;
    _username = TextEditingController(text: username);
    _email = TextEditingController(text: email);
    _isUserVerified = isUserVerified;
    // _photoUrl = TextEditingController(text: photoUrl);
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    // _photoUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32),
        children: [
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Username',
            text: _username.text,
            onChanged: (name) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: _email.text,
            onChanged: (email) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'About',
            text: "I'm a software engineer and I love to workout",
            maxLines: 5,
            onChanged: (about) {},
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthService.firebase().updateDisplayName(
                  _username.text,
                );
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Update'),
          ),
          // todo: reset password
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: Text(
              _isUserVerified ? 'Verified' : 'Not Verified',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: Text(
              'UID: $_uid',
            ),
          ),
        ],
      ),
    );
  }
}
