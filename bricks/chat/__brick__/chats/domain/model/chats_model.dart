import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  String? chatId;
  String? i_am_department;
  OtherParty? other_party;
  LastMessage? last_message;
  String? unseen_count;
  ChatModel({
    this.chatId,
    this.i_am_department,
    this.other_party,
    this.last_message,
    this.unseen_count,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chat_id']?.toString(),
      i_am_department: map['i_am_department']?.toString(),
      other_party: map['other_party'] != null
          ? OtherParty.fromMap(map['other_party'] as Map<String, dynamic>)
          : null,
      last_message: map['last_message'] != null
          ? LastMessage.fromMap(map['last_message'] as Map<String, dynamic>)
          : null,
      unseen_count: map['unseen_count']?.toString(),
    );
  }

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OtherParty {
  String? type;
  String? id;
  CompanyModel? company;
  String? name;
  OtherParty({this.type, this.id, this.name, this.company});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'type': type, 'id': id, 'name': name};
  }

  factory OtherParty.fromMap(Map<String, dynamic> map) {
    return OtherParty(
      type: map['type'] != null ? map['type'] as String : null,
      company: map['company'] != null
          ? CompanyModel.fromJson(map['company'])
          : null,
      id: map['id']?.toString(),
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherParty.fromJson(String source) =>
      OtherParty.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CompanyModel {
  String? companyName;
  String? companyImage;

  CompanyModel({this.companyName, this.companyImage});

  factory CompanyModel.fromJson(Map<String, dynamic> map) {
    return CompanyModel(
      companyName: map['company_name']?.toString(),
      companyImage: map['company_image']?.toString(),
    );
  }
}

class LastMessage {
  String? id;
  String? chatId;
  String? senderId;
  String? receiverId;
  String? content;
  String? hasContent;
  String? hasImage;
  bool? sentByMe;
  String? sentAt;
  LastMessage({
    this.id,
    this.chatId,
    this.senderId,
    this.receiverId,
    this.content,
    this.hasContent,
    this.hasImage,
    this.sentByMe,
    this.sentAt,
  });

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      id: map['id']?.toString(),
      chatId: map['chat_id']?.toString(),
      senderId: map['sender_id']?.toString(),
      receiverId: map['receiver_id']?.toString(),
      content: map['content']?.toString(),
      hasContent: map['has_content']?.toString(),
      hasImage: map['has_image']?.toString(),
      sentByMe: map['sent_by_me'] != null ? map['sent_by_me'] as bool : null,
      sentAt: map['sent_at']?.toString(),
    );
  }

  factory LastMessage.fromJson(String source) =>
      LastMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PagedChatsModel {
  List<ChatModel>? chats;
  int? lastPage;
  PagedChatsModel({this.chats, this.lastPage});

  factory PagedChatsModel.fromMap(Map<String, dynamic> map) {
    return PagedChatsModel(
      chats: map['data'] != null
          ? List<ChatModel>.from(
              (map['data']).map<ChatModel?>(
                (x) => ChatModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      lastPage: map["pagination"]['lastPage'] != null
          ? map["pagination"]['lastPage'] as int
          : null,
    );
  }

  factory PagedChatsModel.fromJson(String source) =>
      PagedChatsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
