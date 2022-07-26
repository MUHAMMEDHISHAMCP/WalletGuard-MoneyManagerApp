import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_manager/home_screen.dart';
import 'package:money_manager/on_boarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
        Timer(const Duration(seconds: 3), () => userEntered(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,
body: Center(child: Image(image: AssetImage('assets/mainlogo.png'),)
     ) );
  }
   userEntered(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final userEntered = await pref.getString('savedValue');
    if (userEntered == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => OnBoardScreen())));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => HomeScreen())));
    }
  }
}