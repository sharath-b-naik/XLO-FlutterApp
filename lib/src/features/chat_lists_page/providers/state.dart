import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/chat_room.dart';

part 'state.freezed.dart';

@freezed
class ChatListState with _$ChatListState {
  const factory ChatListState({
    List<ChatRoom>? rooms,
  }) = _ChatListState;
}
