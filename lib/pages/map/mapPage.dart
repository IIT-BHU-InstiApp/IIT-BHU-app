import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/drawer.dart';

// TODO: in androidManifest.xml , api key has to be changed  (register on goole cloud platform from original gmail and generate api key and enable required services)

int timesCalled = 0;

class MapPage extends StatelessWidget {
  bool _fromCreateWorkshop = false;
  bool _fromWorkshopDetails = false;
  String _workshopLatitude = '';
  String _workshopLongitude = '';
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      _fromCreateWorkshop = arguments['fromWorkshopCreate'] ?? false;
      _fromWorkshopDetails = arguments['fromWorkshopDetails'] ?? false;
      if (_fromWorkshopDetails) {
        _workshopLatitude = arguments['latitude'];
        _workshopLongitude = arguments['longitude'];
      }
    }

    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        drawer: SideBar(context: context),
        body: LocationScreen(
          _fromCreateWorkshop,
          _fromWorkshopDetails,
          _workshopLatitude,
          _workshopLongitude,
        ),
      ),
    );
  }
}

class LocationScreen extends StatefulWidget {
  final Key _mapKey = UniqueKey();
  final bool fromCreateWorkshop;
  final bool fromWorkshopDetails;
  final String workshopLatitude;
  final String workshopLongitude;

  LocationScreen(
    this.fromCreateWorkshop,
    this.fromWorkshopDetails,
    this.workshopLatitude,
    this.workshopLongitude,
  ) : super();

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return TheMap(
      key: widget._mapKey,
      fromCreateWorkshop: widget.fromCreateWorkshop,
      fromWorkshopDetails: widget.fromWorkshopDetails,
      workshopLatitude: widget.workshopLatitude,
      workshopLongitude: widget.workshopLongitude,
    );
  }
}

class TheMap extends StatefulWidget {
  final bool fromCreateWorkshop;
  final bool fromWorkshopDetails;
  final String workshopLatitude;
  final String workshopLongitude;

  ///key is required, otherwise map crashes on hot reload
  TheMap({
    @required Key key,
    this.fromCreateWorkshop,
    this.fromWorkshopDetails,
    this.workshopLatitude,
    this.workshopLongitude,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TheMap> {
  Color color = Colors.green;
  Completer<GoogleMapController> mapController = Completer();

  List<Marker> _hostelMarkers = <Marker>[];
  List<Marker> _departmentMarkers = <Marker>[];
  List<Marker> _lectureHallMarkers = <Marker>[];
  List<Marker> _otherMarkers = <Marker>[];
  List<Marker> _allMarkers = <Marker>[];
  List<Marker> _displayMarkers = <Marker>[];

  bool _selectedList = false;

  CameraPosition _initialCameraPosition(
      [String workshopLatitude = '', String workshopLongitude = '']) {
    print(workshopLatitude);
    return workshopLatitude == ''
        ? CameraPosition(
            target: LatLng(25.267878, 82.990494),
            zoom: 15,
            bearing: 0.0,
            tilt: 0.0,
          )
        : CameraPosition(
            target: LatLng(double.parse(workshopLatitude), double.parse(workshopLongitude)),
            zoom: 18,
            tilt: 75,
            bearing: Random().nextDouble() * 90);
  }

  moveCameraToMarker(Map coord) async {
    final GoogleMapController controller = await mapController.future;
    final _camera = CameraPosition(
      target: LatLng(coord['LatLng'].latitude, coord['LatLng'].longitude),
      zoom: 18,
      tilt: 75,
      bearing: Random().nextDouble() * 90,
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_camera),
    );
  }

  simpleMoveCameraToMarker(String latitude, String longitude) async {
    print('Going to ($latitude, $longitude)');
    final GoogleMapController controller = await mapController.future;
    final _camera = CameraPosition(
      target: LatLng(double.parse(latitude), double.parse(longitude)),
      zoom: 18,
      tilt: 75,
      bearing: Random().nextDouble() * 90,
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_camera),
    );
  }

  Marker _getMarker({String category, var coord, int i, double hue}) {
    return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      markerId: MarkerId('category ${i.toString()}'),
      position: LatLng(coord['LatLng'].latitude, coord['LatLng'].longitude),
      infoWindow: InfoWindow(
        title: coord['title'],
      ),
      onTap: () => moveCameraToMarker(coord),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    color = Colors.blue;
    int i = 0;
    for (var coord in coords['Hostels']) {
      i += 1;
      Marker newMarker =
          _getMarker(category: 'Hostel', coord: coord, i: i, hue: BitmapDescriptor.hueRed);
      this._hostelMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    i = 0;
    for (var coord in coords['Departments']) {
      i += 1;
      Marker newMarker =
          _getMarker(category: 'Department', coord: coord, i: i, hue: BitmapDescriptor.hueGreen);

      this._departmentMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    i = 0;

    for (var coord in coords['Lecture Halls']) {
      i += 1;
      Marker newMarker =
          _getMarker(category: 'LT', coord: coord, i: i, hue: BitmapDescriptor.hueOrange);

      this._lectureHallMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }

    i = 0;
    for (var coord in coords['Others']) {
      i += 1;
      Marker newMarker =
          _getMarker(category: 'Other', coord: coord, i: i, hue: BitmapDescriptor.hueViolet);

      this._otherMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    _displayMarkers.addAll(_allMarkers);

    if (mounted)
      setState(() {
        print(_displayMarkers.length);
        if (widget.fromCreateWorkshop && timesCalled == 0) {
          _settingModalBottomSheet(context);
          timesCalled += 1;
        }
      });
  }

  void _settingModalBottomSheet(context) {
    final container = (String title, Function setDisplayMarker) => Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConstants.homeBackground,
          ),
          child: InkWell(
            splashColor: Colors.brown,
            onTap: () {
              if (this.mounted)
                setState(() {
                  _selectedList = true;
                  setDisplayMarker();
                });
            },
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.black,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              container('Hostels', () => {_displayMarkers = _hostelMarkers}),
              container('Departments', () => {_displayMarkers = _departmentMarkers}),
              container('LTs', () => {_displayMarkers = _lectureHallMarkers}),
              container('Others', () => {_displayMarkers = _otherMarkers}),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> locationSetDialog(
      BuildContext context, String title, String innerText) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? '(No Title)'),
            content: Text(innerText ?? '(No Inner Text)'),
            actions: <Widget>[
              FlatButton(
                child: Text("Yup!"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("Nope!"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  return false;
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timesCalled = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackground,
      appBar: AppBar(
        backgroundColor: ColorConstants.homeBackground,
        title: Text((widget.fromCreateWorkshop ? 'Workshop Location-' : '') + 'IIT BHU Map'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.homeBackground,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: widget.fromWorkshopDetails
                ? _initialCameraPosition(widget.workshopLatitude, widget.workshopLongitude)
                : _initialCameraPosition(),
            mapType: MapType.terrain,
            mapToolbarEnabled: true,
            markers: Set.from(_displayMarkers),
            onTap: (tappedPosition) {
              print(
                  'lattitude : ${tappedPosition.latitude}      longitude: ${tappedPosition.longitude}');
            },
          ),
          _selectedList
              ? Positioned(
                  right: 2,
                  top: 56,
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _selectedList = false;
                        _displayMarkers = _allMarkers;
                      });

                      final GoogleMapController controller = await mapController.future;
                      controller
                          .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50), color: Colors.black),
                      child: Text(
                        'Clear X',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                )
              : Container(),
          _selectedList
              ? Positioned(
                  top: 5,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black12,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 3,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    height: 44,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _displayMarkers.length,
                        itemBuilder: (context, index) {
                          Marker _tappableMarker = _displayMarkers[index];
                          List<Text> textList = [];

                          for (var text in _tappableMarker.infoWindow.title.split(' ')) {
                            textList.add(Text(text, style: TextStyle(color: Colors.white)));
                          }

                          return InkWell(
                            onTap: () async {
                              final GoogleMapController controller = await mapController.future;
                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: _tappableMarker.position,
                                    zoom: 18,
                                    tilt: 75.0,
                                    bearing: Random().nextDouble() * 90,
                                  ),
                                ),
                              );
                              if (widget.fromCreateWorkshop) {
                                print(_displayMarkers[index]);
                                bool shouldLocationbeSet = await locationSetDialog(
                                    context,
                                    'Location Set',
                                    'Do you want to set ${_displayMarkers[index].infoWindow.title} as the location for the workshop?');
                                if (shouldLocationbeSet == true) {
                                  Navigator.pop(context, [
                                    _displayMarkers[index].position.latitude.toString(),
                                    _displayMarkers[index].position.longitude.toString(),
                                    _displayMarkers[index].infoWindow.title.toString(),
                                  ]);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 6, 8, 6),
                              padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                              decoration: BoxDecoration(
                                color: ColorConstants.homeBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _tappableMarker.infoWindow.title,
                                style: TextStyle(color: Colors.white)
                                //  Column(
                                //   children: textList,
                                // )
                                ,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

Map<String, dynamic> coords = {
  "Hostels": [
    {
      "title": "Limbdi Hostel",
      "LatLng": LatLng(25.261155, 82.986075),
    },
    {
      "title": "Rajputana Hostel",
      "LatLng": LatLng(25.262417, 82.986178),
    },
    {
      "title": "Dhanraj Giri Hostel",
      "LatLng": LatLng(25.263944, 82.986100),
    },
    {
      "title": "Morvi Hostel",
      "LatLng": LatLng(25.265029, 82.986136),
    },
    {
      "title": "CV Raman Hostel",
      "LatLng": LatLng(25.265925, 82.986291),
    },
    {
      "title": "Ramanujan Hostel",
      "LatLng": LatLng(25.263271, 82.984804),
    },
    {
      "title": "Aryabhatta Hostel",
      "LatLng": LatLng(25.264109, 82.984266),
    },
    {
      "title": "S.N. Bose Hostel",
      "LatLng": LatLng(25.263361, 82.984020),
    },
    {
      "title": "Visvesvaraya Hostel",
      "LatLng": LatLng(25.262324, 82.984066),
    },
    {
      "title": "S.C Dey Hostel",
      "LatLng": LatLng(25.260016, 82.986522),
    },
    {
      "title": "Vivekananda Hostel",
      "LatLng": LatLng(25.259132, 82.986793),
    },
    {
      "title": "Vishwakarma Hostel",
      "LatLng": LatLng(25.257850, 82.985653),
    },
    {
      "title": "GSC(old) Hostel",
      "LatLng": LatLng(25.260617, 82.984292),
    },
    {
      "title": "GSC(ext) Hostel",
      "LatLng": LatLng(25.260247, 82.984530),
    },
    {
      "title": "New Girls Hostel",
      "LatLng": LatLng(25.261197, 82.983797),
    },
  ],
  "Departments": [
    {
      "title": "Electronics",
      "LatLng": LatLng(25.262838, 82.990496),
    },
    {
      "title": "CSE",
      "LatLng": LatLng(25.262479, 82.993714),
    },
    {
      "title": "MnC",
      "LatLng": LatLng(25.261849, 82.993503),
    },
    {
      "title": "Electrical",
      "LatLng": LatLng(25.261384, 82.992030),
    },
    {
      "title": "Mechanical",
      "LatLng": LatLng(25.261692, 82.991760),
    },
    {
      "title": "Civil",
      "LatLng": LatLng(25.262817, 82.991948),
    },
    {
      "title": "Ceramic",
      "LatLng": LatLng(25.259739, 82.992809),
    },
    {
      "title": "Engineering Physics",
      "LatLng": LatLng(25.259533, 82.992948),
    },
  ],
  "Others": [
    {
      "title": "Main library ",
      "LatLng": LatLng(25.261830, 82.989142),
    },
    {
      "title": "Technex office ",
      "LatLng": LatLng(25.261365, 82.986336),
    },
    {
      "title": "CCD ",
      "LatLng": LatLng(25.258250, 82.986543),
    },
    {
      "title": "GTAC ",
      "LatLng": LatLng(25.259733, 82.984981),
    },
    {
      "title": "Cafeteria ",
      "LatLng": LatLng(25.260441, 82.991436),
    },
    {
      "title": "Rajputana ground ",
      "LatLng": LatLng(25.262233, 82.987315),
    },
    {
      "title": "Gymkhana ",
      "LatLng": LatLng(25.259643, 82.988997),
    },
    {
      "title": "ADV ",
      "LatLng": LatLng(25.258719, 82.990153),
    },
  ],
  "Lecture Halls": [
    {
      "title": "ABLT ",
      "LatLng": LatLng(25.262779, 82.988583),
    },
    {
      "title": "LT3 ",
      "LatLng": LatLng(25.258845, 82.992690),
    },
  ],
};
