import 'package:flutter/material.dart';
import 'package:tree_com/core/layouts/bottom_bar_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const BottomBarLayout(
        currentIndex: 0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Home Page'),
            ],
          ),
        ));
  }
}
