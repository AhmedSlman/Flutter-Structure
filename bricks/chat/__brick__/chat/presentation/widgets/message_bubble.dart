import 'package:ezdehar/core/Router/Router.dart';
import 'package:ezdehar/core/extensions/string_extensions.dart';
import 'package:ezdehar/core/extensions/widget_extensions.dart';
import 'package:ezdehar/core/theme/light_theme.dart';
import 'package:ezdehar/core/utils/utils.dart';
import 'package:ezdehar/features/chat/cubit/chat_cubit.dart';
import 'package:ezdehar/features/chat/domain/model/chat_model.dart';
import 'package:ezdehar/features/chat/presentation/widgets/static_map.dart';
import 'package:ezdehar/features/chat/presentation/widgets/voice_player_widget.dart';
import 'package:ezdehar/features/home/presentation/widgets/linkfy_text_post.dart';
import 'package:ezdehar/features/my_account/domain/model/my_account_model.dart';
import 'package:ezdehar/features/my_account/presentation/widgets/pdf_item_widget.dart';
import 'package:ezdehar/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Widget for displaying a single message bubble
class MessageBubble extends StatefulWidget {
  const MessageBubble({super.key, this.item});
  final MessageModel? item;
  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  ChatCubit? cubit;

  @override
  void initState() {
    cubit = ChatCubit.get(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await sendMsg();
      // print("${Utils.userModel.id}a7hhhhhhhhhhhhhhhhhhhhhhhhhhhhhha");
    });

    super.initState();
  }

  Future<void> sendMsg() async {
    if (widget.item?.id == null && widget.item?.isloading == false) {
      widget.item?.isloading = true;
      widget.item?.failedTosent = false;
      // log("0");
      // log(widget.item?.content ?? "");
      // log(widget.item?.chatId.toString() ?? "");
      // widget.item?.lat.isEmptyOrNull == true ?
      (() async {
        return (widget.item?.lat.isEmptyOrNull == true &&
                widget.item?.long.isEmptyOrNull == true)
            ? await cubit?.sendMessagebyRoom(
              message: widget.item?.content ?? "",
              userId: widget.item?.receiverId.toString() ?? "",
              image: widget.item?.localeImage,
              voice: widget.item?.localeVoice,
              voiceDuration: widget.item?.voiceDuration,
            )
            : await cubit?.sendMessageLocationbyRoom(
              location: LatLng(
                widget.item?.lat.toDouble() ?? 0,
                widget.item?.long.toDouble() ?? 0,
              ),
              userId: widget.item?.receiverId.toString() ?? "",
            );
      })().then((val) {
        widget.item?.isloading = false;
        if (val != null) {
          // log(val.id.toString());

          widget.item?.id = val.id;
          widget.item?.failedTosent = false;
          widget.item?.mediaUrl = val.mediaUrl;
          widget.item?.voiceUrl = val.voiceUrl;
          widget.item?.voiceDuration =
              val.voiceDuration ?? widget.item?.voiceDuration;
          widget.item?.receiverId = val.receiverId;
          widget.item?.senderId = val.senderId;
          widget.item?.sent_by_employee = val.sent_by_employee;
          // print(val.senderId);
          widget.item?.sendAt = val.sendAt;
          widget.item?.is_call = val.is_call;

          widget.item?.sendAt = val.sendAt;
          // log(widget.item?.id.toString() ?? "message id ");
        } else {
          // log("2");
          widget.item?.failedTosent = true;
        }
        setState(() {});
      });
    }
    // print(
    //   cubit?.chatpagingcontroller.itemList?.map((e) => e.id).toSet().toList(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: _getMessageAlignment(),
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_shouldShowTimeOnLeft()) ..._buildTimeWidget(),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  _isMyMessage()
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
              children: [
                _buildMessageContainer(),
                const SizedBox(height: 4),
                _buildMessageStatus(),
              ],
            ),
          ),
        ],
      ),
    ).onTap(() => _handleMessageTap(context));
  }

  /// Get message alignment based on sender
  MainAxisAlignment _getMessageAlignment() {
    if (widget.item?.is_call == "1") {
      return MainAxisAlignment.center;
    }
    return _isMyMessage() ? MainAxisAlignment.start : MainAxisAlignment.end;
  }

  /// Check if this is my message
  bool _isMyMessage() {
    return (Utils.userModel.is_employee == true &&
            widget.item?.sent_by_employee == true) ||
        (Utils.userModel.is_employee == false &&
            widget.item?.sent_by_employee == false);
  }

  /// Should show time on left (for received messages from employees)
  bool _shouldShowTimeOnLeft() {
    return Utils.userModel.is_employee == true &&
        widget.item?.sent_by_employee == false;
  }

  /// Build time widget
  List<Widget> _buildTimeWidget() {
    return [
      const SizedBox(width: 8),
      // Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //   decoration: BoxDecoration(
      //     color: LightThemeColors.grey.withOpacity(0.1),
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       SvgPicture.asset(
      //         "timer".svg(),
      //         width: 12,
      //         height: 12,
      //         colorFilter: ColorFilter.mode(
      //           LightThemeColors.grey,
      //           BlendMode.srcIn,
      //         ),
      //       ),
      //       const SizedBox(width: 4),
      //       Text(
      //         widget.item?.hour ?? "",
      //         style: TextStyle(
      //           fontSize: 11,
      //           color: LightThemeColors.grey,
      //           fontWeight: FontWeight.w500,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      const SizedBox(width: 8),
    ];
  }

  /// Build message container
  Widget _buildMessageContainer() {
    final hasMedia =
        widget.item?.localeImage != null ||
        widget.item?.mediaUrl != null ||
        widget.item?.voiceDuration != null;
    final hasText = (widget.item?.content ?? "").isNotEmpty;
    final hasLocation =
        (widget.item?.lat.isEmptyOrNull == false &&
            widget.item?.long.isEmptyOrNull == false);

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
        minWidth: hasMedia && !hasText ? 200 : 0,
      ),
      padding: EdgeInsets.all(hasMedia && !hasText ? 4 : 12),
      decoration: BoxDecoration(
        color:
            _isMyMessage()
                ? LightThemeColors.primary
                : LightThemeColors.background,
        borderRadius: _getBorderRadius(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color:
              _isMyMessage()
                  ? Colors.transparent
                  : LightThemeColors.grey.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:
            hasLocation
                ? [
                  StaticMapPreview(
                    lat: widget.item?.lat.toDouble() ?? 0,
                    lng: widget.item?.long.toDouble() ?? 0,
                    width: 600,
                    height: 200,
                  ),
                ]
                : [
                  // Voice Message
                  if (widget.item?.voiceDuration != null) _buildVoiceMessage(),
                  // Local Image/PDF
                  if ((widget.item?.localeImage != null ||
                          widget.item?.mediaUrl != null) &&
                      widget.item?.voiceDuration == null)
                    _buildMedia(),

                  if (hasMedia && hasText) const SizedBox(height: 8),
                  // Text content
                  if (hasText)
                    LinkifyTextReadMore(
                      text: widget.item?.content ?? "",
                      linkStyle: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            _isMyMessage()
                                ? LightThemeColors.background
                                : LightThemeColors.primary,
                        color:
                            _isMyMessage()
                                ? LightThemeColors.background
                                : LightThemeColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      textStyle: TextStyle(
                        fontSize: 15,
                        color:
                            _isMyMessage()
                                ? LightThemeColors.background
                                : LightThemeColors.black,
                        height: 1.4,
                      ),
                    ),
                ],
      ),
    );
  }

  /// Get border radius based on message position
  BorderRadius _getBorderRadius() {
    return BorderRadius.only(
      topRight: const Radius.circular(12),
      topLeft: const Radius.circular(12),
      bottomRight:
          _isMyMessage() ? const Radius.circular(18) : const Radius.circular(4),
      bottomLeft:
          _isMyMessage() ? const Radius.circular(4) : const Radius.circular(18),
    );
  }

  /// Build message status (time, sending, sent, failed)
  Widget _buildMessageStatus() {
    return Padding(
      padding: EdgeInsets.only(
        left: _isMyMessage() ? 12 : 0,
        right: _isMyMessage() ? 0 : 12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Time
          Text(
            widget.item?.hour ?? "",
            style: const TextStyle(
              fontSize: 11,
              color: LightThemeColors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          // Status indicator for my messages
          if (_isMyMessage()) ...[const SizedBox(width: 4), _buildStatusIcon()],
        ],
      ),
    );
  }

  /// Build status icon (sending, sent, failed)
  Widget _buildStatusIcon() {
    if (widget.item?.failedTosent == true) {
      return Icon(Icons.error_outline, size: 14, color: Colors.red.shade400);
    } else if (widget.item?.isloading == true) {
      return SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            LightThemeColors.grey.withOpacity(0.6),
          ),
        ),
      );
    } else if (widget.item?.id != null) {
      return Icon(
        Icons.done_all,
        size: 14,
        color: LightThemeColors.primary.withOpacity(0.7),
      );
    }
    return Icon(
      Icons.access_time,
      size: 12,
      color: LightThemeColors.grey.withOpacity(0.6),
    );
  }

  /// Build voice message widget
  Widget _buildVoiceMessage() {
    return VoicePlayerWidget(
      audioFile: widget.item?.localeVoice,
      audioUrl: widget.item?.voiceUrl ?? widget.item?.mediaUrl,
      duration: Duration(seconds: int.parse(widget.item!.voiceDuration!)),
      isMine: _isMyMessage(),
      timestamp: widget.item?.hour,
    );
  }

  /// Build local media (before upload)
  Widget _buildMedia() {
    if ((widget.item?.localeImage?.path.contains(".pdf") == true) ||
        widget.item?.mediaUrl?.contains(".pdf") == true) {
      return PdfItemWidget(
        withpops: _shouldShowPdfPops(),
        isOwner: false,
        myMessage: true,
        file: MediaModel(
          file:
              (widget.item?.localeImage != null)
                  ? widget.item?.localeImage
                  : null,
          url: widget.item?.mediaUrl ?? "",
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            DefaultImageWidget(
              widget.item?.mediaUrl ?? widget.item?.localeImage?.path ?? "",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 290,
              radius: 8,
            ).onTap(() {
              if (widget.item?.id.isEmptyOrNull == false) {
                Navigator.pushNamed(
                  context,
                  Routes.fullImageChat,
                  arguments: ImageArgs(
                    url: widget.item?.mediaUrl ?? "",
                    image: widget.item?.localeImage,
                  ),
                );
              }
            }),
            // Loading overlay if still uploading
            if (widget.item?.id == null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  /// Build remote media (after upload)
  Widget _buildRemoteMedia() {
    if (widget.item?.mediaUrl?.contains(".pdf") == true) {
      return PdfItemWidget(
        withpops: _shouldShowPdfPops(),
        isOwner: false,
        myMessage: true,
        file: MediaModel(url: widget.item?.mediaUrl ?? ""),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Hero(
          tag: 'message_image_${widget.item?.id}',
          child: DefaultImageWidget(
            widget.item?.mediaUrl ?? "",
            fit: BoxFit.cover,
          ),
        ),
      ).onTap(() {
        Navigator.pushNamed(
          context,
          Routes.fullImageChat,
          arguments: ImageArgs(url: widget.item?.mediaUrl ?? ""),
        );
      });
    }
  }

  /// Check if should show PDF pops
  bool _shouldShowPdfPops() {
    return (Utils.userModel.is_employee != true &&
            widget.item?.sent_by_employee == true) ||
        (Utils.userModel.is_employee != false &&
            widget.item?.sent_by_employee == false);
  }

  /// Handle message tap (for video calls)
  void _handleMessageTap(BuildContext context) {
    if (widget.item?.is_call == "1") {
      cubit?.getAgoraToken(chatId: widget.item?.chatId).then((value) {
        if (value != null) {
          Navigator.pushNamed(
            context,
            Routes.VideoCallScreen,
            arguments: VideoCallArgs(
              channelName: cubit?.channelName ?? "",
              token: value.$1,
              uid: value.$2,
            ),
          );
        }
      });
    }
  }
}
