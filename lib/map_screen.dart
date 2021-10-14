import 'dart:developer';



import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';




class MapScreen extends StatefulWidget {
  final GeoPoint endLoc;
  final String address;
  MapScreen({required this.address, required this.endLoc});
  @override
  State<StatefulWidget> createState() {
    return _MapScreen();
  }
}



class _MapScreen extends State<MapScreen> {
  MapController? controller;
  RoadInfo _roadInfo = RoadInfo();
  String address = "unknown";



  var distance = 0.0;
  var time = 0.0;



  @override
  void initState() {
    controller = MapController(
      initMapWithUserPosition: true,
      initPosition: GeoPoint(
        latitude: 27.70286,
        longitude: 85.34406,
      ),
    );
    super.initState();
  }



  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller!.currentLocation();
          log(controller!.initPosition!.latitude.toString());
          log(controller!.initPosition!.longitude.toString());
        },
        child: Icon(Icons.place),
      ),
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller!,
            trackMyPosition: false,
            initZoom: 15,
            minZoomLevel: 2,
            maxZoomLevel: 18,
            stepZoom: 5.0,
            userLocationMarker: UserLocationMaker(
              personMarker: MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            road: Road(
              startIcon: MarkerIcon(
                icon: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.brown,
                ),
              ),
              roadColor: Colors.red,
            ),
            markerOption: MarkerOption(
              defaultMarker: MarkerIcon(
                icon: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 56,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: MaterialButton(
              color: Colors.red,
              onPressed: () async {
                GeoPoint geoPoint = await controller!.myLocation();
                _roadInfo = await controller!.drawRoad(
                  GeoPoint(
                      latitude: geoPoint
                          .latitude, // controller!.initPosition!.latitude,
                      longitude: geoPoint
                          .longitude // controller!.initPosition!.longitude,
                  ),
                  GeoPoint(
                    latitude: widget.endLoc.latitude,
                    longitude: widget.endLoc.longitude,
                  ),
                  roadType: RoadType.foot,



                  /* intersectPoint: [
                    GeoPoint(latitude: 27.701, longitude: 85.34106),
                    GeoPoint(latitude: 27.70090, longitude: 85.34176)
                  ], */
                  roadOption: RoadOption(
                    roadWidth: 5,
                    roadColor: Colors.blue,
                    showMarkerOfPOI: false,
                  ),
                );
                setState(() {
                  distance = _roadInfo.distance!;
                  time = _roadInfo.duration!;
                });
                controller!.goToLocation(geoPoint);



                await controller!.setZoom(zoomLevel: 17);
                setState(() {});
              },
              child: Text('Get Direction'),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: MaterialButton(
              color: Colors.red,
              onPressed: () async {
                await controller!.addMarker(
                  GeoPoint(
                    latitude: 27.6888,
                    longitude: 85.3164,
                  ),
                  markerIcon: MarkerIcon(
                    icon: Icon(
                      Icons.place,
                      color: Colors.green,
                    ),
                  ),
                );
              },
              child: Text('Add Marker'),
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Distance:${distance} m, Time:${time} second"),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(address),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
