import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services.dart';
import '../../../utils/custom_toast.dart';
import '../../chat_lists_page/models/chat_room.dart';
import '../models/message_model.dart';
import 'state.dart';

final chatProvider = StateNotifierProvider.autoDispose<ChatNotifier, ChatState>(
  (ref) {
    final notifier = ChatNotifier();
    ref.onDispose(() {
      notifier.textEditingController.dispose();
      notifier.scrollController.dispose();
    });
    return notifier;
  },
);

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  void setState(ChatState value) => state = value;
  void setInitialData(String receiverId) => setState(state.copyWith(receiverId: receiverId));

  Future<void> scrollDownChat() async {
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> getRoom(String receiverId) async {
    final rooms = await ApiServices.getChatRooms(receiverId);
    // if empty, then room was not created yet OR some other error.
    if (rooms.isEmpty) return setState(state.copyWith(messages: <ChatMessage>[]));
    getChats(rooms.first);
  }

  Future<void> getChats(ChatRoom room) async {
    final messages = await ApiServices.getChatRoomMessages(room.id!);
    if (messages.isEmpty) return Toast.failure("Unable to load chats");
    messages.sort((a, b) => DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
    setState(state.copyWith(room: room, messages: messages));
  }

  Future<String?> createRoom(String receiverId) async {
    final room = await ApiServices.createChatRoom(receiverId);
    if (room == null) Toast.failure("Unable to send message");
    setState(state.copyWith(room: room, messageSending: room != null));
    return room?.id;
  }

  Future<void> sendMessage(String message) async {
    textEditingController.clear();
    setState(state.copyWith(messageSending: true));
    final roomid = state.room?.id ?? await createRoom(state.receiverId!);
    if (roomid == null) {
      textEditingController.text = message;
      return Toast.failure("Unable to send message");
    } else {
      final result = await ApiServices.sendMessage(roomid, message);
      if (result == null) {
        Toast.failure("Message not sent");
        textEditingController.text = message;
      }
      scrollDownChat();
      final messages = [if (result != null) result, ...(state.messages ?? <ChatMessage>[])];
      setState(state.copyWith(messageSending: false, messages: messages));
    }
  }
}
