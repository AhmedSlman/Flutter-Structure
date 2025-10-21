import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ezdehar/core/Router/Router.dart';
import 'package:ezdehar/core/app_strings/locale_keys.dart';
import 'package:ezdehar/core/theme/light_theme.dart';
import 'package:ezdehar/features/chat/cubit/chat_cubit.dart';
import 'package:ezdehar/shared/widgets/location_picker_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Bottom sheet for attachment options (Camera, PDF)
class AttachmentOptionsSheet extends StatelessWidget {
  final BuildContext parentContext;
  final ChatCubit cubit;
  final TextEditingController messageController;
  final Function(ChatCubit cubit, File? file) sendMessage;
  final Function(LatLng? location) onLocationSelect;
  final VoidCallback onCameraSelected;

  const AttachmentOptionsSheet({
    super.key,
    required this.parentContext,
    required this.cubit,
    required this.messageController,
    required this.sendMessage,
    required this.onCameraSelected,
    required this.onLocationSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCameraOption(context),
          _buildPDFOption(context),
          _buildLocationOption(context),
        ],
      ),
    );
  }

  /// Camera/Gallery option
  Widget _buildCameraOption(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LightThemeColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.camera_alt, color: LightThemeColors.primary),
      ),
      title: Text(LocaleKeys.camera.tr()),
      onTap: () {
        Navigator.pop(context);
        onCameraSelected();
      },
    );
  }

  /// Location option
  Widget _buildLocationOption(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LightThemeColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.location_on, color: LightThemeColors.primary),
      ),
      title: Text("selctLocation".tr()),
      onTap: () async {
        Navigator.pop(context);

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LocationPickerScreen(),
            // builder: (_) => const FreeLocationPickerScreen(),
            //
          ),
        );

        if (result is List && result.length == 2) {
          final pickedLocation = result[0] as LatLng;
          onLocationSelect(pickedLocation);
        }
      },
    );
  }

  /// PDF option
  Widget _buildPDFOption(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.picture_as_pdf, color: Colors.red),
      ),
      title: const Text("مستند PDF"),
      onTap: () async {
        Navigator.pop(context);
        await _pickPDF();
      },
    );
  }

  /// Pick PDF file
  Future<void> _pickPDF() async {
    await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"])
        .then((val) {
          if (val != null) {
            Navigator.pushNamed(
              parentContext,
              Routes.FullImageScreen,
              arguments: ImageArgs(
                image: File(val.xFiles.first.path),
                sendFunction: (image, text) async {
                  Navigator.pop(parentContext);
                  messageController.text = text ?? "";
                  sendMessage(cubit, image);
                },
              ),
            );
          }
        });
  }
}
