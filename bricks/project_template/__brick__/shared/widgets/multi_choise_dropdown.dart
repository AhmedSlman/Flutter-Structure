// import 'dart:async';

// import 'package:flutter/material.dart';

// import '../../core/utils/extentions.dart';
// import 'animation_build_widget.dart';
// import 'customtext.dart';

// class MultiSelectDropDown<T> extends StatefulWidget {
//   const MultiSelectDropDown({
//     super.key,
//     required this.items,
//     required this.onChange,
//     this.selectedItems,
//     required this.itemAsString,
//     this.shape,
//     this.label,
//     this.isRequired = false,
//   });
//   // item as String
//   final FutureOr<List<T>> Function() items;
//   final Function(List<T>) onChange;
//   final List<T>? selectedItems;
//   final String Function(T) itemAsString;
//   final ShapeBorder? shape;
//   final String? label;
//   final bool isRequired;
//   @override
//   State<MultiSelectDropDown<T>> createState() => _MultiSelectDropDownState<T>();
// }

// class _MultiSelectDropDownState<T> extends State<MultiSelectDropDown<T>> {
//   late List<T> selectedItems;
//   final LayerLink _layerLink = LayerLink();
//   bool _hasOpenedOverlay = false;
//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     selectedItems = widget.selectedItems ?? [];

//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant MultiSelectDropDown<T> oldWidget) {
//     selectedItems = widget.selectedItems ?? [];
//     setState(() {});
//     super.didUpdateWidget(oldWidget);
//   }

//   String listItems(List<T> items) {
//     String result = items
//         .map((name) => widget.itemAsString.call(name).split(" ")[0])
//         .join(" , ");
//     return result;
//   }

//   addOrRemoveItem(T item) {
//     selectedItems.any((element) => element == item)
//         ? selectedItems.remove(item)
//         : selectedItems.add(item);

//     widget.onChange(selectedItems);
//   }

//   final GlobalKey _key = GlobalKey();
//   Color mainColor = const Color(0xff939393);
//   @override
//   Widget build(BuildContext context) {
//     return FormField<List<T>>(
//         initialValue: selectedItems,
//         validator: widget.isRequired
//             ? (value) {
//                 if (value == null || value.isEmpty) {
//                   return "please Choose ${widget.label}";
//                 }
//                 return null;
//               }
//             : null,
//         builder: (state) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (widget.label != null || widget.label?.isNotEmpty == true) ...[
//                 CustomText(
//                   widget.label.toString(),
//                   weight: FontWeight.bold,
//                 ),
//                 const SizedBox(height: 10),
//               ],
//               WillPopScope(
//                 onWillPop: () async {
//                   if (_hasOpenedOverlay) {
//                     closeOverlay();
//                     return false;
//                   } else {
//                     return true;
//                   }
//                 },
//                 child: CompositedTransformTarget(
//                   link: _layerLink,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0),
//                     child: Card(
//                         margin: EdgeInsets.zero,
//                         clipBehavior: Clip.hardEdge,
//                         elevation: 0,
//                         shape: widget.shape ??
//                             RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4.0),
//                                 side: BorderSide(
//                                   color: Color(0xff8CAAC5),
//                                   width: 2,
//                                 )),
//                         child: ListTile(
//                           key: _key,
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 0),
//                           onTap: () {
//                             openOverlay();
//                           },
//                           minLeadingWidth: 20,
//                           title: selectedItems.isEmpty
//                               ? CustomText(
//                                   widget.label.toString(),
//                                   color: mainColor,
//                                 )
//                               : Wrap(
//                                   spacing: 5,
//                                   children: selectedItems
//                                       .map((e) => Chip(
//                                             padding: EdgeInsets.zero,
//                                             deleteIcon: Icon(
//                                               Icons.clear,
//                                               color: Color(0xff8CAAC5),
//                                               size: 20,
//                                             ),
//                                             onDeleted: () {
//                                               addOrRemoveItem(e);
//                                               setState(() {});
//                                             },
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(4.0),
//                                                 side: BorderSide(
//                                                     color: AppColors.primary,
//                                                     width: 0.5)),
//                                             backgroundColor: AppColors.primary
//                                                 .withOpacity(0.1),
//                                             label: CustomText(
//                                               widget.itemAsString.call(e),
//                                             ),
//                                           ))
//                                       .toList(),
//                                 ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               AnimatedSwitcher(
//                                 duration: const Duration(milliseconds: 300),
//                                 child: Icon(
//                                   _hasOpenedOverlay
//                                       ? Icons.keyboard_arrow_up
//                                       : Icons.keyboard_arrow_down,
//                                   key: ValueKey(_hasOpenedOverlay),
//                                   color: Color(0xff8CAAC5),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                             ],
//                           ),
//                         )),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }

//   // future
//   Future<List<T>>? _future;
//   void openOverlay() {
//     _future ??= Future.value(widget.items.call());

//     // if (_overlayEntry == null) {
//     RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);

//     _overlayEntry = OverlayEntry(
//         maintainState: true,
//         builder: (context) => Positioned(
//               left: offset.dx,
//               top: offset.dy + size.height,
//               width: size.width,
//               // bottom: -offset.dy,
//               child: CompositedTransformFollower(
//                 link: _layerLink,
//                 showWhenUnlinked: false,
//                 offset: Offset(0, size.height + 5.0),
//                 child: TapRegion(
//                   onTapOutside: (s) {
//                     closeOverlay();
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0),
//                     child: SizedBox(
//                       height: 200 - MediaQuery.of(context).viewInsets.bottom,
//                       child: AnimationAppearanceOpacity(
//                         duration: const Duration(milliseconds: 300),
//                         child: StatefulBuilder(builder: (context, set) {
//                           return Card(
//                               clipBehavior: Clip.hardEdge,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4.0),
//                                   side: const BorderSide(
//                                     color: Color(0xff939393),
//                                     width: 1,
//                                   )),
//                               child: FutureBuilder(
//                                   future: _future,
//                                   builder: (context, items) {
//                                     return items.connectionState ==
//                                             ConnectionState.waiting
//                                         ? const Padding(
//                                             padding: EdgeInsets.all(15.0),
//                                             child: Center(
//                                                 child:
//                                                     CircularProgressIndicator()),
//                                           )
//                                         : items.data == null
//                                             ? const SizedBox()
//                                             : ListView.builder(
//                                                 shrinkWrap: true,
//                                                 padding: EdgeInsets.zero,
//                                                 itemCount: items.data?.length,
//                                                 itemBuilder:
//                                                     ((context, index) =>
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             addOrRemoveItem(
//                                                                 items.data![
//                                                                     index]);
//                                                             setState(() {});
//                                                             set(() {});
//                                                           },
//                                                           child: Container(
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                                     horizontal:
//                                                                         8,
//                                                                     vertical:
//                                                                         12),
//                                                             width:
//                                                                 double.infinity,
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               border: Border(
//                                                                   bottom: BorderSide(
//                                                                       color: Colors
//                                                                           .black26)),
//                                                             ),
//                                                             child: Row(
//                                                               children: [
//                                                                 Icon(
//                                                                   selectedItems.any((element) =>
//                                                                           element ==
//                                                                           items.data![
//                                                                               index])
//                                                                       ? Icons
//                                                                           .check_box
//                                                                       : Icons
//                                                                           .check_box_outline_blank,
//                                                                   color: AppColors
//                                                                       .primary,
//                                                                 ),
//                                                                 8.pw,
//                                                                 CustomText(
//                                                                   widget
//                                                                       .itemAsString
//                                                                       .call(items
//                                                                               .data![
//                                                                           index]),
//                                                                   fontSize: 16,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         )
//                                                     // ListTile(
//                                                     //   shape: const UnderlineInputBorder(
//                                                     //       borderSide: BorderSide(
//                                                     //           color: Colors
//                                                     //               .black26)),
//                                                     //   onTap: () {
//                                                     //     addOrRemoveItem(
//                                                     //         items.data![index]);
//                                                     //     setState(() {});
//                                                     //     set(() {});
//                                                     //   },
//                                                     //   title: CustomText(widget
//                                                     //       .itemAsString
//                                                     //       .call(items
//                                                     //           .data![index])),
//                                                     //   tileColor: selectedItems
//                                                     //           .any((element) =>
//                                                     //               element ==
//                                                     //               items.data![
//                                                     //                   index])
//                                                     //       ? AppColors.primary
//                                                     //       : Colors.transparent,
//                                                     //   trailing: Icon(
//                                                     //     selectedItems.any(
//                                                     //             (element) =>
//                                                     //                 element ==
//                                                     //                 items.data![
//                                                     //                     index])
//                                                     //         ? Icons.check_box
//                                                     //         : Icons
//                                                     //             .check_box_outline_blank,
//                                                     //     color:
//                                                     //         AppColors.primary,
//                                                     //   ),
//                                                     // )
//                                                     ),
//                                               );
//                                   }));
//                         }),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ));
//     // }
//     if (!_hasOpenedOverlay) {
//       Overlay.of(context).insert(_overlayEntry!);
//       setState(() => _hasOpenedOverlay = true);
//     }
//   }

//   void closeOverlay() {
//     if (_hasOpenedOverlay) {
//       _overlayEntry!.remove();
//       setState(() {
//         _hasOpenedOverlay = false;
//       });
//     }
//   }
// }
