import 'package:freezed_annotation/freezed_annotation.dart';

import '../../authentication/models/user_model.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

@freezed
class ChatRoom with _$ChatRoom {
  static const defaultValue = ChatRoom();
  const factory ChatRoom({
    String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    UserModel? recipient,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);
}
