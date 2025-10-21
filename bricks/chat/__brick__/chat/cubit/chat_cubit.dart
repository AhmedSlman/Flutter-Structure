import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/utils/Locator.dart';
import '../../../core/utils/utils.dart';
import '../domain/model/chat_model.dart';
import '../domain/repository/repository.dart';
import 'chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(context) => BlocProvider.of(context);

  ChatRepository chatRepository = locator<ChatRepository>();
  PagingController<int, MessageModel> chatpagingcontroller =
      PagingController<int, MessageModel>(firstPageKey: 1);
  ScrollController scrollController = ScrollController();

  String? userid;
  addPageListener({String? userid, String? chatId}) {
    this.userid = userid;
    if (chatId != null) {
      equalchannel(chatId);
      initPusher();
    }
    chatpagingcontroller.addPageRequestListener((page) {
      getChatMessages(page);
    });
  }

  Future<String?> getChatMessages(int page) async {
    final result = await chatRepository.getChatMessages(
      page,
      userId: userid,
      chatId: roomid,
    );
    if (result != null) {
      if (result.lastPage == page || result.messages?.isEmpty == true) {
        chatpagingcontroller.appendLastPage(result.messages ?? []);
      } else {
        var nextPageKey = page + 1;
        chatpagingcontroller.appendPage(result.messages ?? [], nextPageKey);
      }
      emit(ChatSuccessState());
    } else {
      chatpagingcontroller.error = 'error';
      emit(ChatErrorState());
    }
    return null;
  }

  Future<MessageModel?> sendMessagebyRoom({
    String? message,
    String? userId,
    File? image,
    File? voice,
    String? voiceDuration,
  }) async {
    final result = await chatRepository.sendMessage(
      image: image,
      voice: voice,
      voiceDuration: voiceDuration,
      chatId: roomid,
      userId: userId,
      message: message,
    );
    if (result != null && roomid == null) {
      equalchannel(result.chatId);
      initPusher();
      emit(RefreshStateSuceess());
    }

    return result;
  }

  Future<MessageModel?> sendMessageLocationbyRoom({
    LatLng? location,
    String? userId,
  }) async {
    final result = await chatRepository.sendMessageLocationbyRoom(
      chatId: roomid,
      userId: userId,
      location: location,
    );
    if (result != null && roomid == null) {
      equalchannel(result.chatId);
      initPusher();
      emit(RefreshStateSuceess());
    }

    return result;
  }

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  late String channelName;

  equalchannel(String? roomid) {
    this.roomid = roomid;
    channelName = 'private-Chat.$roomid';
  }

  String? roomid;
  initPusher() async {
    try {
      await pusher.init(
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        apiKey: "{{pusherKey}}", // Pusher API Key
        cluster: "{{pusherCluster}}", // Pusher Cluster
        onConnectionStateChange: onConnectionStateChange,
        onError: onErrorP,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onAuthorizer: (String channel, String socketId, dynamic options) async {
          Dio dio = Dio(BaseOptions(receiveDataWhenStatusError: true));
          try {
            final response = await dio.post(
              '{{pusherAuthUrl}}', // Broadcasting Auth URL
              data: {'socket_id': socketId, 'channel_name': channel},
              options: Options(
                headers: {
                  'accept': 'application/json',
                  'Authorization': 'Bearer ${Utils.token}',
                  'socket_id': socketId,
                  'channel_name': channel,
                },
              ),
            );
            log(response.data.toString());
            return jsonDecode(response.data);
          } catch (e) {
            log(e.toString(), name: "Pusher Error");
          }
        },
      );

      await pusher.connect();
      await pusher.subscribe(channelName: channelName);
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName member: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print("onMemberRemoved: $channelName member: $member");
  }

  void onConnectionStateChange(
    dynamic currentState,
    dynamic previousState,
  ) async {
    log("Connection: $currentState");
  }

  void onErrorP(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  final Set<int> handledEventIds = {};

  void onEvent(PusherEvent event) async {
    try {
      if (event.channelName != channelName) {
        return;
      }

      final data = json.decode(event.data);

      if (event.channelName == channelName && event.data != null) {
        _handleServerEvent(data);
      }
    } catch (e) {
      print("Error processing event: $e");
    }
  }

  void _handleServerEvent(Map<String, dynamic> data) async {
    if (data["message"] != null) {
      final message = MessageModel.fromMap(data["message"]);
      if (handledEventIds.contains(message.id)) {
        print("Duplicate server event: ${message.id}");
        return;
      }

      handledEventIds.add(int.parse(message.id!));

      if (message.senderId != Utils.userModel.id.toString()) {
        chatpagingcontroller.itemList?.insert(0, message);
        emit(ReceivedMessageState());
      }
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) async {
    try {
      log("Subscription succeeded for: $data");
    } catch (e) {
      log("Error in subscription handler: $e");
    }
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  Future<(String, int)?> getAgoraToken({String? chatId}) async {
    final response = await chatRepository.agoraToken(chatId: chatId);
    return response;
  }

  @override
  Future<void> close() {
    try {
      if (pusher.getChannel(channelName)?.channelName != null) {
        pusher.unsubscribe(channelName: channelName);
        pusher.disconnect();
        log('Unsubscribed and disconnected successfully.');
      } else {
        log('Channel not found.');
      }
    } catch (e) {
      print(e);
    }
    Utils.currentRoomId = "";
    chatpagingcontroller.dispose();
    scrollController.dispose();
    return super.close();
  }
}
