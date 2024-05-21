import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tree_com/core/layouts/bottom_bar_layout.dart';
import 'package:tree_com/core/utils/encryption.dart';
import 'package:tree_com/core/utils/toast.dart';
import 'package:tree_com/data/models/tree_model.dart';
import 'package:tree_com/presentation/bloc/trees_bloc/trees_bloc.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  late TreesBloc treesBloc;
  List<NearbyTree> treesNearby = [];
  bool captured = false;
  int treeCount = 2;
  Position? currentLocation;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? image;

  @override
  void initState() {
    super.initState();
    treesBloc = context.read<TreesBloc>();
    _initCamera();
    treesBloc.stream.listen((event) {
      if (event is TreesAddSuccess) {
        CustomToast.hideLoadingToast(context);
        CustomToast.showSuccessToast("Tree added successfully!");
      }
      if (event is TreesAddFailure) {
        CustomToast.hideLoadingToast(context);
        CustomToast.showErrorToast(event.message);
      }

      if (event is TreesAddLoading) {
        CustomToast.showLoadingToast(context, "Adding tree...");
      }
    });
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
            CustomToast.showErrorToast(
                "We can't continue without camera access");
            break;
          default:
            CustomToast.showErrorToast("An error occurred :(");
            break;
        }
      }
    });
  }

  Future<Position?> _getCurrentLocation() async {
    currentLocation = await Geolocator.getCurrentPosition();
    setState(() {});
    return currentLocation;
  }

  Future<void> _setupLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomToast.showErrorToast("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomToast.showErrorToast("Location permissions are denied");
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      CustomToast.showErrorToast(
          "Location permissions are permanently denied, please grant the permissions from settings.");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Future.value();
  }

  double _calculateDistance(NearbyTree tree, Position pos) {
    double distance = Geolocator.distanceBetween(
        pos.latitude, pos.longitude, tree.latitude, tree.longitude);
    tree.distance = distance;
    return distance;
  }

  Future<bool> _capture() async {
    XFile? file = await controller?.takePicture();
    await controller?.pausePreview();
    Position? pos = await _getCurrentLocation();
    if (pos == null) {
      CustomToast.showErrorToast("Unable to get current location!");
      return false;
    }
    double lat = pos.latitude;
    double lon = pos.longitude;
    treesBloc.add(GetNearbyTreesEvent(latitude: lat, longitude: lon));
    if (file == null) {
      return false;
    }
    file.saveTo("${(await getTemporaryDirectory()).path}/temp.jpg");
    image = File("${(await getTemporaryDirectory()).path}/temp.jpg");
    print(image);
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
        child: FutureBuilder(
          future: _setupLocationService(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              return controller == null
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
                                  color: const Color(0xff0D7194),
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
                                              height: (treeCount > 3
                                                      ? 3
                                                      : treeCount) *
                                                  120.0,
                                              child: BlocBuilder<TreesBloc,
                                                  TreesState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is TreesGetNearbyLoading) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                  if (state
                                                      is TreesGetNearbyFailure) {
                                                    return Center(
                                                        child: Text(
                                                            state.message));
                                                  }
                                                  if (state
                                                      is TreesGetNearbySuccess) {
                                                    treeCount =
                                                        state.trees.length;
                                                    treesNearby = state.trees;
                                                    if (currentLocation ==
                                                        null) {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                    for (var element
                                                        in treesNearby) {
                                                      _calculateDistance(
                                                          element,
                                                          currentLocation!);
                                                    }
                                                    return ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: treeCount,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            width: 100,
                                                            height: 100,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .grey),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        treesNearby[index]
                                                                            .title,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      Text(
                                                                        treesNearby[index].description ??
                                                                            "",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      Text(
                                                                        treesNearby[index]
                                                                            .addedBy
                                                                            .name,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          "${treesNearby[index].distance.toStringAsFixed(2)} m",
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600)),
                                                                    ],
                                                                  )
                                                                ]),
                                                          );
                                                        });
                                                  }
                                                  return const Text(
                                                      "Hu Huuu! You are awesome, you found out an ultra rare error!");
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  "Add a new tree"),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  image == null
                                                                      ? const SizedBox()
                                                                      : Image
                                                                          .file(
                                                                          image!,
                                                                          height:
                                                                              200,
                                                                        ),
                                                                  TextField(
                                                                    controller:
                                                                        titleController,
                                                                    decoration: const InputDecoration(
                                                                        hintText:
                                                                            "Title"),
                                                                  ),
                                                                  TextField(
                                                                    controller:
                                                                        descriptionController,
                                                                    decoration: const InputDecoration(
                                                                        hintText:
                                                                            "Description"),
                                                                  ),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        treesBloc.add(AddTreeEvent(
                                                                            image:
                                                                                image!,
                                                                            title:
                                                                                titleController.text,
                                                                            description: descriptionController.text,
                                                                            latitude: currentLocation!.latitude,
                                                                            longitude: currentLocation!.longitude));
                                                                      },
                                                                      child: const Text(
                                                                          "Add"))
                                                                ],
                                                              ),
                                                            ));
                                              },
                                              child: Container(
                                                width: width,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff0D7194),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                  child: Text(
                                                    "Add a new tree",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
