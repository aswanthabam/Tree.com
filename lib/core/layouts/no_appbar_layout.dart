import 'package:flutter/material.dart';

class NoAppBarLayout extends StatefulWidget {
  const NoAppBarLayout({super.key, required this.child});

  final Widget child;

  @override
  State<NoAppBarLayout> createState() => _NoAppBarLayoutState();
}

class _NoAppBarLayoutState extends State<NoAppBarLayout> {
  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + height * 0.05),
        child: widget.child,
      ),
    );
  }
}
