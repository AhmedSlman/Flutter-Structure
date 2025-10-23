import 'dart:io';

import 'package:flutter/material.dart';

import '../../../shared/widgets/item_of_contact.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../utils/utils.dart';
import '../alerts.dart';
import 'package:go_router/go_router.dart';

class AlertOfMedia extends StatelessWidget {
  const AlertOfMedia({
    super.key,
    required this.onCameraSelected,
    required this.onGallerySelected,
  });

  final ValueChanged<File?>? onCameraSelected;
  final ValueChanged<File?>? onGallerySelected;

  Future<void> _handleMediaSelection(
    BuildContext context,
    Future<File?> Function() pickMedia,
    ValueChanged<File?>? onMediaSelected,
  ) async {
    try {
      final File? selectedMedia = await pickMedia();
      context.pop(); // Close the dialog
      if (selectedMedia != null) {
        onMediaSelected?.call(selectedMedia);
      } else {
        Alerts.snack(
          state: SnackState.failed,
          text: 'no_image_selected'.tr(),
        );
      }
    } catch (e) {
      context.pop();
      Alerts.snack(
        state: SnackState.failed,
        text: 'error_picking_media'.tr(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _handleMediaSelection(
              context,
              Utils.media.pickImageFromCamera,
              onCameraSelected,
            ),
            child: ItemOfContact(
              title: 'camera'.tr(),
              choose: true,
              isImage: true,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _handleMediaSelection(
              context,
              Utils.media.pickImageFromGallery,
              onGallerySelected,
            ),
            child: ItemOfContact(
              title: 'gallery'.tr(),
              choose: false,
              isImage: true,
            ),
          ),
        ],
      ),
    );
  }
}
