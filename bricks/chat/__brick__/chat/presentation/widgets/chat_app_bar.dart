import 'package:ezdehar/core/Router/Router.dart';
import 'package:ezdehar/core/extensions/widget_extensions.dart';
import 'package:ezdehar/core/utils/extentions.dart';
import 'package:ezdehar/features/chat/cubit/chat_cubit.dart';
import 'package:ezdehar/shared/widgets/customtext.dart';
import 'package:ezdehar/shared/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Custom AppBar for chat screen
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? name;
  final String? image;
  final ChatCubit cubit;
  final String? chatId;

  const ChatAppBar({
    super.key,
    this.name,
    this.image,
    required this.cubit,
    this.chatId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 85,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildUserInfo(),
          if (cubit.roomid != null) _buildVideoCallButton(context),
        ],
      ),
    );
  }

  /// User info (profile image + name)
  Widget _buildUserInfo() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: NetworkImagesWidgets(fit: BoxFit.cover, image ?? ""),
          ),
        ),
        8.pw,
        CustomText(name ?? ""),
      ],
    );
  }

  /// Video call button
  Widget _buildVideoCallButton(BuildContext context) {
    return SvgPicture.asset("video_icon".svg()).onTap(() {
      cubit.getAgoraToken(chatId: chatId).then((value) {
        if (value != null) {
          Navigator.pushNamed(
            context,
            Routes.VideoCallScreen,
            arguments: VideoCallArgs(
              channelName: cubit.channelName,
              token: value.$1,
              uid: value.$2,
            ),
          );
        }
      });
    });
  }
}
