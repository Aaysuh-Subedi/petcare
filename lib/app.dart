import 'package:flutter/material.dart';
import 'package:petcare/Screens/Splash_screen.dart';
<<<<<<< HEAD
import 'package:petcare/Screens/onboarding_screen.dart';
import 'package:petcare/screens/dashboard.dart';
import 'package:petcare/theme/theme_data.dart';
=======
// import 'package:petcare/Screens/onboarding_screen.dart';
// import 'package:petcare/screens/dashboard.dart';
>>>>>>> 2d69da723cf1a625f9a13d728b764729b9cb0266

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PawCare',
      theme: getApplicationTheme(),
      home: const SplashScreen(),
    );
  }
}
