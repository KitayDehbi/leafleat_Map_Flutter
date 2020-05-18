import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Geolocator geolocator = Geolocator();
  MapController controller = new MapController();
  bool _isGettingLocation;
  double lat,lon;
  void getCurrentLocation() async {

    Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    try {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
        _isGettingLocation = false;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    print('Current location lat long ' + position.latitude.toString() + " - " + position.longitude.toString());
    
  }
   @override
  void initState() {
    super.initState();
    _isGettingLocation = true;
    getCurrentLocation();
  }
  Widget build(BuildContext context) {
   
    return _isGettingLocation ? Center(
            child : CircularProgressIndicator()
       ) :
    MaterialApp ( 
        home : new Scaffold(
          appBar : new AppBar( title : new Text('Master ISI Map')), 
          body  :new FlutterMap(
          
            options: new MapOptions(
              center:new LatLng(lat,lon),
              minZoom: 5.0,
                                    ),
            layers: [
              new TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a','b','c']
                
                                   ),
                                   new MarkerLayerOptions(
                                     markers:[new Marker(
                                       width: 45.0,
                                       height: 45.0,
                                       point: new LatLng(lat,lon),
                                       builder: (context)=> new Container(
                                         child: IconButton(
                                           icon: Icon(Icons.location_on), 
                                           color: Colors.redAccent[700],
                                           iconSize: 45.0,
                                            onPressed:()=>print("Marker pressed") ,)
                                           
                                       )
                                     )] 
                                     
                                     ),
                    ],
                              ) 
                           )
                                          );
      
     
      
        }
        }
