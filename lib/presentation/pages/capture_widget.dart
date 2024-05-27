import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tree_com/core/layouts/no_appbar_layout.dart';
import 'package:tree_com/core/utils/toast.dart';

class CaptureWidget extends StatefulWidget {
  const CaptureWidget(
      {super.key,
      required this.title,
      required this.onCapture,
      this.location = false});

  final bool location;
  final Future<bool> Function(File image, Position? location) onCapture;
  final String title;

  @override
  State<CaptureWidget> createState() => _CaptureWidgetState();
}

class _CaptureWidgetState extends State<CaptureWidget> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  late Future<void> _future;
  File? image;
  bool capturing = false;
  bool captured = false;

  initState() {
    super.initState();
    _future = _setupServices();
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

  Future<void> _setupServices() async {
    await _initCamera().catchError((e) {
      return Future.error(e);
    });
    if (widget.location) return await _setupLocationService();
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

  Future<bool> _capture() async {
    setState(() {
      capturing = true;
    });
    XFile? file = await controller?.takePicture();
    await controller?.pausePreview();
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
    return await widget.onCapture(
        image!, widget.location ? await Geolocator.getCurrentPosition() : null);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: width,
                                  height: height * 0.15,
                                  color: Colors.black.withOpacity(0.4),
                                  child: Center(
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
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: width,
                                  height:
                                      MediaQuery.of(context).viewPadding.top +
                                          height * 0.07,
                                  color: Colors.greenAccent.withOpacity(0.4),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                              .viewPadding
                                              .top),
                                      child: Text(
                                        "Capture a tree",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
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
