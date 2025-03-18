import 'package:codecraft2/auth.dart';
import 'package:codecraft2/home_page.dart';
import 'package:codecraft2/profilesetup.dart';
import 'package:codecraft2/signin_page.dart';
import 'package:codecraft2/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'characters.dart';

//Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDm59AWhqozbbz9UP44XGC5OgBxWsIu2MQ",
            authDomain: "testfirebase-435dd.firebaseapp.com",
            databaseURL: "https://testfirebase-435dd.firebaseio.com",
            projectId: "testfirebase-435dd",
            storageBucket: "testfirebase-435dd.appspot.com",
            messagingSenderId: "311200022907",
            appId: "1:311200022907:web:f6033cd858f2f809e93dde",
            measurementId: "G-8PK39QBKV2"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Kanit',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      // home: SplashScreen(), // เริ่มจาก SplashScreen ก่อน
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        profilesetup.routeName: (context) => profilesetup(),
        CharactersPage.routeName: (context) => CharactersPage(),
      },
    );
  }
}
