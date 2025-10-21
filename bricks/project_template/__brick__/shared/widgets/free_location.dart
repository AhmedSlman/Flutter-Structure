/*import 'dart:developer';

 
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:masontest/core/services/alerts.dart';
import 'package:masontest/core/utils/extentions.dart';
import 'package:masontest/shared/widgets/customtext.dart';
import 'package:latlong2/latlong.dart' as LL;

class FreeLocationPickerScreen extends StatefulWidget {
  const FreeLocationPickerScreen({super.key, this.initPoint});
  final LL.LatLng? initPoint;

  @override
  State<FreeLocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<FreeLocationPickerScreen> {
  Position? _currentPosition;
  String? _currentAddress;
  LL.LatLng? _lastMapPosition;
  final MapController _mapController = MapController();
  @override
  void initState() {
    if (widget.initPoint != null) {
      _lastMapPosition = LL.LatLng(
        widget.initPoint!.latitude,
        widget.initPoint!.longitude,
      );
    }
    super.initState();
  }

  List<Placemark> placemarks = [];
  _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
    _mapController.move(
      LL.LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      15.0, // Zoom level
    );
  }

  void _confirmLocation() {
    if (_lastMapPosition != null) {
      Navigator.pop(context, [
        LL.LatLng(_lastMapPosition!.latitude, _lastMapPosition!.longitude),
        //  {'latitude': _selectedLocation!.latitude, 'longitude': _selectedLocation!.longitude},
        _currentAddress,
      ]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: CustomText('Please select a location first.'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText("حدد مكانك")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: null,
            heroTag: null,
            onPressed: () async {
              await _getCurrentLocation();
              if (_currentPosition != null) {
                _lastMapPosition = LL.LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                );

                setState(() {});
              }
            },
            tooltip: 'get current Location',
            child: const Icon(Icons.location_on),
          ),
          8.ph,
          FloatingActionButton(
            key: null,
            heroTag: null,
            onPressed: () async {
              if (_lastMapPosition == null) {
                Alerts.snack(
                  text: "يجب تحديد المكان اولا",
                  state: SnackState.failed,
                );
                return;
              }
              placemarks = await placemarkFromCoordinates(
                _lastMapPosition!.latitude,
                _lastMapPosition!.longitude,
              );
              if (placemarks.isEmpty) {
                Alerts.snack(
                  text: "يجب تحديد مكان اخر",
                  state: SnackState.failed,
                );
                return;
              }
              log(placemarks[0].toString(), name: "placeMark");
              Navigator.pop(context, [_lastMapPosition, placemarks]);
            },
            tooltip: 'Pick Location',
            child: const Icon(Icons.flag),
            //  CustomText('Pick Location' ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    toLatLngs(_currentPosition) ??
                    const LL.LatLng(24.7136, 46.6753),
                minZoom: 2.0,
                maxZoom: 18,
                initialZoom: 8,
                onTap: (tapPosition, point) {
                  setState(() {
                    _lastMapPosition = LL.LatLng(
                      point.latitude,
                      point.longitude,
                    );
                    _currentPosition = toPosition(point);
                  });
                  log(_lastMapPosition.toString(), name: "lastMapPosition");
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.yourapp',
                ),
                if (_currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: toLatLngs(_currentPosition)!,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          /*    Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 60),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText("حدد مكانك", weight: FontWeight.bold),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Placemark>>(
                    future:
                        _lastMapPosition != null
                            ? placemarkFromCoordinates(
                              _lastMapPosition!.latitude,
                              _lastMapPosition!.longitude,
                            )
                            : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final place = snapshot.data!.first;
                        log(place.toString(), name: "place");
                        return CustomText(fullAddresse(place));
                      } else {
                        return CustomText("اضغط على الخريطة لتحديد الموقع");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
       */
        ],
      ),
    );
  }

  String fullAddresse(Placemark place) {
    return [
      place.subThoroughfare,
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.country,
    ].map((e) => e ?? '').where((e) => e.isNotEmpty).join(', ');
  }
}

Position toPosition(LL.LatLng point) {
  return Position(
    longitude: point.longitude,
    latitude: point.latitude,
    timestamp: DateTime.now(),
    accuracy: 0.1,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

LL.LatLng? toLatLngs(Position? position) {
  if (position == null) {
    return null;
  }
  return LL.LatLng(position.latitude, position.longitude);
}
*/

import 'default_image_widget.dart';

Widget buildStaticMap({
  required double lat,
  required double lng,
  double width = double.infinity,
  double height = 150,
}) {
  final staticMapUrl =
      "https://maps.googleapis.com/maps/api/staticmap?"
      "center=$lat,$lng"
      "&zoom=15"
      "&size=600x400"
      "&markers=color:red|$lat,$lng"
      "&key=AIzaSyAQqMr2FETas5l0ua7zSAzH9MunnyXJD58";

  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: DefaultImageWidget(
      staticMapUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
    ),
  );
}
