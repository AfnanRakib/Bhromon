import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import 'package:lottie/lottie.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapPageState();
}

class _MapPageState extends State<Maps> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();

  static const LatLng _pgoogleplex = LatLng(37.4223, -122.0848);
  static const LatLng _papplplex = LatLng(37.3346, -122.0090);
  LatLng? _currentPos;

  @override
  void initState() {

    super.initState();
    getLocationUpdates();

  }

  @override
  Widget build(BuildContext context) {

    /*LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _pgoogleplex.latitude < _papplplex.latitude ? _pgoogleplex.latitude : _papplplex.latitude,
        _pgoogleplex.longitude < _papplplex.longitude ? _pgoogleplex.longitude : _papplplex.longitude,
      ),
      northeast: LatLng(
        _pgoogleplex.latitude > _papplplex.latitude ? _pgoogleplex.latitude : _papplplex.latitude,
        _pgoogleplex.longitude > _papplplex.longitude ? _pgoogleplex.longitude : _papplplex.longitude,
      ),
    );*/

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: _currentPos == null ?
      Container(
        color: Theme.of(context).primaryColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            //loading animation can be putdown here
            children: <Widget>[
              SpinKitFoldingCube(
                color: Color.fromRGBO(90, 185, 141, 1),
                duration: Duration(milliseconds: 1000),
              ),
/*              Text(" loading....",
                style:TextStyle(
                    fontSize: 50,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent.shade100
                ) ,
              ),*/
            ]

        ),
      ) :GoogleMap(
        onMapCreated: ((GoogleMapController controller)=>
            _mapController.complete(controller)
        ),
        initialCameraPosition: CameraPosition(
          target:_pgoogleplex, //bounds.northeast,
          zoom: 10.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
            position: _currentPos!,

          ),
          Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pgoogleplex,
          ),
          Marker(
            markerId: MarkerId("_destinationLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _papplplex,
          ),
        },
      ),
    );
  }
  Future<void>_cameraToPosition(LatLng pos) async{
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
        target: pos,
        zoom: 13
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }
  Future<void> getLocationUpdates() async {

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData curentLocation) {
      if (curentLocation.latitude != null && curentLocation.longitude != null) {
        setState(() {
          _currentPos = LatLng(curentLocation.latitude!, curentLocation.longitude!);
          print("Current Location $_currentPos");
          _cameraToPosition(_currentPos!);
        });
      }
    });
  }
}