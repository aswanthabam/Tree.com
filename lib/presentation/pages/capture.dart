import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tree_com/core/layouts/back_bar_layout.dart';
import 'package:tree_com/core/layouts/bottom_bar_layout.dart';
import 'package:tree_com/core/utils/toast.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool captured = false;
  int treeCount = 4;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Future<bool> _capture() async {
    XFile? file = await controller?.takePicture();
    await controller?.pausePreview();
    if (file == null) {
      return false;
    }
    print("=======================");
    setState(() {
      captured = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BottomBarLayout(
        currentIndex: 1,
        child: controller == null
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text("Capture Photo",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0D7194))),
                      SizedBox(height: (height - width * 1.45) / 2 - 40),
                      Center(
                        child: SizedBox(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: SizedOverflowBox(
                                    size: Size(width * 0.9, width * 0.9),
                                    alignment: Alignment.center,
                                    child: CameraPreview(controller!)))),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                          onPressed: () async {
                            if (captured) {
                              controller?.resumePreview();
                              setState(() {
                                captured = false;
                              });
                              return;
                            }
                            bool sts = await _capture();
                            if (sts) {
                              // Navigator.pushNamed(context, 'home');
                            } else {
                              CustomToast.showErrorToast(
                                  "Unable to capture image!");
                            }
                          },
                          icon: Icon(
                            captured
                                ? BootstrapIcons.arrow_counterclockwise
                                : Icons.camera,
                            size: 50,
                            color: Color(0xff0D7194),
                          )),
                      captured
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: width,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      BootstrapIcons.chevron_double_up,
                                      size: 20,
                                    ))),
                                Container(
                                  width: width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        "Existing trees in this location",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: width,
                                        height:
                                            (treeCount > 3 ? 3 : treeCount) *
                                                120.0,
                                        child: ListView.builder(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            scrollDirection: Axis.vertical,
                                            itemCount: treeCount,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ));
  }
}
