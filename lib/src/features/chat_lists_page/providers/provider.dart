import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services.dart';
import 'state.dart';

final chatListsProvider = StateNotifierProvider.autoDispose<ChatListNotifier, ChatListState>(
  (ref) {
    final notifier = ChatListNotifier();
    return notifier;
  },
);

class ChatListNotifier extends StateNotifier<ChatListState> {
  ChatListNotifier() : super(const ChatListState());

  void setState(ChatListState value) => state = value;

  Future<void> getRooms() async {
    final rooms = await ApiServices.getChatRooms();
    setState(state.copyWith(rooms: rooms));
  }
}
