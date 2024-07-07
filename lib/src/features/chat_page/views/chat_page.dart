// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../core/translations/translations.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/string_extension.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/button.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/text_field.dart';
import '../../chat_lists_page/models/chat_room.dart';
import '../models/message_model.dart';
import '../providers/provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  final ChatRoom? room;
  final String receiverId;
  const ChatPage({
    super.key,
    this.room,
    required this.receiverId,
  });

  static const String route = "/chat";

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).setInitialData(widget.receiverId);
      if (widget.room?.id == null) {
        ref.read(chatProvider.notifier).getRoom(widget.receiverId);
      } else {
        ref.read(chatProvider.notifier).getChats(widget.room!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 10,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const AppBackButton(),
            const SizedBox(width: 10),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final recipientName = ref.watch(chatProvider.select((value) => value.room?.recipient?.name));
                  return AppText(recipientName ?? '', fontSize: 16);
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topCenter,
            colors: [Color(0xFFECF6FF), Colors.white],
          ),
        ),
        child: const Column(
          children: [
            Expanded(child: ChatListBuilder()),
            ChatTextfield(),
          ],
        ),
      ),
    );
  }
}

class ChatListBuilder extends ConsumerWidget {
  const ChatListBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);

    final messages = state.messages;

    if (messages == null) {
      return const Center(child: LoadingIndicator());
    } else if (messages.isEmpty) {
      return Center(child: AppText(context.tr(AppLocalizations.noMessages)));
    } else {
      return GroupedListView<ChatMessage, String>(
        key: const PageStorageKey("messages"),
        controller: ref.read(chatProvider.notifier).scrollController,
        elements: messages,
        shrinkWrap: true,
        reverse: true,
        padding: const EdgeInsets.all(15),
        order: GroupedListOrder.ASC,
        sort: false,
        cacheExtent: 99999,
        groupBy: (message) {
          final today = DateTime.now().toUtc();
          final date = DateTime.parse(message.createdAt!);
          final yesterday = today.subtract(const Duration(days: 1));

          if ("$date".toDate('dd-MMM-yyyy') == "$today".toDate('dd-MMM-yyyy')) return "Today";
          if ("$date".toDate('dd-MMM-yyyy') == "$yesterday".toDate('dd-MMM-yyyy')) return "Yesterday";
          return "$date".toDate('dd-MMM-yyyy');
        },
        groupSeparatorBuilder: (value) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(25.0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0x0E000000),
              ),
              child: AppText(
                value,
                fontSize: 12,
                color: KColors.textColor,
              ),
            ),
          );
        },
        itemBuilder: (context, message) => ChatCard(message: message),
      );
    }
  }
}

class ChatCard extends StatelessWidget {
  final ChatMessage message;
  const ChatCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final sentByMe = message.sender!.id! == userId;

    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100,
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10).copyWith(
              topLeft: sentByMe ? null : Radius.zero,
              bottomRight: !sentByMe ? null : Radius.zero,
            ),
            color: sentByMe ? KColors.instaGreen : const Color(0xFFE2EDFF),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppText(
                  message.message!,
                  color: sentByMe ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: AppText(
                  DateTime.parse(message.createdAt!).toLocal().toString().toDate('hh:mm a'),
                  color: sentByMe ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTextfield extends ConsumerWidget {
  const ChatTextfield({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);

    return Column(
      children: [
        if (state.messageSending) const LinearProgressIndicator(minHeight: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 5,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: AppTextField(
                  key: const ValueKey("value"),
                  controller: ref.read(chatProvider.notifier).textEditingController,
                  hintText: context.tr(AppLocalizations.typeMessage),
                  maxLines: 6,
                  minLines: 1,
                  borderColor: Colors.black12,
                  filledColor: Colors.white,
                  keyboardType: TextInputType.multiline,
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        onTap: () {
                          // final provider = ref.read(chatProvider.notifier);
                          // provider.sendChatFile();
                        },
                        height: 40,
                        width: 40,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black12,
                          ),
                          child: Transform.rotate(
                            angle: 0.6,
                            child: const Icon(
                              Icons.attach_file,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AppButton(
                onTap: () async {
                  if (state.messageSending) return;
                  final provider = ref.read(chatProvider.notifier);
                  final message = provider.textEditingController.text.trim();
                  if (message.isEmpty) return Toast.info("Message cannot be empty");
                  ref.read(chatProvider.notifier).sendMessage(message);
                },
                height: 40,
                width: 40,
                backgroundColor: KColors.instaGreen,
                padding: EdgeInsets.zero,
                child: const Icon(
                  Icons.send,
                  size: 20,
                  color: KColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
