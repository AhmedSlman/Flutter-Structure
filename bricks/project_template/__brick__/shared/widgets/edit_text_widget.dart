import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/resources/font_manager.dart';
import '../../core/services/media/alert_of_media.dart';
import '../../core/utils/utils.dart';
import '../../core/services/alerts.dart';
import '../../core/theme/light_theme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/extensions/all_extensions.dart';
import 'location_picker_screen.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String? hintText, label, errorText;
  final TextInputType type;
  final bool password;
  final DateTime? startdate;
  final DateTime? enddate;
  final List<TextInputFormatter>? inputFormatters;
  final bool expanded;
  final Color activeBorderColor, borderColor, hintColor;
  final bool floatingHint;
  final int? maxLines;
  final int? minLines;
  final String? helperText;
  final Color? backgroundColor;
  final void Function()? onTap;
  final Function(DateTime date)? onDateSelected;
  FocusNode? focusNode;
  TextAlign textalign;
  int? maxLengh;
  TextDirection? textdirection;
  EdgeInsetsDirectional? contentPadding;
  double borderRadius;
  double? hintSize;
  String? prefixIcon;
  Widget? suffixIcon, suffixWidget, prefixWidget;
  TextEditingController? controller;
  InputDecoration? inputDecoration;
  ValueChanged<String>? onChanged;
  ValueChanged<String?>? onSaved;
  ValueChanged<String?>? onFieldSubmitted;
  String? Function(String?)? validator;
  bool? isOutline;
  bool? enable;
  bool? readOnly;
  final bool enableMapPicker;
  final bool enableFilePicker;
  final bool enableDatePicker;
  final bool enableImagePicker;

  final Function(File image)? onImageSelected;
  final Function()? onImageDeleted;
  final Function(LatLng? latLang, Placemark? placeMark)? onLocationSelected;

  TextFormFieldWidget({
    this.onChanged,
    this.onSaved,
    this.onDateSelected,
    this.isOutline,
    this.readOnly,
    this.onFieldSubmitted,
    this.hintSize,
    this.enable,
    this.validator,
    this.onTap,
    this.prefixWidget,
    this.password = false,
    this.expanded = false,
    this.floatingHint = false,
    this.type = TextInputType.text,
    this.hintText = "",
    this.label,
    this.textalign = TextAlign.start,
    this.maxLengh,
    this.errorText,
    this.controller,
    this.activeBorderColor = AppColors.primary,
    this.borderRadius = 30.0,
    this.borderColor = Colors.black,
    this.backgroundColor,
    this.hintColor = AppColors.textHint,
    this.maxLines,
    this.minLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.inputDecoration,
    this.contentPadding,
    this.textdirection,
    this.onImageSelected,
    this.onImageDeleted,
    this.onLocationSelected,
    super.key,
    this.inputFormatters,
    this.helperText,
    this.startdate,
    this.enddate,
  })  : enableMapPicker = false,
        enableFilePicker = false,
        enableDatePicker = false,
        enableImagePicker = false;
  TextFormFieldWidget.datePicker({
    super.key,
    this.startdate,
    this.enddate,
    this.onDateSelected,
    this.controller,
    this.hintText = "Select Date",
    this.label,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.expanded = false,
    this.floatingHint = false,
    this.activeBorderColor = Colors.transparent,
    this.borderRadius = 15.0,
    this.borderColor = Colors.transparent,
    this.backgroundColor = const Color(0xffF6F6F6),
    this.hintColor = AppColors.textHint,
    this.inputDecoration,
    this.contentPadding,
    this.textdirection,
  })  : enableDatePicker = true,
        enableMapPicker = false,
        enableFilePicker = false,
        enableImagePicker = false,
        onChanged = null,
        onSaved = null,
        isOutline = null,
        readOnly = true,
        onFieldSubmitted = null,
        hintSize = null,
        enable = true,
        validator = null,
        onTap = null,
        prefixWidget = null,
        password = false,
        textalign = TextAlign.start,
        maxLengh = null,
        maxLines = 1,
        minLines = 1,
        inputFormatters = null,
        suffixWidget = null,
        type = TextInputType.text,
        onImageSelected = null,
        onImageDeleted = null,
        onLocationSelected = null;
  TextFormFieldWidget.filePicker({
    super.key,
    this.onTap,
    this.onChanged,
    this.onSaved,
    this.controller,
    this.hintText = "Select File",
    this.label,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.expanded = false,
    this.floatingHint = false,
    this.activeBorderColor = Colors.transparent,
    this.borderRadius = 15.0,
    this.borderColor = Colors.transparent,
    this.backgroundColor = const Color(0xffF6F6F6),
    this.hintColor = AppColors.textHint,
    this.inputDecoration,
    this.contentPadding,
    this.textdirection,
  })  : enableFilePicker = true,
        enableDatePicker = false,
        enableMapPicker = false,
        enableImagePicker = false,
        onDateSelected = null,
        onImageSelected = null,
        onImageDeleted = null,
        onLocationSelected = null,
        startdate = null,
        enddate = null,
        readOnly = true,
        isOutline = null,
        hintSize = null,
        enable = true,
        prefixWidget = null,
        password = false,
        textalign = TextAlign.start,
        maxLengh = null,
        maxLines = 1,
        minLines = 1,
        inputFormatters = null,
        suffixWidget = null,
        type = TextInputType.text;
  TextFormFieldWidget.mediaPicker({
    super.key,
    this.onChanged,
    this.onSaved,
    this.controller,
    this.hintText = "Select Image",
    this.label,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.expanded = false,
    this.floatingHint = false,
    this.activeBorderColor = Colors.transparent,
    this.borderRadius = 15.0,
    this.borderColor = Colors.transparent,
    this.backgroundColor = const Color(0xffF6F6F6),
    this.hintColor = AppColors.textHint,
    this.inputDecoration,
    this.contentPadding,
    this.textdirection,
    this.onImageSelected,
    this.onImageDeleted,
  })  : onTap = null,
        enableImagePicker = true,
        enableFilePicker = false,
        enableDatePicker = false,
        enableMapPicker = false,
        onDateSelected = null,
        onLocationSelected = null,
        startdate = null,
        enddate = null,
        readOnly = true,
        isOutline = null,
        hintSize = null,
        enable = true,
        prefixWidget = null,
        password = false,
        textalign = TextAlign.start,
        maxLengh = null,
        maxLines = 1,
        minLines = 1,
        inputFormatters = null,
        suffixWidget = null,
        type = TextInputType.text;
  TextFormFieldWidget.mapPicker({
    super.key,
    this.onTap,
    this.onChanged,
    this.onSaved,
    this.controller,
    this.hintText = "Select Location",
    this.label,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.expanded = false,
    this.floatingHint = false,
    this.activeBorderColor = Colors.transparent,
    this.borderRadius = 15.0,
    this.borderColor = Colors.transparent,
    this.backgroundColor = const Color(0xffF6F6F6),
    this.hintColor = AppColors.textHint,
    this.inputDecoration,
    this.contentPadding,
    this.textdirection,
    this.onLocationSelected,
  })  : enableMapPicker = true,
        enableImagePicker = false,
        enableFilePicker = false,
        enableDatePicker = false,
        onDateSelected = null,
        onImageSelected = null,
        onImageDeleted = null,
        startdate = null,
        enddate = null,
        readOnly = true,
        isOutline = null,
        hintSize = null,
        enable = true,
        prefixWidget = null,
        password = false,
        textalign = TextAlign.start,
        maxLengh = null,
        maxLines = 1,
        minLines = 1,
        inputFormatters = null,
        suffixWidget = null,
        type = TextInputType.text;
  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool passHidden = true;
  LatLng? _pickedLocation;
  List<Placemark>? _placemarks;
  File? pickedImage;

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LocationPickerScreen()),
    );

    if (result is List && result.length == 2) {
      setState(() {
        _pickedLocation = result[0] as LatLng;
        _placemarks = result[1] as List<Placemark>;
        final address = _placemarks?.first;
        widget.controller?.text =
            "${address?.name}, ${address?.locality}, ${address?.country}";
        widget.onLocationSelected?.call(_pickedLocation, address);
      });
    }
  }

  void onImageSelected(File? image) {
    if (image != null) {
      setState(() {
        pickedImage = image;
        widget.onImageSelected?.call(image);
        widget.controller?.text = "Image Selected: ${image.path}";
      });
    }
  }

  List<File>? files = [];
  Future<void> _pickFile() async {
    files = await Utils.media.pickFiles();
  }

  Future<void> _pickImage() async {
    Alerts.bottomSheet(
      context,
      child: AlertOfMedia(
        onCameraSelected: onImageSelected,
        onGallerySelected: onImageSelected,
      ),
    );
  }

  DateTime? _selectedDate; // New state variable for the selected date

  Future<void> _pickDate() async {
    final DateTime? initialDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.startdate ?? initialDate,
      firstDate: widget.startdate ?? DateTime(initialDate!.year - 10),
      lastDate: widget.enddate ?? DateTime(initialDate!.year + 10),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.controller?.text = "${picked.toLocal()}".split(' ')[0];
        widget.onDateSelected?.call(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppStyles.labelStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          10.height,
        ],
        TextFormField(
          onTap: () {
            print(widget.enableImagePicker);
            if (widget.enableMapPicker) {
              _openLocationPicker();
            } else if (widget.enableDatePicker) {
              _pickDate(); // Open the date picker
            } else if (widget.enableImagePicker) {
              _pickImage.call();
            } else if (widget.enableFilePicker) {
              _pickFile.call();
            } else {
              widget.onTap?.call();
            }
          },
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          cursorColor: context.colorScheme.primary,
          readOnly: (widget.readOnly ?? false) ||
              widget.enableMapPicker ||
              widget.enableImagePicker,
          enabled: widget.enable ?? true,

          /// VALIDATOR
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          maxLength: widget.maxLengh,
          focusNode: widget.focusNode,
          controller: widget.controller,

          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
          textAlign: widget.textalign,
          textDirection: widget.textdirection,
          style: context.bodySmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: widget.inputDecoration ??
              InputDecoration(
                contentPadding: widget.contentPadding ??
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                filled: true,
                fillColor: widget.backgroundColor ?? context.formFieldColor,
                prefixIcon: widget.prefixIcon?.toSvg(),
                prefix: widget.prefixWidget,
                suffix: widget.suffixWidget,
                suffixIcon: widget.suffixIcon ??
                    (widget.password
                        ? IconButton(
                            onPressed: () =>
                                setState(() => passHidden = !passHidden),
                            icon: Icon(
                              passHidden
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off,
                              color:
                                  context.colorScheme.primary.withOpacity(.5),
                            ),
                          )
                        : null),
                errorText: widget.errorText,
                helperText: widget.helperText,
                border: borderType(),
                focusedBorder: borderType(),
                enabledBorder: borderType(),
                errorBorder: borderType(),
                hintStyle: TextStyle(
                  color: widget.hintColor,
                  fontSize: widget.hintSize ?? 14,
                  fontWeight: FontWeight.w400,
                ),
                hintText: widget.hintText,
              ),
          keyboardType: widget.type,
          obscureText: passHidden && widget.password,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
        if (pickedImage != null) ...[
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                File(pickedImage!.path),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    pickedImage = null; // Remove the image
                    widget.controller?.clear(); // Clear the text field
                    widget.onImageDeleted?.call();
                  });
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  InputBorder borderType() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: widget.activeBorderColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    );
  }
}
