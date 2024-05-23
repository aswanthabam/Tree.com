import 'package:flutter/material.dart';

class BottomBarLayout extends StatefulWidget {
  const BottomBarLayout(
      {super.key, required this.child, this.currentIndex = 0});

  final Widget child;
  final int currentIndex;

  @override
  State<BottomBarLayout> createState() => _BottomBarLayoutState();
}

class _BottomBarLayoutState extends State<BottomBarLayout> {
  int currentIndex = 0;

  @override
  void initState() {
    setState(() {
      currentIndex = widget.currentIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            if (index != 2) {
              currentIndex = index;
            }
          });
          if (index == 0) {
            Navigator.pushReplacementNamed(context, 'home');
          } else if (index == 1) {
            Navigator.pushNamed(context, 'capture');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, 'profile');
          }
        },
        currentIndex: currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Capture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xff009E76),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: widget.child,
      ),
    );
  }
}
