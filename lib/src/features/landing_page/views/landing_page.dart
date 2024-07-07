import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/svg_icon.dart';
import '../../add_product_page/views/add_product_page.dart';
import '../../chat_lists_page/providers/provider.dart';
import '../../chat_lists_page/views/chat_lists_page.dart';
import '../../home_page/providers/provider.dart';
import '../../home_page/views/home_page.dart';
import '../../my_products_page/providers/provider.dart';
import '../../my_products_page/views/my_products_page.dart';
import '../../profile_edit_page/providers/provider.dart';
import '../../profile_page/views/profile_page.dart';
import '../providers/navigation_provider.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  static const String route = "/landing";

  static List<Widget> get screens => [
        const HomePage(),
        const ChatListPage(),
        const SizedBox(), // Sell.
        const MyProductsPage(),
        const ProfilePage(),
      ];

  static List<String> get icons => [
        SvgIcons.home,
        SvgIcons.chat,
        SvgIcons.home,
        SvgIcons.userProduct,
        SvgIcons.person,
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int tabindex = ref.watch(navigationProvider);

    List<String> titles = [
      context.tr(AppLocalizations.home),
      context.tr(AppLocalizations.chats),
      context.tr(AppLocalizations.sell),
      context.tr(AppLocalizations.myAds),
      context.tr(AppLocalizations.profile),
    ];

    // Always listen until logout or session is closed.
    ref.watch(homeProvider);
    ref.watch(chatListsProvider);
    ref.watch(myProductsProvider);
    ref.watch(profileEditProvider);

    return PopScope(
      canPop: tabindex != 0 ? false : true,
      onPopInvoked: (value) async {
        if (!value) ref.read(navigationProvider.notifier).setIndex(0);
      },
      child: Scaffold(
        extendBody: true,
        body: LandingPage.screens[tabindex],
        floatingActionButton: FloatingActionButton(
          onPressed: () => GoRouter.of(context).pushNamed(AddProductPage.route),
          backgroundColor: KColors.instaGreen,
          splashColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: 60 + MediaQuery.of(context).padding.bottom,
          color: Colors.white,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                LandingPage.icons.length,
                (index) {
                  final title = titles[index];
                  final icon = LandingPage.icons[index];
                  final selected = index == tabindex;
                  final isSellTab = title == context.tr(AppLocalizations.sell);

                  return Expanded(
                    child: MaterialButton(
                      onPressed: isSellTab ? null : () => ref.read(navigationProvider.notifier).setIndex(index),
                      shape: const CircleBorder(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIcon(
                            icon: icon,
                            size: 20,
                            color: selected
                                ? KColors.instaGreen
                                : isSellTab
                                    ? Colors.transparent
                                    : null,
                          ),
                          AppText(
                            title,
                            fontSize: 10,
                            textAlign: TextAlign.center,
                            color: selected ? KColors.instaGreen : null,
                            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
