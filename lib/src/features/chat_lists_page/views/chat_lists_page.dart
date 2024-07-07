import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/profile_avatar.dart';
import '../../../widgets/svg_icon.dart';
import '../../../widgets/text_field.dart';
import '../../chat_page/views/chat_page.dart';
import '../providers/provider.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  static const String route = "/chatlists";

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatListsProvider.notifier).getRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatListsProvider);
    final rooms = state.rooms;

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: KColors.instaGreen,
              pinned: true,
              floating: true,
              title: AppText(context.tr(AppLocalizations.chats), color: Colors.white, fontSize: 16),
              bottom: Tab(
                height: 80,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [KColors.instaGreen, KColors.scaffoldBackgroundColor],
                    ),
                  ),
                  child: AppTextField(
                    hintText: context.tr(AppLocalizations.search),
                    height: 45,
                    hideKeyboardOnTapOutside: true,
                    leading: const SvgIcon(icon: SvgIcons.search, size: 20, color: KColors.buttonGrey),
                    filledColor: Colors.white,
                    radius: 30,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: Builder(
            builder: (context) {
              if (rooms == null) {
                return const Center(
                  child: LoadingIndicator(),
                );
              } else if (rooms.isEmpty) {
                return Center(
                  child: AppText(
                    context.tr(AppLocalizations.noChats),
                    color: KColors.deepNavyBlue,
                    fontSize: 12,
                  ),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (_, __) => const Divider(color: KColors.disabled, thickness: 0.2, height: 0),
                  itemCount: rooms.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final room = rooms[index];

                    return SizedBox(
                      height: 60,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => GoRouter.of(context).pushNamed(
                            ChatPage.route,
                            extra: {
                              "room": room,
                              "receiver_id": room.recipient?.id,
                            },
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                ProfileAvatar(image: room.recipient?.photoUrl ?? '', scale: 40),
                                const SizedBox(width: 10),
                                Expanded(child: AppText(room.recipient?.name ?? '', maxLines: 1)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
