import 'package:codecraft2/auth.dart';
import 'package:codecraft2/home_page.dart';
import 'package:codecraft2/profilesetup.dart';
import 'package:codecraft2/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

// Class MyApp ส าหรับการแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  MyApp({super.key});
// ตรวจสอบ AuthService
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      home: StreamBuilder(
        stream: _auth.authStateChanges, // ตรวจสอบการเชื่อมต่อ Stream
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return HomePage(); // ตรวจสอบว่ามี HomePage และท างานได้
          } else {
            return const LoginPage(); // ตรวจสอบว่ามี LoginPage และท างานได้
          }
        },
      ),
      routes: {
        LoginPage.routeName: (BuildContext context) => const LoginPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        profilesetup.routeName: (BuildContext context) => profilesetup(),
      },
    );
  }
}