import 'dart:async';
import 'dart:developer';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:ezdehar/core/Router/Router.dart';
import 'package:ezdehar/core/utils/extentions.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/light_theme.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({
    super.key,
    required this.uid,
    required this.token,
    required this.channel,
  });
  final int uid;
  final String token;
  final String channel;

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late AgoraClient client /*  = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "e7f6e9aeecf14b2ba10e3f40be9f56e7",
      channelName: "test",
      tempToken: widget.token,
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  ) */;

  late Timer _timer;
  late Timer _opacityTimer;
  // Duration _duration = Duration.zero;
  final double _opacity = 1.0;
  ValueNotifier<Duration> duration = ValueNotifier(Duration.zero);
  @override
  void initState() {
    super.initState();
    initAgora();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      duration.value += const Duration(seconds: 1);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _timer.cancel();
    RouteGenerator.currentRoute = "";

    // _opacityTimer.cancel();
    super.dispose();
  }

  void initAgora() async {
    log(widget.token);
    log(widget.channel);
    log(widget.uid.toString() ?? "dsdsds");
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "fd9f738cb7944dababae660e467cae5a",
        // appId: "ad1cde179d3b4c82b7095c9188b87775", //test
        //  channelName: "asd",
        channelName: widget.channel,
        uid: widget.uid,
        // uid: widget.uid,
        // tempToken:
        //     "007eJxTYEg26gjXabe4ut6s12K6iiC75DSL2KOB61/s4fx1vvSW4gIFhrRUo1QLU6OUtGSDZBNT08SkREsTU6Nk80RLA5NkE/M0A5WyjIZARobvkhUsjAwQCOIzMyQWpzAwAACmIR1F",
        tempToken: widget.token,
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ],
    );
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              disabledVideoWidget: _buildDisabledVideoWidget(),
            ),
            // AgoraVideoButtons(client: client),
            CustomAgoraVideoButtons(client: client),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildCallTimer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledVideoWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _opacity,
          child: Image.asset("logo".png()),
        ),
      ),
    );
  }

  Widget _buildCallTimer() {
    return Container(
      width: 140,
      height: 50,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightThemeColors.primary),
      ),
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: duration,
          builder: (_, data, __) {
            return Text(
              _formatDuration(data),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 2,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomAgoraVideoButtons extends StatefulWidget {
  final AgoraClient client;

  const CustomAgoraVideoButtons({super.key, required this.client});

  @override
  State<CustomAgoraVideoButtons> createState() =>
      _CustomAgoraVideoButtonsState();
}

class _CustomAgoraVideoButtonsState extends State<CustomAgoraVideoButtons> {
  bool _isFrontCamera = true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  final sessionController = widget.client.sessionController;
                  final isSpeakerEnabled =
                      sessionController.value.isActiveSpeakerDisabled ?? true;

                  // Toggle speaker state
                  final newSpeakerState = !isSpeakerEnabled;
                  await sessionController.value.engine?.setEnableSpeakerphone(
                    newSpeakerState,
                  );

                  // Save the new state (assuming you have this field in sessionController)
                  sessionController.value = sessionController.value.copyWith(
                    isActiveSpeakerDisabled: newSpeakerState,
                  );

                  setState(() {});
                } catch (e) {
                  log('Error toggling speaker: $e');
                }
              },
              child: CircleAvatar(
                backgroundColor:
                    !(widget
                            .client
                            .sessionController
                            .value
                            .isActiveSpeakerDisabled)
                        ? LightThemeColors.primary
                        : Colors.grey.withOpacity(0.6),
                radius: 32,
                child: const Icon(
                  // widget.client.sessionController.value.isLocalVideoDisabled
                  // ?
                  Icons.volume_up,
                  // : IconManager.callVideoOpen,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await widget.client.sessionController.value.engine
                      ?.switchCamera();
                  setState(() {
                    _isFrontCamera = !_isFrontCamera;
                  });
                } catch (e) {
                  log('Error switching camera: $e');
                }
              },
              child: CircleAvatar(
                backgroundColor:
                    _isFrontCamera
                        ? LightThemeColors.primary
                        : Colors.grey.withOpacity(0.6),
                radius: 32,
                child: Icon(
                  !_isFrontCamera
                      ? Icons.camera_rear_rounded
                      : Icons.camera_front_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  final sessionController = widget.client.sessionController;
                  final isMuted = sessionController.value.isLocalUserMuted;

                  // Toggle mute state
                  sessionController.value = sessionController.value.copyWith(
                    isLocalUserMuted: !isMuted,
                  );

                  await sessionController.value.engine?.muteLocalAudioStream(
                    !isMuted,
                  );
                  setState(() {});
                } catch (e) {
                  log('Error toggling audio: $e');
                }
              },
              child: CircleAvatar(
                backgroundColor:
                    widget.client.sessionController.value.isLocalUserMuted
                        ? LightThemeColors.primary
                        : Colors.grey.withOpacity(0.6),
                radius: 32,
                child: const Icon(
                  Icons.mic_off,
                  // widget.client.sessionController.value.isLocalUserMuted
                  //     ? IconManager.micClose
                  //     : IconManager.micOpen,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                widget.client.sessionController.value.engine?.leaveChannel();
                // await FlutterCallkitIncoming.endAllCalls();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 32,
                child: Icon(Icons.call_end, color: Colors.white, size: 30),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  final sessionController = widget.client.sessionController;
                  final isVideoDisabled =
                      sessionController.value.isLocalVideoDisabled;

                  // Toggle video state
                  sessionController.value = sessionController.value.copyWith(
                    isLocalVideoDisabled: !isVideoDisabled,
                  );

                  if (!isVideoDisabled) {
                    // Disabling video: Hide from call screen
                    await sessionController.value.engine?.muteLocalVideoStream(
                      true,
                    );
                    await sessionController.value.engine?.stopPreview();
                    await sessionController.value.engine?.enableLocalVideo(
                      false,
                    );
                  } else {
                    // Enabling video: Show on call screen
                    await sessionController.value.engine?.enableLocalVideo(
                      true,
                    );
                    await sessionController.value.engine?.startPreview();
                    await sessionController.value.engine?.muteLocalVideoStream(
                      false,
                    );
                  }

                  setState(() {});
                } catch (e) {
                  log('Error toggling video: $e');
                }
              },
              child: CircleAvatar(
                backgroundColor:
                    widget
                                .client
                                .sessionController
                                .value
                                .isLocalVideoDisabled ==
                            true
                        ? Colors.grey.withOpacity(0.6)
                        : LightThemeColors.primary,
                radius: 32,
                child: const Icon(
                  // widget.client.sessionController.value.isLocalVideoDisabled
                  // ?
                  Icons.video_call,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
