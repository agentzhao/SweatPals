# SweatPals

Social workout app for SC2006 AY22/23 Sem 2. Handled the coding while my teammates wrote the documentations

![SweatPals](https://user-images.githubusercontent.com/20024592/230425908-805d7fcf-f5f5-4414-81d3-c5e300d27424.png)

### Todo

- [ ] Favicons and splash screen
- [ ] Rewrite chat with [firebase cloud messaging](https://firebase.google.com/docs/cloud-messaging/)
- [ ] Use google_maps_flutter_web to support web

### Setup Environment

- Make sure you have [flutter](https://docs.flutter.dev/get-started/install) installed
- Use an [emulator](https://developer.android.com/studio/index.html#command-tools) or mirror your android phone using [scrcpy](https://github.com/Genymobile/scrcpy)

```
git clone https://github.com/agentzhao/SweatPals.git
flutter pub get
```

Create project on firebase and use [flutterfire](https://firebase.flutter.dev/docs/cli/) to generate `firebase_options.dart`

### Building for production

```
flutter build web
firebase deploy

flutter build apk --split-per-abi

dart doc .
```

### Directories

- code under /lib
- docs under /doc/api/index.html
- apk files under /build/app/outputs/flutter-apk

### Research

- https://pub.dev/packages/location/
- https://pub.dev/packages/geolocator/
- https://pub.dev/packages/swipeable_card_stack

### Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Docs](https://docs.flutter.dev/)
