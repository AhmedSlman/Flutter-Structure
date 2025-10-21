import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ezdehar/core/app_strings/locale_keys.dart';
import 'package:ezdehar/core/extensions/all_extensions.dart';
import 'package:ezdehar/core/theme/light_theme.dart';
import 'package:ezdehar/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Widget for recording voice messages
class VoiceRecorderWidget extends StatefulWidget {
  final Function(File voiceFile, Duration duration) onRecordComplete;
  final VoidCallback onCancel;

  const VoiceRecorderWidget({
    super.key,
    required this.onRecordComplete,
    required this.onCancel,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      // Check and request permission
      if (await _hasPermission()) {
        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // Start recording
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        setState(() {
          _isRecording = true;
        });

        // Start timer
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordDuration = Duration(seconds: timer.tick);
            });
          }
        });
      } else {
        // Permission denied
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.microphone_permission_required.tr()),
              backgroundColor: Colors.red,
            ),
          );
          widget.onCancel();
        }
      }
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        widget.onCancel();
      }
    }
  }

  Future<bool> _hasPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      _timer?.cancel();

      if (path != null && mounted) {
        final file = File(path);
        if (await file.exists()) {
          widget.onRecordComplete(file, _recordDuration);
        } else {
          widget.onCancel();
        }
      } else {
        widget.onCancel();
      }
    } catch (e) {
      print('Error stopping recording: $e');
      widget.onCancel();
    }
  }

  Future<void> _cancelRecording() async {
    try {
      await _recorder.stop();
      _timer?.cancel();
      widget.onCancel();
    } catch (e) {
      print('Error canceling recording: $e');
      widget.onCancel();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: LightThemeColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: LightThemeColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Cancel button
          GestureDetector(
            onTap: _cancelRecording,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(Icons.close, color: Colors.red, size: 26),
            ),
          ),
          const Gap(16),

          // Animated microphone icon
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: LightThemeColors.primary.withOpacity(
                    0.1 + (_animationController.value * 0.15),
                  ),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "microphone".svg(),
                  height: 28,
                  width: 28,
                  colorFilter: const ColorFilter.mode(
                    LightThemeColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              );
            },
          ),
          const Gap(16),

          // Recording duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDuration(_recordDuration),
                  style: context.labelSmall?.copyWith(
                    color: LightThemeColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Recording...",
                  style: TextStyle(
                    color: LightThemeColors.primary.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Send button
          GestureDetector(
            onTap: _isRecording ? _stopRecording : null,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: LightThemeColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: LightThemeColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
