import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tree_com/core/layouts/no_appbar_layout.dart';
import 'package:tree_com/core/utils/api.dart';
import 'package:tree_com/core/utils/toast.dart';
import 'package:tree_com/data/models/tree_model.dart';
import 'package:tree_com/presentation/bloc/trees_bloc/trees_bloc.dart';

class StoryViewer extends StatefulWidget {
  const StoryViewer({super.key, required this.treeInfo});

  final TreeInfo treeInfo;

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late TreesBloc treesBloc;
  List<TreeVisit> visits = [];
  int index = 0;

  @override
  void initState() {
    treesBloc = context.read<TreesBloc>();
    treesBloc.add(VisitedPicsEvent(treeId: widget.treeInfo.treeId));
    treesBloc.stream.listen((event) {
      if (event is TreesVisitedPicsFailure) {
        CustomToast.showErrorToast(event.message);
      }
      if (event is TreesVisitedPicsSuccess) {
        setState(() {
          visits = event.visits;
          print(visits[visits.length - 1]);
          print(visits);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return NoAppBarLayout(
        padding: 0,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.grey],
            ),
          ),
          child: Stack(children: [
            Positioned.fill(child: BlocBuilder<TreesBloc, TreesState>(
              builder: (context, state) {
                if (state is TreesVisitedPicsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TreesVisitedPicsFailure) {
                  return Center(child: Text(state.message));
                }
                if (visits.isEmpty) {
                  return const Center(child: Text('No visits yet'));
                }
                return ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Image.network(
                      visits[index].imageUrl,
                      fit: BoxFit.cover,
                    ));
              },
            )),
            Center(
              child: Image.network(
                visits[index].imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Display the image when fully loaded
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null, // Progress indicator value
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Handle errors when image fails to load
                  return Icon(Icons.error, size: 50);
                },
              ),
            ),
            visits[index].content != null
                ? Positioned(
                    bottom: 0,
                    child: Stack(
                      children: [
                        Container(
                          width: width,
                          padding: const EdgeInsets.only(
                              bottom: 60, top: 10, left: 10, right: 10),
                          height: 200,
                          color: Colors.black.withOpacity(0.2),
                          child: SingleChildScrollView(
                            child: Text(
                              visits[index].content!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Positioned(
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          size: 30,
                          color: index <= 0 ? Colors.grey : Colors.white),
                      onPressed: () {
                        if (index > 0) {
                          setState(() {
                            index--;
                          });
                        }
                      },
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 30,
                        color: index < visits.length - 1
                            ? Colors.white
                            : Colors.grey,
                      ),
                      onPressed: () {
                        if (index < visits.length - 1) {
                          setState(() {
                            index++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top + 10,
                      left: 10,
                      bottom: 20),
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                width: 48,
                                height: 48,
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.5),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2,
                                left: 2,
                                width: 44,
                                height: 44,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    API.getImageUrl(widget.treeInfo.imageUrl),
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(widget.treeInfo.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text("Visited ${visits.length} times",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                )),
            Positioned(
                bottom: 10,
                right: 10,
                child: Text(
                    "Visited on ${DateFormat('hh:mm a dd MMMM yyyy').format(visits[index].time)}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400))),
          ]),
        ));
  }
}
