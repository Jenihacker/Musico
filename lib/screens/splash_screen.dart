import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musico/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF242424),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('assets/images/splash_screen.png')),
      )),
    );
  }
}
