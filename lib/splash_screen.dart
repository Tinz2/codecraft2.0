import 'dart:async';
import 'package:flutter/material.dart';
import 'signin_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // ทำให้ภาพค่อยๆ ปรากฏ
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // รอ 5 วินาที แล้วไปหน้า Login
    Future.delayed(Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/icons/bgsplash.png",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // พื้นหลังจาง ๆ
          ),
          Center(
            child: AnimatedOpacity(
              duration: Duration(seconds: 5),
              opacity: _opacity,
              child: Image.asset(
                "assets/icons/splash.gif", // ใช้รูปจาก assets
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 