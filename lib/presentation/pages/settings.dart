import 'package:flutter/material.dart';
import 'package:tree_com/core/layouts/back_bar_layout.dart';
import 'package:tree_com/core/utils/preferences.dart';
import 'package:tree_com/core/widgets/action_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BackBarLayout(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(fontSize: 18),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                AppPreferences.setAccessToken(null);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'login', (route) => false);
                              },
                              child: const Text(
                                'Yes, Logout',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            )
                          ],
                        ));
              },
              text: "Logout",
              iconColor: Colors.red,
              textColor: Colors.red,
              leftIcon: Icons.logout,
              rightIcon: Icons.arrow_forward_ios)
        ],
      ),
    ));
  }
}
