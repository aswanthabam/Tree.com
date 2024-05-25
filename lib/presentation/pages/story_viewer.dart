import 'package:flutter/material.dart';
import 'package:tree_com/core/layouts/no_appbar_layout.dart';

class StoryViewer extends StatefulWidget {
  const StoryViewer({super.key});

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  @override
  Widget build(BuildContext context) {
    return NoAppBarLayout(padding: 0, child: Stack(children: []));
  }
}
