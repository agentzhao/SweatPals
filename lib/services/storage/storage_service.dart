import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageService {
  final storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImage(String uid, File image) async {
    final uploadTask = storageRef.child("profileImg/$uid.jpg").putFile(image);
    final snapshot = await uploadTask;
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> changeProfileImage(
    String uid,
  ) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // maxHeight: 200,
      // maxWidth: 200,
    );
    if (image != null) {
      return uploadImage(
        uid,
        File(image.path),
      );
    }
    return "";
  }

  Future<String> getProfileImage(String uid) async {
    final url = await storageRef.child("profileImg/$uid.jpg").getDownloadURL();
    return url;
  }
}
