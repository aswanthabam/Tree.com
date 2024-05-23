import 'package:flutter/material.dart';

class NoAppBarLayout extends StatefulWidget {
  const NoAppBarLayout({super.key, required this.child, this.padding});

  final Widget child;
  final double? padding;

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
        padding: EdgeInsets.only(
            top: widget.padding == null
                ? MediaQuery.of(context).viewPadding.top + height * 0.05
                : widget.padding!),
        child: widget.child,
      ),
    );
  }
}
