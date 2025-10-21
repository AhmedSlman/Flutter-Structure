import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/Router/navigation_helper.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/utils/extentions.dart';

import '../../../../shared/widgets/customtext.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key, this.initialLocation});
  final LatLng? initialLocation;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController mapController;

  LatLng _center = const LatLng(45.521563, -120.677433);
  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _center = widget.initialLocation!;
    }
  }

  LatLng? _lastMapPosition;
  Marker marker = Marker(
    markerId: MarkerId('selectedLocation'),
    position: LatLng(45.521563, -122.677433),
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Position? _currentPosition;
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  List<Placemark> placemarks = [];
  void _onMapTapped(LatLng location) async {
    _lastMapPosition = location;
    mapController.animateCamera(CameraUpdate.newLatLng(location));

    setState(() {});
  }

  _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }

  // get location permission

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).pickLocation)),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
        onTap: _onMapTapped,
        onCameraMove: _onCameraMove,
        markers: _lastMapPosition != null
            ? {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _lastMapPosition!,
                ),
              }
            : {},
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        compassEnabled: true,
        myLocationEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: null,
            heroTag: null,
            onPressed: () async {
              await _getCurrentLocation();
              if (_currentPosition != null) {
                _lastMapPosition = LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                );
                mapController.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                  ),
                );
                setState(() {});
              }
            },
            tooltip: 'get current Location',
            child: Icon(Icons.location_on),
          ),
          8.ph,
          FloatingActionButton(
            key: null,
            heroTag: null,
            onPressed: () async {
              if (_lastMapPosition != null) {
                placemarks = await placemarkFromCoordinates(
                  _lastMapPosition!.latitude,
                  _lastMapPosition!.longitude,
                );
                NavigationService.pop(result: [_lastMapPosition, placemarks]);
              }
            },
            tooltip: 'Pick Location',
            child: Icon(Icons.flag),
            //  CustomText('Pick Location'.tr()),
          ),
        ],
      ),
    );
  }
}
