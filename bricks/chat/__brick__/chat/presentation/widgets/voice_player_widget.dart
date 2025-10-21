import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:ezdehar/core/extensions/all_extensions.dart';
import 'package:ezdehar/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Widget for playing voice messages (WhatsApp style)
class VoicePlayerWidget extends StatefulWidget {
  final String? audioUrl;
  final File? audioFile;
  final Duration? duration;
  final bool isMine;
  final String? timestamp;

  const VoicePlayerWidget({
    super.key,
    this.audioUrl,
    this.audioFile,
    this.duration,
    this.isMine = false,
    this.timestamp,
  });

  @override
  State<VoicePlayerWidget> createState() => _VoicePlayerWidgetState();
}

class _VoicePlayerWidgetState extends State<VoicePlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    if (widget.duration != null) {
      _duration = widget.duration!;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        setState(() {
          _isLoading = true;
        });

        if (widget.audioFile != null) {
          await _audioPlayer.play(DeviceFileSource(widget.audioFile!.path));
        } else if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
          await _audioPlayer.play(UrlSource(widget.audioUrl!));
        }

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _isLoading = false;
      });
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
    final progress =
        _duration.inMilliseconds > 0
            ? _position.inMilliseconds / _duration.inMilliseconds
            : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          // Play/Pause button (WhatsApp style)
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: widget.isMine ? Colors.white : LightThemeColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (widget.isMine
                            ? Colors.white
                            : LightThemeColors.primary)
                        .withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  _isLoading
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.isMine
                                ? LightThemeColors.primary
                                : Colors.white,
                          ),
                        ),
                      )
                      : Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color:
                            widget.isMine
                                ? LightThemeColors.primary
                                : Colors.white,
                        size: 22,
                      ),
            ),
          ),
          const Gap(16),

          // Waveform (WhatsApp style) - يأخذ كل المساحة المتاحة
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // حساب عدد الـ bars بناءً على المساحة المتاحة
                final availableWidth = constraints.maxWidth;
                const barWidth = 3.0;
                const spacing = 2.5;
                final numBars = (availableWidth / (barWidth + spacing))
                    .floor()
                    .clamp(20, 40);

                return SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(numBars, (index) {
                      // Generate heights dynamically
                      final heightValue =
                          12.0 + ((index % 5) * 4.0) + ((index % 3) * 3.0);
                      final isPassed = (index / numBars) <= progress;
                      return Container(
                        width: barWidth,
                        height: heightValue.clamp(10.0, 32.0),
                        decoration: BoxDecoration(
                          color:
                              isPassed
                                  ? (widget.isMine
                                      ? Colors.white
                                      : LightThemeColors.primary)
                                  : (widget.isMine
                                      ? Colors.white.withOpacity(0.4)
                                      : LightThemeColors.primary.withOpacity(
                                        0.25,
                                      )),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          const Gap(10),

          // Duration (WhatsApp style - يعرض الوقت المتبقي)
          Text(
            _formatDuration(
              _isPlaying || _position.inSeconds > 0
                  ? _duration -
                      _position // الوقت المتبقي (countdown)
                  : _duration, // المدة الكلية قبل التشغيل
            ),
            style: context.bodySmall?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: widget.isMine ? Colors.white : Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
