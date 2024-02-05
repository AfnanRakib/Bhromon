import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

import 'package:bhromon/pages/const.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapPageState();
}

class _MapPageState extends State<Maps> with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();

  LatLng? _currentPos;
  LatLng? _sourcePos;
  LatLng? _destinationPos;
  Marker? _origin;
  Marker? _destination;
  String curr = " ";
  bool _setMArkVisible = false;
  bool _repointSource = false;
  bool _repointDest = false;
  String selectedMarker = "Markers";
  Widget? MarkerRemoveMode;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _changeMapType(MapType mapType) {
    setState(() {
      _mapType = mapType;
    });
  }

  MapType _mapType = MapType.normal; // Initial map type is normal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPos == null
          ? Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.greenAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 1],
              tileMode: TileMode.clamp,
            )),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            //loading animation can be putdown here
            children: <Widget>[
              SpinKitPulsingGrid(
                color: Colors.white,
                duration: Duration(milliseconds: 1000),
              ),
              Text(
                " loading....",
                style: TextStyle(
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
            ]),
      )
          : Column(
        children: [
          Container(
            color: Colors.greenAccent,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10, top: 35, right: 1, bottom: 1),
                        child: Text(
                          'Bhromon Maps',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            wordSpacing: 6,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 35, 0, 1),
                        child: TextButton(
                          onPressed: () {
                            _cameraToPosition(
                              _origin!.position,
                            );
                            setState(() {
                              _repointSource = true;
                              _repointDest = false;
                              _setMArkVisible = false;

                              selectedMarker = "source";
                            });


                          },
                          child: const Text(
                            "Source",
                            style: TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 35, 1, 1),
                        child: TextButton(
                          onPressed: () {
                            _cameraToPosition(
                              _destination!.position,
                            );
                            setState(() {
                              _repointDest = true;
                              _setMArkVisible = false;
                              _repointSource = false;

                              selectedMarker = "Destination";
                            });


                          },
                          child: const Text(
                            "destination",
                            style: TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _searchBar(),
                ),
              ],
            ),
          ),
          Expanded(
            child:GestureDetector(
              onDoubleTap:(){
                setState(() {
                  _repointDest=false;
                  _repointSource = false;
                  _setMArkVisible = true;
                });
              } ,
              child: GoogleMap(
                mapType: _mapType,
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition: CameraPosition(
                  target: _currentPos!, //bounds.northeast,
                  zoom: 10.0,
                ),
                markers: {
                  if (_origin != null) _origin!,
                  if (_destination != null) _destination!,
                  Marker(
                      markerId: MarkerId("_currentLocation"),
                      infoWindow: InfoWindow(title: curr),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                      position: _currentPos!,
                      onTap: () async {
                        _sourcePos = _currentPos!;
                        curr = await latlangToAddress(_sourcePos!);
                        infoWindow:
                        InfoWindow(title: curr);
                        _addMarker(_sourcePos!);
                      }),
                },
                // onLongPress: _addMarker,
                polylines: Set<Polyline>.of(polylines.values),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _currentPos != null
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 1, bottom: 10, left: 1),
                child: _buildSpeedDial(),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 1, bottom: 10, right: 5),
                child: FloatingActionButton(
                  onPressed: () {
                    _cameraToPosition(_currentPos!);
                  },
                  backgroundColor: Colors.greenAccent,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 70.0),
                child: MarkerRemoveMode = (_setMArkVisible&&!_repointSource&&!_repointDest)?_removeMarker():
                (!_setMArkVisible&&_repointSource&&!_repointDest)?_removeSource():_removeDest(),
              ))
        ],
      )
          : null,
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    LocationPermission _permissionGranted;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await Geolocator.openAppSettings();
      if (!_serviceEnabled) {
        return Future.error('Location permissions are denied');
      }
    }

    _permissionGranted = await Geolocator.checkPermission();
    if (_permissionGranted == LocationPermission.denied) {
      _permissionGranted = await Geolocator.requestPermission();
      if (_permissionGranted == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      setState(() {
        _currentPos = LatLng(position!.latitude, position.longitude);
        print(
            "longtitude: ${_currentPos!.longitude},lattitude: ${_currentPos!.latitude}");
      });
    });
  }

  Future<List<LatLng>> getPolylinesPoints(LatLng _source, LatLng _dest) async {
    List<LatLng> polyLinesCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGlE_MAPS_API_KEY,
      PointLatLng(_source!.latitude, _source!.longitude),
      PointLatLng(_dest!.latitude, _dest!.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLinesCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polyLinesCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _addCurrentMarker() async {
    curr = await latlangToAddress(_currentPos!);
    setState(() {
      print("current location: $curr");
    });
  }

  void _init() async {
    await getLocationUpdates();
    if (_currentPos != null) {
      setState(() {
        _addCurrentMarker();
      });
    }
  }
  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {

      String source = await latlangToAddress(pos) ;
      setState(() {
        _origin = Marker(
            markerId: MarkerId(source),
            infoWindow: InfoWindow(title: source),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
        _sourcePos = pos;
        if(!_repointSource ){
          _destination = null;
          _destinationPos = null;
          polylines.clear();
        }
        setState(() {
          _setMArkVisible = true;
          _repointSource = false;
          _repointDest = false;
        });

        updatePolylines(_sourcePos!, _destinationPos!);
      });
    } else {
      String dest = await latlangToAddress(pos) ;
      setState(() {
        if (_destination == null) {
          _destination = Marker(
            markerId: MarkerId(dest),
            infoWindow: InfoWindow(title: dest),
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: pos,
          );
          _destinationPos = pos;
          setState(() {
            _setMArkVisible = true;
            _repointSource = false;
            _repointDest = false;
          });
          updatePolylines(_sourcePos!, _destinationPos!);
        }
      });
    }
  }

  Future<void> updatePolylines(LatLng source, LatLng dest) async {
    List<LatLng> coordinates = await getPolylinesPoints(source, dest);
    generatePolyLineFromPoints(coordinates);
  }

  Widget _buildSpeedDial() {
    return SpeedDial(
      icon: Icons.layers,
      animatedIconTheme: IconThemeData(size: 22.0),
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      curve: Curves.easeInOut,
      foregroundColor: Colors.white,
      backgroundColor: Colors.greenAccent,
      switchLabelPosition: true,
      children: [
        SpeedDialChild(
          child: Icon(Icons.map),
          onTap: () {
            _changeMapType(MapType.normal);
          },
          label: 'Normal',
          labelStyle: TextStyle(fontSize: 14.0),
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.satellite),
          onTap: () {
            _changeMapType(MapType.satellite);
          },
          label: 'Satellite',
          labelStyle: TextStyle(fontSize: 14.0),
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.terrain),
          onTap: () {
            _changeMapType(MapType.terrain);
          },
          label: 'Terrain',
          labelStyle: TextStyle(fontSize: 14.0),
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.layers),
          onTap: () {
            _changeMapType(MapType.hybrid);
          },
          label: 'Hybrid',
          labelStyle: TextStyle(fontSize: 14.0),
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent,
        ),
      ],
    );
  }

  Future<String> latlangToAddress(LatLng pos) async {
    List<Placemark> placemark =
    await placemarkFromCoordinates(pos.latitude, pos.longitude);
    Placemark place = placemark.first;
    String address =
        "${place.street}, ${place.administrativeArea} ,${place.country}";
    setState(() {
      print(placemark.toString());
    });
    return address;
  }

  Widget _searchBar() {
    return SearchMapPlaceWidget(
      apiKey: GOOGlE_MAPS_API_KEY,
      language: 'en',
      location: _currentPos,
      radius: 30000,
      hasClearButton: false,
      bgColor: Colors.white,
      textColor: Colors.black,
      placeholder: curr == " " ? "Where do you want to go?" : curr,
      placeType: PlaceType.address,
      onSelected: (Place place) async {
        final geolocation = await place.geolocation;
        _addMarker(geolocation!.coordinates);
        final GoogleMapController controller1 = await _mapController.future;
        controller1
            .animateCamera(CameraUpdate.newLatLng(geolocation!.coordinates));
        controller1
            .animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
      },
    );
  }

  Widget _removeMarker() {
    return Visibility(
      visible: _setMArkVisible,
      child: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.greenAccent,
        shape: StadiumBorder(),
        onPressed: () {
          setState(() {
            if (_setMArkVisible) {

              if (!_repointDest && !_repointSource) {
                _origin = null;
                _sourcePos = null;
                _destinationPos = null;
                _destination = null;
                polylines.clear();
              }

              _setMArkVisible = false;
            }
          });
        },
        child: Text(
          "Remove Markers",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _removeDest() {
    return Visibility(
      visible: _repointDest,
      child: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.greenAccent,
        shape: StadiumBorder(),
        onPressed: () {
          setState(() {
            if (_repointDest) {
              if (_repointDest && !_repointSource) {
                _destinationPos = null;
                _destination = null;
                polylines.clear();
              }

              _repointDest = false;
            }
          });
        },
        child: Text(
          "Remove Destination",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _removeSource() {

    return Visibility(
      visible: _repointSource,
      child: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.greenAccent,
        shape: StadiumBorder(),
        onPressed: () {
          setState(() {
            if (_repointSource) {

              if (!_repointDest && _repointSource) {
                _origin = null;
                _sourcePos = null;
                polylines.clear();
              }
              _repointSource = false;
            }
          });
        },
        child: Text(
          "Remove Source",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
