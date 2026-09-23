import 'conversation_user.dart';



///list of message
class ConversationData {
  String? id;
  String? channelId;
  String? message;
  String? userId;
  bool? isRightMessage;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  ConversationUser? user;
  List<ConversationFile>? conversationFile;

  ConversationData(
      {this.id,
        this.channelId,
        this.message,
        this.userId,
        this.isRightMessage,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.conversationFile
      });

  ConversationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channel_id'];
    message = json['message'];
    userId = json['user_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ?  ConversationUser.fromJson(json['user']) : null;

    if (json['conversation_files'] != null) {
      conversationFile = <ConversationFile>[];
      json['conversation_files'].forEach((v) {
        conversationFile!.add( ConversationFile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_id'] = channelId;
    data['message'] = message;
    data['user_id'] = userId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }

    if (conversationFile != null) {
      data['conversation_files'] = conversationFile!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConversationFile {
  String? id;
  String? conversationId;
  String? fileName;
  String? fileType;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  ConversationFile(
      {this.id,
        this.conversationId,
        this.fileName,
        this.fileType,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  ConversationFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    fileName = json['file_name'];
    fileType = json['file_type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['file_name'] = fileName;
    data['file_type'] = fileType;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

