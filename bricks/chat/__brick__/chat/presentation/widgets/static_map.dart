import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/widgets/default_image_widget.dart';

class StaticMapPreview extends StatelessWidget {
  final double lat;
  final double lng;
  final double width;
  final double height;
  final int zoom;

  const StaticMapPreview({
    super.key,
    required this.lat,
    required this.lng,
    this.width = double.infinity,
    this.height = 150,
    this.zoom = 14,
  });

  /// URL صورة Google Maps Static API
  String get staticMapUrl =>
      "https://maps.googleapis.com/maps/api/staticmap?"
      "center=$lat,$lng"
      "&zoom=14"
      "&size=600x400"
      "&markers=color:green|$lat,$lng"
      "&key={{googleMapsKey}}"; /*  String get staticMapUrl =>
      "https://staticmap.openstreetmap.de/staticmap.php?"
      "center=$lat,$lng"
      "&zoom=$zoom"
      "&size=600x400"
      "&markers=$lat,$lng,red-pushpin"; */

  /// فتح جوجل ماب عند الإحداثيات
  Future<void> _openGoogleMaps() async {
    final googleUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open Google Maps";
    }
  }

  @override
  Widget build(BuildContext context) {
    log(staticMapUrl);
    return GestureDetector(
      onTap: _openGoogleMaps,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DefaultImageWidget(
          staticMapUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
