import 'dart:convert';
import 'dart:io';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  String? id;
  String? chatId;
  String? senderId;
  String? receiverId;
  String? senderName;
  String? senderAvatar;
  String? content;
  String? mediaUrl;
  String? is_call;
  String? sendAt;
  String? createdat;
  String? hour;
  String? receiver_avatar;
  File? localeImage;
  File? localeVoice;
  String? voiceUrl;
  String? voiceDuration;
  String? lat;
  String? long;
  bool? failedTosent;
  bool isloading;
  bool? sent_by_employee;
  MessageModel({
    this.id,
    this.hour,
    this.long,
    this.lat,
    this.sent_by_employee,
    this.chatId,
    this.createdat,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.senderAvatar,
    this.is_call,
    this.content,
    this.mediaUrl,
    this.receiver_avatar,
    this.sendAt,
    this.failedTosent,
    this.isloading = false,
    this.localeImage,
    this.localeVoice,
    this.voiceUrl,
    this.voiceDuration,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    final mediaUrl = map['media_url']?.toString();
    final voiceDuration = map['voice_duration']?.toString();

    final isVoiceFile =
        mediaUrl != null &&
        (mediaUrl.endsWith('.m4a') ||
            mediaUrl.endsWith('.aac') ||
            mediaUrl.endsWith('.mp3') ||
            mediaUrl.endsWith('.wav') ||
            mediaUrl.contains('voice'));

    return MessageModel(
      id: map['id']?.toString() ?? "",
      hour: map['sent_at']?.split(' ')[1].toString() ?? "",
      chatId: map['chat_id']?.toString() ?? '',
      senderId: map['sender_id']?.toString() ?? "",
      receiverId: map['receiver_id']?.toString() ?? "",
      receiver_avatar: map['receiver_avatar']?.toString() ?? "",
      senderName: map['sender_name']?.toString() ?? "",
      senderAvatar: map['sender_avatar']?.toString(),
      content: map['content']?.toString() ?? "",
      mediaUrl: mediaUrl,
      voiceUrl: map['voice_url']?.toString(),
      voiceDuration: voiceDuration ?? (isVoiceFile ? "0" : null),
      sendAt: map['sent_at']?.toString() ?? "",
      is_call: map['is_call']?.toString() ?? "",
      sent_by_employee: map['sent_by_employee'] == 1 ? true : false,
      lat: map['lat']?.toString() ?? "",
      long: map['long']?.toString() ?? "",
    );
  }

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.id == id &&
        other.chatId == chatId &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.senderName == senderName &&
        other.senderAvatar == senderAvatar &&
        other.content == content &&
        other.mediaUrl == mediaUrl &&
        other.is_call == is_call &&
        other.sendAt == sendAt &&
        other.createdat == createdat &&
        other.hour == hour &&
        other.receiver_avatar == receiver_avatar &&
        other.localeImage == localeImage &&
        other.localeVoice == localeVoice &&
        other.voiceUrl == voiceUrl &&
        other.voiceDuration == voiceDuration &&
        other.failedTosent == failedTosent &&
        other.isloading == isloading &&
        other.sent_by_employee == sent_by_employee;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chatId.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        senderName.hashCode ^
        senderAvatar.hashCode ^
        content.hashCode ^
        mediaUrl.hashCode ^
        is_call.hashCode ^
        sendAt.hashCode ^
        createdat.hashCode ^
        hour.hashCode ^
        receiver_avatar.hashCode ^
        localeImage.hashCode ^
        localeVoice.hashCode ^
        voiceUrl.hashCode ^
        voiceDuration.hashCode ^
        failedTosent.hashCode ^
        isloading.hashCode ^
        sent_by_employee.hashCode;
  }
}

class PagedMessagesChat {
  List<MessageModel>? messages;
  int? lastPage;
  PagedMessagesChat({this.messages, this.lastPage});

  factory PagedMessagesChat.fromMap(Map<String, dynamic> map) {
    return PagedMessagesChat(
      messages: map["data"] is Map
          ? List<MessageModel>.from(
              (map["data"]['messages']).map<MessageModel?>(
                (x) => MessageModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      lastPage: map["pagination"] != null && map["data"]! is Map
          ? map["pagination"]['lastPage'] as int
          : null,
    );
  }

  factory PagedMessagesChat.fromJson(String source) =>
      PagedMessagesChat.fromMap(json.decode(source) as Map<String, dynamic>);
}
