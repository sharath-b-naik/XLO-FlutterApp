import 'package:freezed_annotation/freezed_annotation.dart';

import '../../authentication/models/user_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "chat_room_id") String? chatRoomId,
    UserModel? sender,
    UserModel? receiver,
    String? message,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
