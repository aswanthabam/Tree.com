import 'package:flutter/material.dart';

class BackBarLayout extends StatefulWidget {
  const BackBarLayout({super.key, required this.child});

  final Widget child;

  @override
  State<BackBarLayout> createState() => _BackBarLayoutState();
}

class _BackBarLayoutState extends State<BackBarLayout> {
  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: widget.child
    );
  }
}
