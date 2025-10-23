import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'customtext.dart';

class DropDownItem<T> extends StatefulWidget {
  DropDownItem(
      {Key? key,
      required this.options,
      required this.onChanged,
      this.inistialValue,
      this.title,
      this.validator,
      this.radius,
      this.hint,
      this.color,
      this.hintColor,
      this.itemAsString})
      : super(key: key);
  List<T> options;
  final T? inistialValue;
  final String Function(T)? itemAsString;
  final String? hint;
  final String? Function(T?)? validator;
  final String? title;
  final double? radius;
  final Color? hintColor;
  final Color? color;
  Function(T) onChanged;

  @override
  State<DropDownItem<T>> createState() => _DropDownItemState<T>();
}

class _DropDownItemState<T> extends State<DropDownItem<T>> with AutomaticKeepAliveClientMixin {
  late final TextEditingController _controller;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.inistialValue?.toString());
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose(); // Prevent memory leaks
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; // Preserve state when scrolling

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return RepaintBoundary( // Optimize repaints
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Minimize rebuild area
          children: [
            if (widget.title?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ),
            SizedBox(
              height: 60,
              child: DropdownButtonFormField<T>(
                itemHeight: 50,
                validator: widget.validator,
                hint: CustomText(
                  widget.hint ?? '',
                  fontSize: 14,
                  color: widget.hintColor ?? Colors.grey,
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.radius ?? 10,
                      ),
                      borderSide: BorderSide(color: AppColors.primary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.radius ?? 10,
                      ),
                      borderSide: BorderSide(color: AppColors.border)),
                ),
                value: widget.inistialValue,
                items: widget.options
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: CustomText(
                            widget.itemAsString?.call(e) ?? e.toString(),
                            color: AppColors.textPrimary,
                          ),
                        ))
                    .toList(),
                onChanged: (s) {
                  if (s != null) {
                    widget.onChanged.call(s);
                  }
                }),
          )
        ],
      ),
    );
  }
}
