/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Route Tracker Page
class RouteTrackView extends StatefulWidget {
  const RouteTrackView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  RouteTrackViewState createState() => RouteTrackViewState();
}

/// Route Tracker Page Background
class RouteTrackViewState extends State<RouteTrackView> {
  /// Check GPS Enabled
  bool _isGpsEnabled = false;

  /// List of Marker for Google Map
  Set<Marker> _markers = {};

  /// Current Postion From Device
  late Position currentloc;

  /// Check Bottom Sheet button Status
  bool checkbtmoepn = false;

  /// Check Start Button Status
  bool checkStartbtn = true;

  /// Check Stop button Status
  bool checkStopbtn = false;

  /// Gooogle Map Controller
  GoogleMapController? _mapController;

  ///  List of Cordinates Point
  List<LatLng> _points = [];

  /// Use for Drawing line to the Google Map
  Set<Polyline> _polylines = {};

  /// Check Tracking Status
  bool _isTracking = false;

  /// initalilise MyTimer Class
  MyTimer timer = MyTimer();

  ///  Totla distance
  double totaldistance = 0;

  /// initalilise ScreshotSaveOpen Class
  ScreshotSaveOpen sS0 = ScreshotSaveOpen();

  /// Check number of Button press
  int count = 0;

  /// Check SnackBar visiable Status
  bool _isSnackBarVisible = false;

  /// Inital Statue
  @override
  void initState() {
    super.initState();
    checkGps(); // Check in Beginning
  }

  /// Enable Snackbar
  void _showSnackBar() {
    setState(() {
      _isSnackBarVisible = true;
    });

    // Hide the SnackBar after 2 seconds
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isSnackBarVisible = false;
      });
    });
  }

  /// Check Camera Zoom out Status
  bool _hasZoomedOut = false;

  /// Check GPS is Enabled
  Future<void> checkGps() async {
    //Check inital GPS status
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      bool result = await Geolocator.openLocationSettings();
      if (!result) {
        setState(() {
          _isGpsEnabled = false;
        });
        return;
      }
    }
//Listen GPS Changes
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always) {
        setState(() {
          _isGpsEnabled = false;
        });
        return;
      }
    }
    setState(() {
      _isGpsEnabled = true;
    });
  }

  // ignore: non_constant_identifier_names
  CameraPosition SetCameraPostion(double Lat, double lng) {
    return CameraPosition(target: LatLng(Lat, lng), zoom: 12.0);
  }

  /// Add Marker to the Map
  void _addMarker(
    LatLng latLng,
    String name,
  ) {
    final markerId = MarkerId("marker_id_${_markers.length}");
    final marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(
        title: name,
      ),
      icon: (name == "Start point")
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      _markers.add(marker);
    });
  }

  /// Get Deivce location
  void _getLocation() async {
    try {
      currentloc = await Geolocator.getCurrentPosition();
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentloc.latitude!,
            currentloc.longitude!,
          ),
          zoom: 15,
        ),
      ));
      // End
    } catch (e) {
      print('Could not get location: $e');
    }
  }

  /// Start tracking
  Future<void> _startTracking() async {
    Geolocator.getPositionStream().listen((Position locationData) {
      setState(() {
        currentloc = locationData;
        if (_isTracking) {
          _points.add(LatLng(
            currentloc.latitude!,
            currentloc.longitude!,
          ));
        }
        if (_isTracking && _mapController != null) {
          _mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentloc.latitude!, currentloc.longitude!),
              zoom: 18,
            ),
          ));
        }
        if (_isTracking) {
          LatLng curt = LatLng(currentloc.latitude!, currentloc.longitude!);
          _points.add(curt);
          if (_points.length >= 2) {
            double distance =
                distanceBetween(_points[_points.length - 2], curt);
            totaldistance = totaldistance + (distance + 0.0005);
            print(totaldistance);
          }
        }
      });
    });
  }

  /// Calculate sitance between each point
  double distanceBetween(LatLng point1, LatLng point2) {
    double lat1 = point1.latitude * (pi / 180);
    double lon1 = point1.longitude * (pi / 180);
    double lat2 = point2.latitude * (pi / 180);
    double lon2 = point2.longitude * (pi / 180);

    double dLon = lon2 - lon1;
    double dLat = lat2 - lat1;
    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double earthRadius = 6371000; // meters
    double result = earthRadius * c;
    return result;
  }

  /// Stop Tracking
  Future<void> _stopTracking() async {
    Geolocator.getPositionStream().listen(null);
    if (_mapController != null) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentloc.latitude!, currentloc.longitude!),
          zoom: 14, // Set the zoom level to a default value
        ),
      ));
      _addMarker(
          LatLng(currentloc.latitude, currentloc.longitude), "End Point");
      _hasZoomedOut = true;
    }
  }

  /// Clear Tracking Info
  void _clearTracking() {
    setState(() {
      _points = [];
      _polylines = {};
      _markers = {};
    });
  }

  /// Update Route Property
  void _updatePolyline() {
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: _points,
        color: Colors.green,
        width: 7,
      ));
    });
  }

  /// Process of Route Tracker
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SizedBox(
        child: Scaffold(
          //Title Bar
          appBar: AppBar(
              title: const Text("Route Tracker"),
              backgroundColor: Colors.green),
          // Google Map
          body: _isGpsEnabled
              ? Stack(children: [
                  // Google Map
                  GoogleMap(
                    initialCameraPosition: SetCameraPostion(1.3521, 103.8198),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    polylines: _polylines,
                    markers: _markers,
                    myLocationEnabled: true,
                  ),
                  // floating btm
                  Positioned(
                    right: 5,
                    bottom: 220,
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton(
                          child: checkbtmoepn
                              ? const Icon(Icons.expand_more)
                              : const Icon(Icons.expand_less),
                          onPressed: () {
                            setState(() {
                              checkbtmoepn = !checkbtmoepn;
                            });
                          }),
                    ),
                  ),
                  //Bottom Sheet Bar
                  Positioned(
                    bottom: 0,
                    child: checkbtmoepn
                        ? SizedBox(
                            child: Container(
                              height: 200,
                              width: 380,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(45),
                                      topRight: Radius.circular(45))),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // StartButton
                                    checkStartbtn
                                        ? FloatingActionButton(
                                            child: Icon(Icons.start),
                                            onPressed: () {
                                              if (count == 1) _clearTracking();
                                              setState(() {
                                                if (count == 1) count = 0;
                                                checkStartbtn = false;
                                                checkStopbtn = true;
                                                _isTracking = true;
                                                totaldistance = 0;
                                                count++;
                                              });
                                              checkGps();
                                              _getLocation();
                                              _addMarker(
                                                  LatLng(currentloc.latitude!,
                                                      currentloc.longitude!),
                                                  "Start point");
                                              _startTracking();
                                              _updatePolyline();
                                              timer.start();
                                            })
                                        : Text(""),
                                    // Stop Button
                                    checkStopbtn
                                        ? FloatingActionButton(
                                            child: const Icon(Icons.stop),
                                            onPressed: () async {
                                              setState(() {
                                                checkStartbtn = true;
                                                checkStopbtn = false;
                                                _isTracking = false;
                                                sS0.setdistance(
                                                    totaldistance.toString());
                                                sS0.settime(
                                                    timer.displaytime());
                                              });
                                              _stopTracking();
                                              timer.stop();
                                              await Future.delayed(
                                                  Duration(seconds: 5));
                                                    print("Test");
                                              if (_hasZoomedOut) {
                                                sS0.setGMControler(
                                                    _mapController!);
                                                sS0.captureAndSaveScreenshot();
                                                _showSnackBar();
                                                setState(() {
                                                  _hasZoomedOut = false;
                                                });
                                              }
                                            })
                                        : const Text(""),
                                    //------
                                    Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(45)),
                                          child: Text(
                                            timer.displaytime(),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(45)),
                                          child: Text(
                                            "${totaldistance.toStringAsFixed(2).padLeft(2, "0").padRight(2, "0")}:KM",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                            ),
                          )
                        : SizedBox(
                            child: Container(
                            height: 0,
                          )),
                  ),
                  Visibility(
                    visible: _isSnackBarVisible,
                    child: Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green,
                        child: Text("File Saved to gallery"),
                      ),
                    ),
                  ),
                ])
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

/// Timer Class
class MyTimer {
  /// Number of Seconds
  int _seconds = 0;

  /// Number of Minutes
  int _Minutes = 0;

  /// Number of Hours
  int _hour = 0;

  /// Timer Variable
  var _timer;

  /// Start Timer
  void start() {
    _seconds = 0;
    _Minutes = 0;
    _hour = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      print("Elapsed time: $_seconds seconds");
      calculatetime();
    });
  }

  /// Stop Timer
  void stop() {
    _timer?.cancel();
    print("Timer stopped");
  }

  /// Calculate Time
  void calculatetime() {
    if (_seconds >= 60) {
      _Minutes++;
      _seconds = 0;
    }
    if (_Minutes >= 60) {
      _hour++;
      _Minutes = 0;
      _seconds = 0;
    }
  }

  /// Display Time in MM:SS
  String displaytime() {
    return "${_hour.toString().padLeft(2, "0")}:${_Minutes.toString().padLeft(2, "0")}:${_seconds.toString().padLeft(2, "0")}";
  }
}

/// Screenshot Map and Save to device Class
class ScreshotSaveOpen {
  /// Google Map controller
  late GoogleMapController _googleMapController;

  /// intialise ImageGallerSaver class
  ImageGallerySaver img = ImageGallerySaver();

  /// Text for distance
  String distane = "";

  /// Text for time
  String time = "";

  /// Random Number
  int rannum = Random().nextInt(1000);

  /// Set Google map Controller value
  void setGMControler(GoogleMapController c) {
    _googleMapController = c;
  }

  /// Set Distance string
  void setdistance(String s) {
    distane = s;
  }

  /// Set time String
  void settime(String t) {
    time = t;
  }

  /// Capture and Save Function
  Future<void> captureAndSaveScreenshot() async {
    File file;
    var exist = false;
    String fileName;
    try {
      // 1. Capture the screenshot
      //Uint8List? imageBytes = await _screenshotController.capture();
      Uint8List? imageBytes = await _googleMapController.takeSnapshot();

      // 2. Get the directory where you want to save the screenshot
      final directory = await getExternalStorageDirectory();
      String path = directory!.path;

      do {
        // 3. Create a file name for the screenshot (e.g. "screenshot.png")
        // ignore: prefer_interpolation_to_compose_strings
        fileName = distane + " km " + time + " H_M_S " + "l$rannum" + 'l';
        // 4. Create a File object and write the image bytes to it
        // Just in case file the same
        file = File('$path/$fileName');
        exist = await file.exists();
      } while (exist);
      print(file);
      await file.writeAsBytes(
          imageBytes!); // save to android.data -> some android does not allow access
      await ImageGallerySaver.saveImage(imageBytes,
          name: fileName); // savve to gallery

      // 5. Show a message indicating where the screenshot was saved

      print('Screenshot saved to $path/$fileName');
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }
}
