import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/extensions/context_extensions.dart';
import '../../shared/widgets/customtext.dart';
import 'animation_build_widget.dart';
import 'edit_text_widget.dart';

class PaginatedMultiSelectDropDown<T> extends StatefulWidget {
  const PaginatedMultiSelectDropDown({
    super.key,
    // required this.items,
    required this.onPage,
    required this.onChange,
    this.selectedItems,
    required this.itemAsString,
    this.shape,
    this.label,
    this.isRequired = false,
  });
  // item as String
  // final FutureOr<List<T>> Function() items;
  final Function(List<T>) onChange;
  final List<T>? selectedItems;
  final String Function(T) itemAsString;
  final ShapeBorder? shape;
  final String? label;
  final bool isRequired;
  final Future<List<T?>> Function(int page, String? search) onPage;
  @override
  State<PaginatedMultiSelectDropDown<T>> createState() =>
      _PaginatedMultiSelectDropDownState<T>();
}

class _PaginatedMultiSelectDropDownState<T>
    extends State<PaginatedMultiSelectDropDown<T>> {
  late List<T> selectedItems;
  final LayerLink _layerLink = LayerLink();
  bool _hasOpenedOverlay = false;
  OverlayEntry? _overlayEntry;
  PagingController<int, T> pagingController = PagingController<int, T>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    selectedItems = widget.selectedItems ?? [];

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PaginatedMultiSelectDropDown<T> oldWidget) {
    // selectedItems = pagingController.itemList ?? [];
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  String listItems(List<T> items) {
    String result = items
        .map((name) => widget.itemAsString.call(name).split(" ")[0])
        .join(" , ");
    return result;
  }

  addPageListers() {
    pagingController.addPageRequestListener(getItems);
  }

  TextEditingController search = TextEditingController();
  getItems(int pageKey) async {
    final List<T> newList =
        await widget.onPage(pageKey, search.text) as List<T>;

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
  void dispose() {
    pagingController.dispose();
    search.dispose();
    super.dispose();
  }

  addOrRemoveItem(T item) {
    selectedItems.any((element) => element == item)
        ? selectedItems.remove(item)
        : selectedItems.add(item);

    widget.onChange(selectedItems);
  }

  final GlobalKey _key = GlobalKey();
  Color mainColor = const Color(0xff939393);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: FormField<List<T>>(
        initialValue: selectedItems ?? [],
        validator:
            widget.isRequired
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select ${widget.label}";
                  }
                  return null;
                }
                : null,
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.label != null) ...[
                CustomText(
                  widget.label?.toString() ?? '',
                  color: Colors.black,
                  fontSize: 15,
                ),
                const SizedBox(height: 10),
              ],
              WillPopScope(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.hardEdge,
                      elevation: 0,
                      shape:
                          widget.shape ??
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(
                              width: 1,
                              color: context.primaryColor,
                            ),
                          ),
                      child: ListTile(
                        tileColor: Colors.white,
                        key: _key,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                        onTap: () {
                          openOverlay();
                        },
                        minLeadingWidth: 20,
                        title:
                            selectedItems.isEmpty
                                ? Text(
                                  widget.label?.toString() ?? "",
                                  style: TextStyle(
                                    color: mainColor,
                                    fontSize: 15,
                                  ),
                                )
                                : Wrap(
                                  spacing: 5,
                                  children:
                                      selectedItems
                                          .map(
                                            (e) => Chip(
                                              padding: EdgeInsets.zero,
                                              deleteIcon: Icon(
                                                Icons.clear,
                                                color: context.primaryColor,
                                                size: 20,
                                              ),
                                              onDeleted: () {
                                                addOrRemoveItem(e);
                                                setState(() {});
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                side: BorderSide(
                                                  color: context.primaryColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                              backgroundColor: context
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              label: Text(
                                                widget.itemAsString.call(e),
                                                style: TextStyle(
                                                  color: context.primaryColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                _hasOpenedOverlay
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                key: ValueKey(_hasOpenedOverlay),
                                color: context.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CustomText(
                state.errorText ?? "",
                color: Colors.red,
                fontSize: 15,
              ),
            ],
          );
        },
      ),
    );
  }

  // future
  Future<List<T>>? _future;
  void openOverlay() {
    // _future ??= Future.value(widget.items.call());
    addPageListers.call();
    // if (_overlayEntry == null) {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      maintainState: true,
      builder:
          (context) => AnimationAppearanceOpacity(
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
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
                    offset: Offset(0.0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: SizedBox(
                        height: 400,
                        child: StatefulBuilder(
                          builder: (context, set) {
                            return Card(
                              clipBehavior: Clip.hardEdge,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: const BorderSide(
                                  color: Color(0xff939393),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    // height: 70,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: TextFormFieldWidget(
                                      hintText: "search",
                                      controller: search,
                                      onFieldSubmitted: (value) {
                                        pagingController.refresh();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: PagedListView(
                                      padding: EdgeInsets.zero,
                                      pagingController: pagingController,
                                      builderDelegate: PagedChildBuilderDelegate<
                                        T
                                      >(
                                        itemBuilder: (context, item, index) {
                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                ),
                                            shape: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black26,
                                              ),
                                            ),
                                            onTap: () {
                                              addOrRemoveItem(item);
                                              setState(() {});
                                              set(() {});
                                            },
                                            title: Text(
                                              widget.itemAsString.call(item),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                            // tileColor: selectedItems.any((element) => element == items.data![index])
                                            //     ? AppColors.lightGrey
                                            //     : Colors.transparent,
                                            trailing: Icon(
                                              selectedItems.any(
                                                    (element) =>
                                                        element == item,
                                                  )
                                                  ? Icons.check_box
                                                  : Icons
                                                      .check_box_outline_blank,
                                              color: context.primaryColor,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              closeOverlay();
                                            },
                                            child: const Text(
                                              "Ok",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
    // }
    if (!_hasOpenedOverlay) {
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _hasOpenedOverlay = true);
    }
  }

  void closeOverlay() {
    if (_hasOpenedOverlay) {
      _overlayEntry!.remove();
      pagingController.removePageRequestListener(getItems);
      setState(() {
        _hasOpenedOverlay = false;
      });
    }
  }

  InputBorder borderType() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: context.primaryColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );
  }
}
