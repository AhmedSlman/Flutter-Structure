/*import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:masontest/shared/widgets/free_location.dart';

import 'location_picker_screen.dart';

class GlobalMapPickerWidget extends StatefulWidget {
  final Function(LatLng? latLang, Placemark? placeMark, String? fullAddress)?
  onLocationSelected;
  final Widget Function(
    LatLng? pickedLocation,
    List<Placemark>? placemarks,
    VoidCallback openLocationPicker,
    String? fullAddress,
  )
  builder;
  const GlobalMapPickerWidget({
    this.onLocationSelected,
    required this.builder,
    super.key,
  });

  @override
  State<GlobalMapPickerWidget> createState() => _GlobalMapPickerWidgetState();
}

class _GlobalMapPickerWidgetState extends State<GlobalMapPickerWidget> {
  LatLng? _pickedLocation;
  List<Placemark>? _placemarks;
  String? _fullAddresse;

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FreeLocationPickerScreen(),
        // builder: (_) => const FreeLocationPickerScreen(),
        //
      ),
    );

    if (result is List && result.length == 2) {
      setState(() {
        _pickedLocation = result[0] as LatLng;
        _placemarks = result[1] as List<Placemark>;
        final address = _placemarks?.first;
        final fullAddress = fullAddresse(address);
        _fullAddresse = fullAddress;
        widget.onLocationSelected?.call(_pickedLocation, address, fullAddress);
      });
    }
  }

  String fullAddresse(Placemark? place) {
    if (place == null) {
      return '';
    }
    return [
      place.subThoroughfare,
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.country,
    ].map((e) => e ?? '').where((e) => e.isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      _pickedLocation,
      _placemarks,
      _openLocationPicker,
      _fullAddresse,
    );
  }
}
*/
