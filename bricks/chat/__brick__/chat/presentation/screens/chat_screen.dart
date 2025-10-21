import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ezdehar/core/Router/Router.dart';
import 'package:ezdehar/core/app_strings/locale_keys.dart';
import 'package:ezdehar/core/services/alerts.dart';
import 'package:ezdehar/core/services/media/alert_of_media.dart';
import 'package:ezdehar/core/utils/utils.dart';
import 'package:ezdehar/features/chat/cubit/chat_cubit.dart';
import 'package:ezdehar/features/chat/cubit/chat_states.dart';
import 'package:ezdehar/features/chat/domain/model/chat_model.dart';
import 'package:ezdehar/features/chat/presentation/widgets/attachment_options_sheet.dart';
import 'package:ezdehar/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:ezdehar/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:ezdehar/features/chat/presentation/widgets/message_bubble.dart';
import 'package:ezdehar/shared/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
    required this.userId,
    this.image,
    this.name,
  });
  final String? chatId;
  final String? userId;
  final String? image;
  final String? name;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  late MessageModel msg;
  String message = "";
  File? image;
  File? voiceFile;
  Duration? voiceDuration;
  bool isTyping = false;
  bool isRecording = false;
  bool hasText = false;
  LatLng? location;

  @override
  void initState() {
    super.initState();
    // استمع لتغيرات النص
    messageController.addListener(() {
      setState(() {
        hasText = messageController.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> sendMessage(
    ChatCubit cubit, [
    File? file,
    File? voice,
    Duration? duration,
  ]) async {
    log(location?.latitude.toString() ?? "latitude");
    log(location?.longitude.toString() ?? "longitude");
    if (messageController.text.trim().isNotEmpty ||
        file != null ||
        (location != null) ||
        voice != null) {
      message = messageController.text.trim();
      image = file;
      voiceFile = voice;
      voiceDuration = duration;
      log(image?.path ?? "pathhhhhhhhhh image", name: "image");
      log(voiceFile?.path ?? "pathhhhhhhhhh voice", name: "voice");
      messageController.clear();
      msg = MessageModel(
        createdat: DateTime.now().toString(),
        localeImage: image,
        localeVoice: voiceFile,
        voiceDuration: voiceDuration?.inSeconds.toString(),
        id: null,
        lat: location?.latitude.toString() ?? "",
        long: location?.longitude.toString() ?? "",
        sent_by_employee: Utils.userModel.is_employee,
        senderId: Utils.userModel.id.toString(),
        chatId: widget.chatId,
        content: message,
        receiverId: widget.userId,
        sendAt: DateTime.now().toString(),
      );
      image = null;
      location = null;
      voiceFile = null;
      voiceDuration = null;
      messageController.clear();
      cubit.chatpagingcontroller.itemList?.insert(0, msg);
      cubit.scrollController.jumpTo(cubit.scrollController.initialScrollOffset);

      setState(() {});
    }
  }

  void _showAttachmentOptions(BuildContext context, ChatCubit cubit) {
    Alerts.bottomSheet(
      context,
      child: AttachmentOptionsSheet(
        parentContext: context,
        onLocationSelect: (location) {
          this.location = location;
          sendMessage(cubit);
        },
        cubit: cubit,
        messageController: messageController,
        sendMessage: sendMessage,
        onCameraSelected: () => chooseMediaSheet(context, cubit),
      ),
    );
  }

  void chooseMediaSheet(BuildContext context, ChatCubit cubit) {
    Alerts.bottomSheet(
      context,
      child: AlertOfMedia(
        onCameraSelected: (val) async {
          // image = val;
          if (val != null) {
            Navigator.pushNamed(
              context,
              Routes.fullImageChat,
              arguments: ImageArgs(
                image: val,
                sendFunction: (imageFile, text) async {
                  Navigator.pop(context);
                  messageController.text = text ?? "";
                  sendMessage(cubit, imageFile);
                },
              ),
            );
          }
          setState(() {});
        },
        onGallerySelected: (val) async {
          // image = val;
          if (val != null) {
            Navigator.pushNamed(
              context,
              Routes.fullImageChat,
              arguments: ImageArgs(
                image: val,
                sendFunction: (imageFile, text) async {
                  Navigator.pop(context);
                  messageController.text = text ?? "";
                  sendMessage(cubit, imageFile);
                },
              ),
            );
          }
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    Utils.currentRoomId = "";
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ChatCubit()
                ..addPageListener(chatId: widget.chatId, userid: widget.userId),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: ChatAppBar(
              name: widget.name,
              image: widget.image,
              cubit: cubit,
              chatId: widget.chatId,
            ),
            bottomNavigationBar: ChatInputBar(
              messageController: messageController,
              cubit: cubit,
              hasText: hasText,
              isRecording: isRecording,
              onAttachTap: () => _showAttachmentOptions(context, cubit),
              onMicTap: () {
                setState(() {
                  isRecording = true;
                });
              },
              onSendTap: () async {
                await sendMessage(cubit);
              },
              onRecordComplete: (voiceFile, duration) {
                setState(() {
                  isRecording = false;
                });
                sendMessage(cubit, null, voiceFile, duration);
              },
              onRecordCancel: () {
                setState(() {
                  isRecording = false;
                });
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PagedListView(
                      reverse: true,
                      pagingController: cubit.chatpagingcontroller,
                      scrollController: cubit.scrollController,
                      builderDelegate: PagedChildBuilderDelegate<MessageModel>(
                        noItemsFoundIndicatorBuilder:
                            (context) => Center(
                              child: EmptyWidget(
                                image: "nochats",
                                title: LocaleKeys.no_messages.tr(),
                                subtitle: "",
                              ),
                            ),
                        itemBuilder: (context, item, index) {
                          return MessageBubble(key: ValueKey(item), item: item);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
