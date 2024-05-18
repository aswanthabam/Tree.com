import 'package:flutter/material.dart';
import 'package:tree_com/core/layouts/bottom_bar_layout.dart';
import 'package:tree_com/presentation/pages/settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BottomBarLayout(
        currentIndex: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, anim1, anim2) =>
                                    const SettingsPage(),
                                transitionsBuilder:
                                    (context, anim1, anim2, child) {
                                  return SlideTransition(
                                    position: Tween(
                                            begin: const Offset(1, 0),
                                            end: Offset.zero)
                                        .animate(anim1),
                                    child: child,
                                  );
                                }));
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ))
                ],
              ),
              const Text('Profile Page'),
            ],
          ),
        ));
  }
}
