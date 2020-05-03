import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iit_app/screens/drawer.dart';

// TODO: in androidManifest.xml , api key has to be changed  (register on goole cloud platform from original gmail and generate api key and enable required services)

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps (under dev)'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: SideBar(context: context),
      body: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  final Key _mapKey = UniqueKey();
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return TheMap(key: widget._mapKey);
  }
}

class TheMap extends StatefulWidget {
  ///key is required, otherwise map crashes on hot reload
  TheMap({@required Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TheMap> {
  Color color = Colors.green;
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      color = Colors.blue;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: const LatLng(25.267878, 82.990494),
          zoom: 15,
        ),
        mapType: MapType.terrain,
        // MapType.hybrid,
        myLocationEnabled: true,
        indoorViewEnabled: true,
        cameraTargetBounds: CameraTargetBounds(LatLngBounds(
            southwest: LatLng(25.259598295586617, 82.98727926886082),
            northeast: LatLng(25.269851359020624, 82.99818585552365))),
        minMaxZoomPreference: MinMaxZoomPreference(15, 25),
        onTap: (tappedPosition) {
          print(
              'lattitude : ${tappedPosition.latitude}      longitude: ${tappedPosition.longitude}');
        },
      );
}
