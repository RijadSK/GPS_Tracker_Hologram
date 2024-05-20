import 'dart:async';
import 'dart:convert';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<String> computeFunction(String arg) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DatabaseReference? _pathDatabaseReference = null;
  _pathDatabaseReference = FirebaseDatabase.instance.ref().child('datatoadd');

  DatabaseEvent? _dbEvent = null;

  while (_dbEvent == null) {
    _dbEvent = await _pathDatabaseReference.once();
  }
  var latLngList = readListLatLngFromDbEvent(_dbEvent);
  String latLngListJson = jsonEncode(latLngList);
  return Future.value(latLngListJson);
}

Future<String> _futureLatLngList = flutterCompute(computeFunction, "foo");

List<LatLng> readListLatLngFromDbEvent(DatabaseEvent dbEvent) {
  List<LatLng> latLngList = [];
  Map<dynamic, dynamic> values =
      dbEvent.snapshot.value as Map<dynamic, dynamic>;
  final doubleRegex = RegExp(r"=\d*\.?\d+", multiLine: false);
  values.forEach((key, value) {
    if (value['AddedData'] != null) {
      String addedData = value['AddedData'];
      var matches = doubleRegex.allMatches(addedData);
      double latitude =
          double.parse(matches.elementAt(0).group(0)!.substring(1));
      double longitude =
          double.parse(matches.elementAt(1).group(0)!.substring(1));

      latLngList.add(LatLng(latitude, longitude));
    }
  });
  return latLngList;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Future.delayed(const Duration(seconds: 20), () {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LatLng> _latLngList = [];
  MapController _mapController = MapController();
  double _zoom = 7;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
  }

  void createMarkersFromLatLngList() {
    _markers = _latLngList
        .map((point) => Marker(
              point: point,
              width: 40,
              height: 40,
              child: Icon(
                Icons.circle_rounded, //.circle, //.pin_drop,
                size: 30,
                color: Colors.blueAccent,
              ),
            ))
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<String>(
        future: _futureLatLngList,
        waiting: (context) {
          return CircularProgressIndicator();
        },
        error: (context, error, stackTrace) {
          return Text('Error! $error');
        },
        builder: (context, value) {
          String convertedValue = value!
              .replaceAll('{"coordinates":[', 'LatLng(')
              .replaceAll(']}', ')')
              .replaceAll('[', '')
              .replaceAll(']', '');

          RegExp regexAllLatLng =
              new RegExp(r"LatLng\((\d+\.?\d+)(\,)(\d+\.?\d+)\)");
          var matches = regexAllLatLng.allMatches(convertedValue);
          RegExp regexCoord = new RegExp(r"(\d+\.?\d+)");
          for (int ind = 0; ind < matches.length; ind++) {
            String? textLatLng = matches.elementAt(ind).group(0);
            var coordMatches = regexCoord.allMatches(textLatLng!);
            double latitude = double.parse(coordMatches.elementAt(1).group(0)!);
            double longitude =
                double.parse(coordMatches.elementAt(0).group(0)!);
            _latLngList.add(new LatLng(latitude, longitude));
          }

          double avgLatitude = 0;
          double avgLongitude = 0;
          double sumLatitude = 0;
          double sumLongitude = 0;
          _latLngList.forEach((loc) {
            sumLatitude += loc.latitude;
            sumLongitude += loc.longitude;
          });
          int numLocations = _latLngList.length;
          avgLatitude = sumLatitude / numLocations;
          avgLongitude = sumLongitude / numLocations;
          createMarkersFromLatLngList();

          return Scaffold(
            appBar: AppBar(
              title: Text('GPS Car Map'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(avgLatitude, avgLongitude),
                      initialCameraFit: CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(_latLngList),
                        padding: EdgeInsets.all(120.0),
                      ),
                      initialZoom: _zoom,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(markers: _markers),
                      MarkerClusterLayer(
                        mapController: _mapController,
                        mapCamera: MapCamera.initialCamera(MapOptions(
                          initialCenter: LatLng(avgLatitude, avgLongitude),
                          initialCameraFit: CameraFit.bounds(
                              bounds: LatLngBounds.fromPoints(_latLngList)),
                          initialZoom: _zoom,
                        )),
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 200,
                          disableClusteringAtZoom: 16,
                          size: Size(40, 40),
                          markers: _markers,
                          polygonOptions: PolygonOptions(
                              borderColor: Colors.blueAccent,
                              color: Colors.black12,
                              borderStrokeWidth: 3),
                          builder: (context, markers) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.orange, shape: BoxShape.circle),
                              child: Text('${markers.length}'),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
