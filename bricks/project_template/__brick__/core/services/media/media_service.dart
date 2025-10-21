import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import '../../../shared/widgets/customtext.dart';
import '../../../shared/widgets/button_widget.dart';
import '../navigation_service.dart';
import '../../localization/localization_helper.dart';
import '../../utils/utils.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  /// Pick multiple or single images from the gallery
  Future<List<File>?> pickImages({bool isMultiple = true}) async {
    try {
      final images = isMultiple
          ? await _picker.pickMultiImage()
          : [
              await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 100,
                maxWidth: 1080,
              ),
            ];
      return images.map((xfile) => File(xfile?.path ?? "")).toList();
    } catch (e) {
      log('Error picking images: $e');
      final permissionGranted = await _handlePermission(Permission.photos);
      if (permissionGranted) {
        return pickImages(isMultiple: isMultiple);
      }
      return null;
    }
  }

  /// Pick a single image from the gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1080,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      final permissionGranted = await _handlePermission(Permission.photos);
      if (permissionGranted) {
        return pickImageFromGallery();
      }
      return null;
    }
  }

  /// Pick a single image from the camera
  Future<File?> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 1080,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Error picking image from camera: $e');
      final permissionGranted = await _handlePermission(Permission.camera);
      if (permissionGranted) {
        return pickImageFromCamera();
      }
      return null;
    }
  }

  /// Pick files with file picker
  Future<List<File>?> pickFiles({bool allowMultiple = true}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
      );
      if (result != null) {
        return result.paths.map((path) => File(path!)).toList();
      }
      return null;
    } catch (e) {
      print('Error picking files: $e');
      final permissionGranted = await _handlePermission(Permission.storage);
      if (permissionGranted) {
        return pickFiles(allowMultiple: allowMultiple);
      }
      return null;
    }
  }

  /// Handle permissions for storage, camera, or photos
  Future<bool> _handlePermission(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      await _openSettingsPermissionDialog();
      return false;
    }
    return false;
  }

  /// Open dialog to guide the user to app settings
  Future<void> _openSettingsPermissionDialog() {
    return showDialog(
      context: NavigationService.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(LocalizationHelper.tr.permissionRequired),
          content: CustomText(LocalizationHelper.tr.enablePermissions),
          actions: [
            TextButtonWidget(
              function: () => NavigationService.pop(),
              text: LocalizationHelper.tr.cancel,
            ),
            TextButtonWidget(
              function: () =>
                  openAppSettings().then((_) => NavigationService.pop()),
              text: LocalizationHelper.tr.settings,
            ),
          ],
        );
      },
    );
  }
}
