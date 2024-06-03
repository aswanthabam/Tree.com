import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_com/core/layouts/back_bar_layout.dart';
import 'package:tree_com/core/utils/toast.dart';
import 'package:tree_com/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:tree_com/presentation/pages/capture_widget.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final contentController = TextEditingController();
  File? imageFile;
  late PostsBloc postsBloc;

  @override
  void initState() {
    postsBloc = context.read<PostsBloc>();
    super.initState();
    postsBloc.stream.listen((event) {
      if (event is PostsLoading) {
        if (mounted) Navigator.of(context).pop();
      }
      if (event is PostAdded) {
        CustomToast.hideLoadingToast(context);
        CustomToast.showSuccessToast("Post added successfully");
        postsBloc.add(GetPostsEvent(null));
      }
      if (event is PostAddError) {
        CustomToast.hideLoadingToast(context);
        CustomToast.showErrorToast(event.message);
      }
      if (event is PostAdding) {
        CustomToast.hideLoadingToast(context);
        CustomToast.showLoadingToast(context, "Adding post");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BackBarLayout(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CaptureWidget(
                          title: "Take a picture",
                          onCapture: (file, location) async {
                            setState(() {
                              imageFile = file;
                            });
                            Navigator.of(context).pop();
                            return true;
                          },
                          location: false,
                        )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Capture Photo",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.camera),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              child: TextField(
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                onTapOutside: (e) {
                  FocusScope.of(context).unfocus();
                },
                controller: contentController,
                decoration: InputDecoration(
                    hintText: "Write your thoughts here ...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (imageFile != null)
              Container(
                  height: 200,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Positioned(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                imageFile = null;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black,
                            )),
                        right: 0,
                        top: 0,
                      )
                    ],
                  )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (contentController.text.isEmpty && imageFile == null) {
                    CustomToast.showErrorToast("Please add content or image");
                    return;
                  }
                  postsBloc
                      .add(AddPostEvent(imageFile, contentController.text));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                    width: width,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('Post',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                      ],
                    ))),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
