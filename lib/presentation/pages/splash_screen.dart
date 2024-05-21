import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tree_com/core/layouts/no_appbar_layout.dart';
import 'package:tree_com/core/utils/api.dart';
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
    await Future.delayed(const Duration(seconds: 1));
    if (!await Permission.location.status.isGranted) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Location Permission'),
                content: const Text(
                    'This app requires location permission to work properly'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'))
                ],
              )).then((value) {
        Permission.location.request();
      });
    }
    if (accessToken != null) {
      API.fetchAccessToken();
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
