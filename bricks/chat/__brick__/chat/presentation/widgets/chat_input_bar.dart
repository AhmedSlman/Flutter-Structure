import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:ezdehar/core/app_strings/locale_keys.dart';
import 'package:ezdehar/core/theme/light_theme.dart';
import 'package:ezdehar/core/utils/extentions.dart';
import 'package:ezdehar/features/chat/cubit/chat_cubit.dart';
import 'package:ezdehar/features/chat/presentation/widgets/voice_recorder_widget.dart';
import 'package:ezdehar/shared/widgets/edit_text_widget.dart';
import 'package:ezdehar/shared/widgets/grad_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

/// Chat input bar with text field, attach, mic and send buttons
class ChatInputBar extends StatefulWidget {
  final TextEditingController messageController;
  final ChatCubit cubit;
  final bool hasText;
  final bool isRecording;
  final VoidCallback onAttachTap;
  final VoidCallback onMicTap;
  final VoidCallback onSendTap;
  final Function(File voiceFile, Duration duration) onRecordComplete;
  final VoidCallback onRecordCancel;

  const ChatInputBar({
    super.key,
    required this.messageController,
    required this.cubit,
    required this.hasText,
    required this.isRecording,
    required this.onAttachTap,
    required this.onMicTap,
    required this.onSendTap,
    required this.onRecordComplete,
    required this.onRecordCancel,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _showEmojiPicker) {
        setState(() {
          _showEmojiPicker = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        _focusNode.unfocus();
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(
            right: 16,
            left: 16,
            top: 20,
            bottom:
                _showEmojiPicker
                    ? 12
                    : 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child:
              widget.isRecording ? _buildRecordingMode() : _buildNormalMode(),
        ),
        if (_showEmojiPicker) _buildEmojiPicker(),
      ],
    );
  }

  /// Recording mode (voice recorder)
  Widget _buildRecordingMode() {
    return VoiceRecorderWidget(
      onRecordComplete: widget.onRecordComplete,
      onCancel: widget.onRecordCancel,
    );
  }

  /// Normal mode (text input)
  Widget _buildNormalMode() {
    return Row(
      children: [
        _buildAttachButton(),
        const Gap(8),
        _buildTextField(),
        const Gap(8),
        _buildEmojiButton(),
        const Gap(8),
        widget.hasText ? _buildSendButton() : _buildMicButton(),
      ],
    );
  }

  /// Attach button
  Widget _buildAttachButton() {
    return GestureDetector(
      onTap: widget.onAttachTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: LightThemeColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add, color: LightThemeColors.primary, size: 24),
      ),
    );
  }

  /// Text field
  Widget _buildTextField() {
    return Expanded(
      child: Focus(
        focusNode: _focusNode,
        child: TextFormFieldWidget(
          controller: widget.messageController,
          type: TextInputType.text,
          hintText: LocaleKeys.write_message.tr(),
          password: false,
        ),
      ),
    );
  }

  /// Emoji button
  Widget _buildEmojiButton() {
    return GestureDetector(
      onTap: _toggleEmojiPicker,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color:
              _showEmojiPicker
                  ? LightThemeColors.primary.withOpacity(0.2)
                  : LightThemeColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
          color: LightThemeColors.primary,
          size: 24,
        ),
      ),
    );
  }

  /// Send button
  Widget _buildSendButton() {
    return GradButtonWidget(
      width: 45,
      height: 45,
      onTap: widget.onSendTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SvgPicture.asset("send".svg()), const Gap(5)],
      ),
    );
  }

  /// Mic button
  Widget _buildMicButton() {
    return GestureDetector(
      onTap: widget.onMicTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              LightThemeColors.primary,
              LightThemeColors.primary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.mic, color: Colors.white, size: 24),
      ),
    );
  }

  /// Emoji picker
  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 280,
      child: EmojiPicker(
        textEditingController: widget.messageController,
        config: const Config(
          height: 280,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: Text(
              'لا توجد إيموجي مستخدمة',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: SizedBox.shrink(),
            columns: 7,
            buttonMode: ButtonMode.MATERIAL,
            backgroundColor: LightThemeColors.background,
          ),
          skinToneConfig: SkinToneConfig(),
          categoryViewConfig: CategoryViewConfig(
            initCategory: Category.RECENT,
            indicatorColor: LightThemeColors.primary,
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: CategoryIcons(),
            backgroundColor: LightThemeColors.background,
            iconColor: Colors.grey,
            iconColorSelected: LightThemeColors.primary,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: LightThemeColors.background,
            buttonColor: LightThemeColors.background,
            buttonIconColor: LightThemeColors.primary,
            enabled: true,
            showSearchViewButton: true,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: LightThemeColors.background,
            buttonIconColor: LightThemeColors.primary,
            hintText: 'بحث عن إيموجي...',
          ),
        ),
      ),
    );
  }
}
