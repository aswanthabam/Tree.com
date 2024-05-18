import 'package:flutter/material.dart';
import 'package:tree_com/core/layouts/no_appbar_layout.dart';
import 'package:tree_com/core/utils/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialize(context);
  }

  void initialize(context) async {
    String? accessToken = await AppPreferences.accessToken;
    print(accessToken);
    await Future.delayed(const Duration(seconds: 1));
    if (accessToken != null) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, 'register');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return NoAppBarLayout(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/banner.png',
            width: width * 0.5,
          ),
        ],
      ),
    ));
  }
}
