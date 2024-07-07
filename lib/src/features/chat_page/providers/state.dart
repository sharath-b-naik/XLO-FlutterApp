import 'package:freezed_annotation/freezed_annotation.dart';

import '../../chat_lists_page/models/chat_room.dart';
import '../models/message_model.dart';

part 'state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    ChatRoom? room,
    String? receiverId,
    @Default(false) messageSending,
    List<ChatMessage>? messages,
  }) = _ChatState;
}
