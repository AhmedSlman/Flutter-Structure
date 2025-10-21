import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/data_source/dio_helper.dart';
import '../model/chat_model.dart';

//put it in locators locator.registerLazySingleton(() => ChatRepository(locator<DioService>()));
//  import '../../modules/chat/domain/repository/repository.dart';
class ChatRepository {
  final DioService dioService;
  ChatRepository(this.dioService);

  Future<PagedMessagesChat?> getChatMessages(
    int page, {
    String? userId,
    String? chatId,
  }) async {
    final ApiResponse response = await dioService.getData(
      url: 'chats/messages',
      query: {
        if (chatId == null || chatId == "null") "department_id": userId,
        "chat_id": chatId,
        "page": page,
      }..removeWhere((key, value) => value == null || value == "null"),
    );
    if (response.isError == false) {
      return PagedMessagesChat.fromMap(response.response?.data);
    } else {
      return null;
    }
  }

  Future<MessageModel?> sendMessage({
    String? message,
    String? chatId,
    String? userId,
    File? image,
    File? voice,
    String? voiceDuration,
  }) async {
    final hasVoice = voice != null;

    final ApiResponse response = await dioService.postData(
      url: "chats/send-message",
      isFile: true,
      isForm: true,
      body: {
        "message": hasVoice
            ? (message?.isEmpty == true ? " " : message)
            : message,
        if (chatId != null && chatId != "null") "chat_id": chatId,
        if (chatId == null || chatId == "null") "department_id": userId,
        if (image != null)
          "file": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split("/").last,
          ),
        if (voice != null)
          "file": await MultipartFile.fromFile(
            voice.path,
            filename: voice.path.split("/").last,
          ),
        if (voiceDuration != null) "voice_duration": voiceDuration,
        if (hasVoice) "is_voice": "1",
      }..removeWhere((key, value) => value == null || value == "null"),
    );
    if (response.isError == false) {
      return MessageModel.fromMap(response.response?.data["data"]["message"]);
    } else {
      return null;
    }
  }

  Future<MessageModel?> sendMessageLocationbyRoom({
    LatLng? location,
    String? chatId,
    String? userId,
  }) async {
    final ApiResponse response = await dioService.postData(
      url: "chats/send-location",
      isFile: true,
      isForm: true,
      body: {
        "lat": location?.latitude,
        "long": location?.longitude,
        if (chatId != null && chatId != "null") "chat_id": chatId,
        if (chatId == null || chatId == "null") "department_id": userId,
      }..removeWhere((key, value) => value == null || value == "null"),
    );
    if (response.isError == false) {
      return MessageModel.fromMap(response.response?.data["data"]);
    } else {
      return null;
    }
  }

  Future<(String, int)?> agoraToken({String? chatId}) async {
    final ApiResponse response = await dioService.postData(
      url: "agora/token",
      isForm: true,
      isFile: true,
      loading: true,
      body: {"chat_id": chatId},
    );
    if (response.isError == false) {
      return (
        response.response?.data["data"]["token"] as String,
        response.response?.data["data"]["from_id"] as int,
      );
    } else {
      return null;
    }
  }
}
