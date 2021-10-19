# FangApp

A flutter app to read mangas.
Back managed with Python3 and Firebase.

## Getting Started

### Flutter/ DART
1) add configuration for main.dart

2) Android Studio => preferences => Languages and Frameworks => Dart
   => specify Dart path (ex: /Users/you/development/flutter/bin/cache/dart-sdk)
   => enable it for the project
   
### Python3
1) Android Studio => Tools => Sync Python Requirements...

2) Select Python3 module

### Firebase

1) Get the google-services.json from Firebase console and put it into
   'android/app/'

2) Get the GoogleService-Info.plist from Firebase console and put it into
   'ios/Runner/'
   
3) Open python file python/back_manager.py and follow SETUP instruction

# Android signing

```
/Applications/Android\ Studio.app/Contents/jre/Contents/Home/bin/keytool -genkeypair -v -keyalg RSA -keysize 2048 -validity 10000 -keystore YOUR_KS.keystore -storepass KS_PASSWORD -alias ALIAS
```

you can find your java path with the command

```
flutter doctor -v
```