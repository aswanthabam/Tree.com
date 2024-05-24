import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tree_com/core/layouts/no_appbar_layout.dart';
import 'package:tree_com/core/utils/api.dart';
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
  bool capturing = false;
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    treesBloc = context.read<TreesBloc>();
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

      if (event is TreesGetNearbyLoading) {
        showModalBottomSheet(
            showDragHandle: true,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return _getNearbyDialogSheet(context);
            }).then((value) {
          controller?.resumePreview();
          setState(() {
            captured = false;
          });
        });
      }
      if (event is TreesGetNearbySuccess) {}
    });
    _future = _setupServices();
  }

  Widget _getAddTreeDialogSheet(context) {
    final double width = MediaQuery.of(context).size.width;
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 200,
            child: SingleChildScrollView(
              controller: scrollController,
              clipBehavior: Clip.none,
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add a new tree",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "Title",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image!,
                            height: 200,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (titleController.text.isEmpty) {
                          CustomToast.showErrorToast("Title is required!");
                          return;
                        }
                        if (descriptionController.text.isEmpty) {
                          CustomToast.showErrorToast(
                              "Description is required!");
                          return;
                        }
                        if (image == null) {
                          CustomToast.showErrorToast("Image is required!");
                          return;
                        }
                        treesBloc.add(AddTreeEvent(
                            title: titleController.text,
                            description: descriptionController.text,
                            image: image!,
                            latitude: currentLocation!.latitude,
                            longitude: currentLocation!.longitude));
                      },
                      child: Container(
                        width: width,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xff0D7194),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Add Tree",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _getNearbyDialogSheet(context) {
    final double width = MediaQuery.of(context).size.width;
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 400,
            child: SingleChildScrollView(
              controller: scrollController,
              clipBehavior: Clip.none,
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            showDragHandle: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) =>
                                _getAddTreeDialogSheet(context));
                      },
                      child: Container(
                        width: width,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xff0D7194),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Add a new tree",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Existing trees in this location",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<TreesBloc, TreesState>(
                      builder: (context, state) {
                        if (state is TreesGetNearbyLoading) {
                          return Container(
                            height: 350,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400]!,
                              highlightColor: Colors.grey[500]!,
                              child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Container(
                                      height: 100,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                        if (state is TreesGetNearbyFailure) {
                          return Center(child: Text(state.message));
                        }
                        if (state is TreesGetNearbySuccess) {
                          treeCount = state.trees.length;
                          treesNearby = state.trees;
                          if (currentLocation == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          for (var element in treesNearby) {
                            _calculateDistance(element, currentLocation!);
                          }
                          return Column(
                              children: treesNearby.map((tree) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 100,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: Image.network(
                                        API.getImageUrl(tree.imgUrl),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          tree.title,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        tree.description == null
                                            ? const SizedBox()
                                            : Text(
                                                tree.description ?? "",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                        Text(
                                          "Added By ${tree.addedBy.name}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "${tree.distance.toStringAsFixed(2)} m",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.greenAccent,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    )
                                  ]),
                            );
                          }).toList());
                        }
                        return const Text(
                            "Hu Huuu! You are awesome, you found out an ultra rare error!");
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    controller =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    await controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) async {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            CustomToast.showErrorToast(
                "We can't continue without camera access");
            if (await Permission.camera.status.isPermanentlyDenied) {
              throw CameraPermissionDeniedForeverException(
                  'Camera access is permanently denied', () async {
                await Geolocator.openAppSettings();
                _future = _setupServices();
                setState(() {});
              });
            } else {
              throw CameraPermissionDeniedException('Camera access is denied',
                  () async {
                _future = _setupServices();
                setState(() {});
              });
            }
          default:
            print(e.code);
            CustomToast.showErrorToast("An error occurred :(");
            break;
        }
      }
    });
  }

  Future<Position?> _getCurrentLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {});
    return currentLocation;
  }

  Future<void> _setupServices() async {
    await _initCamera().catchError((e) {
      return Future.error(e);
    });
    return await _setupLocationService();
  }

  Future<void> _setupLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomToast.showErrorToast("Location services are disabled.");
      return Future.error(
          LocationServiceDisabledException('Location services are disabled.'));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomToast.showErrorToast("Location permissions are denied");
        return Future.error(LocationPermissionDeniedException(
            'Location permissions are denied', () {
          setState(() {
            _future = _setupLocationService();
          });
        }));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      CustomToast.showErrorToast(
          "Location permissions are permanently denied, please grant the permissions from settings.");
      return Future.error(LocationPermissionDeniedForeverException(
          'Location permissions are permanently denied, we cannot request permissions.',
          () async {
        if (await Permission.location.status.isDenied) {
          await Geolocator.openAppSettings();
        }
        setState(() {
          _future = _setupLocationService();
        });
      }));
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
    setState(() {
      capturing = true;
    });
    XFile? file = await controller?.takePicture();
    await controller?.pausePreview();
    Position? pos = await _getCurrentLocation();
    if (pos == null) {
      setState(() {
        capturing = false;
      });
      CustomToast.showErrorToast("Unable to get current location!");
      return false;
    }
    double lat = pos.latitude;
    double lon = pos.longitude;
    treesBloc.add(GetNearbyTreesEvent(latitude: lat, longitude: lon));
    if (file == null) {
      setState(() {
        capturing = false;
      });
      return false;
    }
    file.saveTo("${(await getTemporaryDirectory()).path}/temp.jpg");
    image = File("${(await getTemporaryDirectory()).path}/temp.jpg");
    setState(() {
      capturing = false;
      captured = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return NoAppBarLayout(
        padding: 0,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
            ),
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off_rounded,
                            size: 50,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            (snapshot.error as PermissionException).message,
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () {
                                if (snapshot.error is PermissionException) {
                                  print((snapshot.error as PermissionException)
                                      .onPressed);
                                  (snapshot.error as PermissionException)
                                      .onPressed
                                      ?.call();
                                }
                              },
                              child: Text(
                                  (snapshot.error as PermissionException)
                                      .buttonTitle))
                        ],
                      ),
                    );
                  }
                  return controller == null
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: width,
                          height: height,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: width,
                                height: height,
                              ),
                              Positioned(
                                  top: 0,
                                  width: width,
                                  height: height,
                                  child: ClipRect(
                                    clipper: _MediaSizeClipper(
                                        MediaQuery.of(context).size),
                                    child: Transform.scale(
                                        scale: 1 /
                                            (controller!.value.aspectRatio *
                                                MediaQuery.of(context)
                                                    .size
                                                    .aspectRatio),
                                        alignment: Alignment.center,
                                        child: CameraPreview(controller!)),
                                  )),
                              const SizedBox(height: 20),
                              Positioned(
                                bottom: 40,
                                left: width / 2 - 31,
                                child: IconButton(
                                    onPressed: () async {
                                      if (captured) {
                                        controller?.resumePreview();
                                        setState(() {
                                          captured = false;
                                        });
                                        return;
                                      }
                                      if (!await _capture()) {
                                        CustomToast.showErrorToast(
                                            "Unable to capture image!");
                                      }
                                    },
                                    icon: capturing
                                        ? CircularProgressIndicator(
                                            color: const Color(0xff5BE7C4),
                                          )
                                        : Icon(
                                            captured
                                                ? BootstrapIcons
                                                    .arrow_counterclockwise
                                                : Icons.camera,
                                            size: 50,
                                            color: const Color(0xff5BE7C4),
                                          )),
                              )
                            ],
                          ),
                        );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Positioned(
                top: MediaQuery.of(context).viewPadding.top + 10,
                left: 10,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 30,
                    ))),
          ],
        ));
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;

  const _MediaSizeClipper(this.mediaSize);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

abstract class PermissionException implements Exception {
  final String message;
  final String buttonTitle;
  final Function? onPressed;

  PermissionException(this.message, this.buttonTitle, this.onPressed);

  @override
  String toString() {
    return message;
  }
}

class LocationServiceDisabledException extends PermissionException {
  LocationServiceDisabledException(String message)
      : super(message, "Enable Location Services",
            Geolocator.openLocationSettings);
}

class LocationPermissionDeniedException extends PermissionException {
  LocationPermissionDeniedException(String message, Function onPressed)
      : super(message, "Grant Permissions", onPressed);
}

class LocationPermissionDeniedForeverException extends PermissionException {
  LocationPermissionDeniedForeverException(String message, Function onPressed)
      : super(message, "Grant Permissions", onPressed);
}

class CameraPermissionDeniedException extends PermissionException {
  CameraPermissionDeniedException(String message, Function onPressed)
      : super(message, "Grant Permissions", onPressed);
}

class CameraPermissionDeniedForeverException extends PermissionException {
  CameraPermissionDeniedForeverException(String message, Function onPressed)
      : super(message, "Grant Permissions", onPressed);
}
