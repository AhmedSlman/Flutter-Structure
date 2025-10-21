import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/extensions/context_extensions.dart';
import '../../shared/widgets/customtext.dart';
import 'edit_text_widget.dart';

class PagedCustomAutoCompleteTextField<T> extends StatefulWidget {
  const PagedCustomAutoCompleteTextField(
      {super.key,
      this.initialValue,
      this.lable,
      this.showClearIcon = false,
      this.showSufix = false,
      this.showLabel = false,
      this.showRequiredStar = false,
      this.keepSuggestionAftertSelect = false,
      this.removeSelectedItem = false,
      required this.onChanged,
      this.onClear,
      // required this.function,
      this.itemAsString,
      this.flex = 1,
      this.hideOnLoading = false,
      this.controller,
      this.enabled = true,
      this.hint,
      this.validator,
      this.padding,
      this.border,
      required this.onPage,
      this.itemBuilder,
      this.direction = AxisDirection.down,
      this.showAboveField = false,
      this.emptyWidget,
      this.borderRaduis,
      this.borderColor,
      this.prefixIcon,
      this.refreshOnTap = true,
      this.searchInApi = true,
      this.localData = false,
      this.contentPadding});
  final Function(T) onChanged;
  final bool showSufix;
  final Widget? prefixIcon;
  final String? lable;
  final String? hint;
  final String? initialValue;
  // final FutureOr<Iterable<T>> Function(String) function;
  final VoidCallback? onClear;
  final bool showClearIcon;
  final bool enabled;
  final Color? borderColor;
  final double? borderRaduis;
  final bool showLabel;
  final bool hideOnLoading;
  final bool showRequiredStar;
  final bool removeSelectedItem;
  final AxisDirection direction;
  final bool keepSuggestionAftertSelect;
  final TextEditingController? controller;
  final String Function(T)? itemAsString;
  final int flex;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  final InputBorder? border;
  final bool showAboveField;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? contentPadding;
  final Widget Function(BuildContext, T)? itemBuilder;
  final bool searchInApi;
  final bool refreshOnTap;
  final Future<List<T?>> Function(int page, String? search) onPage;

  final bool localData;
  @override
  State<PagedCustomAutoCompleteTextField<T>> createState() =>
      _CutomAutoCompleteTextFeildState<T>();
}

class _CutomAutoCompleteTextFeildState<T>
    extends State<PagedCustomAutoCompleteTextField<T>> {
  late TextEditingController controller;
  final LayerLink _layerLink = LayerLink();
  bool _hasOpenedOverlay = false;
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  String? selectedItem;
  List<T> suggestions = [];
  List<T> searchedSuggestions = [];
  PagingController<int, T> pagingController =
      PagingController<int, T>(firstPageKey: 1);
  addPageListers() {
    pagingController.addPageRequestListener(getItems);
  }

  getItems(int pageKey) async {
    final List<T> newList =
        await widget.onPage(pageKey, controller.text) as List<T>;

    if (newList != null) {
      var isLastPage = newList.length == 0;

      if (isLastPage) {
        // stop
        pagingController.appendLastPage(newList);
      } else {
        // increase count to reach new page
        var nextPageKey = pageKey + 1;
        pagingController.appendPage(newList, nextPageKey);
      }
    } else {
      pagingController.error = "error";
    }
    setState(() {});
  }

  @override
  void initState() {
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    selectedItem = widget.controller?.text;
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    _overlayEntry?.dispose();
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding ??
            const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showLabel) ...[
              Row(
                children: [
                  CustomText(
                    widget.lable.toString(),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (widget.showRequiredStar)
                    CustomText(
                      "*",
                      color: Colors.red,
                    )
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
            IgnorePointer(
                ignoring: !widget.enabled,
                child: WillPopScope(
                  onWillPop: () async {
                    if (_hasOpenedOverlay) {
                      closeOverlay();
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RawKeyboardListener(
                              focusNode: _focusNode,
                              onKey: (event) {
                                if (event.isKeyPressed(
                                    LogicalKeyboardKey.arrowDown)) {
                                  if (hightlightIndex <
                                      searchedSuggestions.length - 1) {
                                    hightlightIndex++;
                                    rebuildOverlay();
                                  }
                                } else if (event
                                    .isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                                  if (hightlightIndex > 0) {
                                    hightlightIndex--;
                                    rebuildOverlay();
                                  }
                                } else if (event
                                    .isKeyPressed(LogicalKeyboardKey.enter)) {
                                  if (widget.keepSuggestionAftertSelect ==
                                      false) {
                                    selectedItem = widget.itemAsString?.call(
                                            searchedSuggestions[
                                                hightlightIndex]) ??
                                        searchedSuggestions[hightlightIndex]
                                            .toString();
                                    closeOverlay();
                                  }
                                  widget.onChanged(
                                      searchedSuggestions[hightlightIndex]);
                                }
                              },
                              child: TextFormFieldWidget(
                                  key: _key,
                                  activeBorderColor: widget.borderColor ??
                                      context.primaryColor,
                                  borderRadius: widget.borderRaduis ?? 30,
                                  // readOnly: widget.disableSearch,
                                  hintText: widget.hint,
                                  // backgroundColor: Colors.grey.withOpacity(0.4),
                                  label: widget.showLabel ? null : widget.lable,
                                  prefixWidget: widget.prefixIcon,
                                  password: false,
                                  suffixWidget: (widget.showClearIcon)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: IconButton(
                                            onPressed: () {
                                              widget.onClear?.call();
                                              controller.text = "";
                                              selectedItem = null;
                                            },
                                            icon: const Icon(Icons.clear),
                                          ),
                                        )
                                      : null,
                                  suffixIcon: widget.showSufix
                                      ? const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                            )
                                          ],
                                        )
                                      : null,
                                  controller: controller,
                                  onChanged: (s) {
                                    if (!_hasOpenedOverlay) openOverlay();
                                    if (widget.searchInApi) {
                                      updateSuggestions(s);
                                    } else {
                                      searchedSuggestions = suggestions
                                          .where((element) =>
                                              widget.itemAsString
                                                  ?.call(element)
                                                  .toLowerCase()
                                                  .contains(s.toLowerCase()) ??
                                              true)
                                          .toList();
                                      rebuildOverlay();
                                    }
                                  },
                                  onTap: () {
                                    openOverlay();
                                    updateSuggestions(controller.text,
                                        refresh: widget.refreshOnTap);
                                  },
                                  // onEditingComplete: () => closeOverlay(),
                                  validator: widget.validator != null
                                      ? (value) => widget.validator!(value)
                                      : null //
                                  ),
                            )
                          ])),
                )),
          ],
        ));
  }

  int hightlightIndex = 0;
  void closeOverlay() {
    pagingController.removePageRequestListener(getItems);
    if (_hasOpenedOverlay) {
      if (selectedItem != null) {
        controller.text = selectedItem ?? "";
      } else {
        controller.text = "";
      }
      _overlayEntry!.remove();
      setState(() {
        _hasOpenedOverlay = false;
      });
    }
  }

  final FocusNode _focusNode = FocusNode();
//global key
  final GlobalKey _key = GlobalKey();
  void openOverlay() {
    controller.text = '';
    addPageListers.call();
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
        builder: (context) => suggestionList(offset, size, context));
    if (_hasOpenedOverlay == false) {
      print("object");
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _hasOpenedOverlay = true);
    }
  }

  Stack suggestionList(Offset offset, Size size, BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.5;
    return Stack(children: [
      ModalBarrier(
        onDismiss: () {
          closeOverlay();
        },
      ),
      Positioned(
          left: offset.dx,
          top: offset.dy + size.height,
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, widget.showAboveField ? -h : size.height + 5),
            child: SizedBox(
              height: 400,
              child: Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: EdgeInsets.zero,
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                  child: PagedListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    padding: EdgeInsets.zero,
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate<T>(
                      itemBuilder: (context, item, index) {
                        return InkWell(
                          onTap: () {
                            if (widget.keepSuggestionAftertSelect == false) {
                              selectedItem = widget.itemAsString?.call(item) ??
                                  searchedSuggestions[index].toString();

                              hightlightIndex = index;
                              closeOverlay();
                            }
                            widget.onChanged(item);
                          },
                          child: widget.itemBuilder?.call(context, item) ??
                              ListTile(
                                  tileColor: hightlightIndex == index
                                      ? Colors.grey.withOpacity(0.2)
                                      : null,
                                  shape: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  title: SelectionContainer.disabled(
                                    child: Text(
                                        widget.itemAsString?.call(item) ??
                                            item.toString()),
                                  )),
                        );
                      },
                    ),
                  )

                  /*      ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3),
                  child: _isLoading
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ))
                      : searchedSuggestions.isEmpty
                          ? widget.emptyWidget ??
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("No Items"),
                              )
                          : Scrollbar(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: searchedSuggestions.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          if (widget.keepSuggestionAftertSelect ==
                                              false) {
                                            selectedItem = widget.itemAsString
                                                    ?.call(searchedSuggestions[
                                                        index]) ??
                                                searchedSuggestions[index]
                                                    .toString();
            
                                            hightlightIndex = index;
                                            closeOverlay();
                                          }
                                          widget.onChanged(
                                              searchedSuggestions[index]);
                                        },
                                        child: widget.itemBuilder?.call(context,
                                                searchedSuggestions[index]) ??
                                            ListTile(
                                                tileColor: hightlightIndex ==
                                                        index
                                                    ? Colors.grey.withOpacity(0.2)
                                                    : null,
                                                shape: const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey)),
                                                title:
                                                    SelectionContainer.disabled(
                                                  child: Text(widget.itemAsString
                                                          ?.call(
                                                              searchedSuggestions[
                                                                  index]) ??
                                                      searchedSuggestions[index]
                                                          .toString()),
                                                )),
                                      )),
                            ),
                ),
                      */
                  ),
            ),
          ))
    ]);
  }

  void rebuildOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  Future<void> updateSuggestions(String input, {bool refresh = false}) async {
    // if (widget.searchInApi == false && suggestions.isNotEmpty && !refresh) {
    //   searchedSuggestions = suggestions
    //       .where((element) =>
    //           widget.itemAsString
    //               ?.call(element)
    //               .toLowerCase()
    //               .contains(input.toLowerCase()) ??
    //           true)
    //       .toList();
    //   rebuildOverlay();
    //   return;
    // }
    // setState(() => _isLoading = true);

    if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
    _debounce =
        Timer(Duration(milliseconds: widget.localData ? 0 : 600), () async {
      pagingController.refresh();
      // suggestions = (await widget.function.call(input)).toList();
      // searchedSuggestions = suggestions
      //     .where((element) =>
      //         widget.itemAsString
      //             ?.call(element)
      //             .toLowerCase()
      //             .contains(input.toLowerCase()) ??
      //         true)
      //     .toList();

      setState(() {
        _isLoading = false;
      });
      rebuildOverlay();
    });
  }
}
