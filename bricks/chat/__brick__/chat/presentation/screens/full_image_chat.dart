import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ezdehar/core/utils/extentions.dart';
import 'package:ezdehar/features/chat/cubit/chat_cubit.dart';
import 'package:ezdehar/features/chat/cubit/chat_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../shared/widgets/edit_text_widget.dart';

class FullImageScreen extends StatefulWidget {
  final String? url;
  final File? photo;
  final Function(File image, String msgText)? sendFunction;
  const FullImageScreen({super.key, this.url, this.photo, this.sendFunction});

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  TextEditingController controller = TextEditingController();
  bool isPDF = false;

  @override
  void initState() {
    super.initState();
    // Check if the file is a PDF
    if (widget.photo != null) {
      // String extension = path.extension(widget.photo!.path).toLowerCase();
      // print(extension);
      // isPDF =
      //     widget.photo!.path.contains(".pdf") || widget.url!.contains(".PDF");
      // log(isPDF.toString());
      setState(() {});
      // = extension == '.pdf';
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(title: Text(isPDF ? 'PDF Viewer' : 'Image Viewer')),
            body:
                widget.url != null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: PhotoView(
                        imageProvider: CachedNetworkImageProvider(
                          widget.url ?? "",
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered,
                        initialScale: PhotoViewComputedScale.contained,
                        basePosition: Alignment.center,
                        backgroundDecoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    )
                    : ListView(
                      children: [
                        // Display PDF or Image based on file type
                        isPDF
                            ? CustomPDFViewWidget(pdfFile: widget.photo)
                            : CustomPhotoViewWidget(photo: widget.photo),
                        Padding(
                          padding: const EdgeInsets.all(16).copyWith(bottom: 5),
                          child: TextFormFieldWidget(
                            controller: controller,
                            onFieldSubmitted: (value) async {
                              widget.sendFunction!(
                                widget.photo!,
                                controller.text,
                              );
                              Navigator.pop(context);
                            },
                            hintText: 'Type your message'.tr(),
                            password: false,
                            borderRadius: 33,
                            maxLines: 30,
                            minLines: 1,
                            suffixIcon: SizedBox(
                              width: 90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      widget.sendFunction!(
                                        widget.photo!,
                                        controller.text,
                                      );
                                    },
                                    child: const Icon(Icons.send),
                                  ),
                                  10.pw,
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.ph,
                      ],
                    ),
          );
        },
      ),
    );
  }
}

class CustomPhotoViewWidget extends StatelessWidget {
  const CustomPhotoViewWidget({super.key, this.photo});
  final File? photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 750,
      child: PhotoView(
        imageProvider: FileImage(photo ?? File("")),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}

class CustomPDFViewWidget extends StatefulWidget {
  final File? pdfFile;
  final String? url;

  final Function(File image, String msgText)? sendFunction;
  const CustomPDFViewWidget({
    super.key,
    this.url,
    this.pdfFile,
    this.sendFunction,
  });

  @override
  State<CustomPDFViewWidget> createState() => _CustomPDFViewWidgetState();
}

class _CustomPDFViewWidgetState extends State<CustomPDFViewWidget> {
  int currentPage = 0;
  int totalPages = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 750,
      child: Column(
        children: [
          // PDF page indicator
          if (isReady && totalPages > 0)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Page ${currentPage + 1} of $totalPages',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          // PDF Viewer
          Expanded(
            child:
                widget.pdfFile != null
                    ? PDFView(
                      filePath: widget.pdfFile!.path,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: true,
                      pageSnap: true,
                      defaultPage: currentPage,
                      fitPolicy: FitPolicy.BOTH,
                      preventLinkNavigation: false,
                      onRender: (pages) {
                        setState(() {
                          totalPages = pages!;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                        print('PDF Error: $error');
                      },
                      onPageError: (page, error) {
                        setState(() {
                          errorMessage = 'Page $page: ${error.toString()}';
                        });
                        print('PDF Page Error: $page: $error');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        // You can store the controller if needed for additional functionality
                      },
                      onLinkHandler: (String? uri) {
                        print('Link clicked: $uri');
                      },
                      onPageChanged: (int? page, int? total) {
                        setState(() {
                          currentPage = page ?? 0;
                          totalPages = total ?? 0;
                        });
                      },
                    )
                    : const Center(
                      child: Text(
                        'No PDF file selected',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
          ),
          // Error message display
          if (errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(
                'Error: $errorMessage',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
