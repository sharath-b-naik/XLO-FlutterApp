import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/shared/shared.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/expansion_tile.dart';
import '../../../widgets/svg_icon.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static const String route = "/support";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                pinned: true,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    const AppBackButton(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        context.tr(AppLocalizations.support),
                        color: KColors.deepNavyBlue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(builder: (context) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 160,
                          height: 160,
                          padding: const EdgeInsets.all(30),
                          decoration: const BoxDecoration(
                            color: KColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const SvgIcon(
                            icon: SvgIcons.support,
                            color: KColors.instaGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const AppText(
                        "FAQs",
                        color: KColors.deepNavyBlue,
                      ),
                      const SizedBox(height: 10),
                      ...[
                        {
                          "question": "How do I create an account?",
                          "answer": "On login screen, enter your phone number and create a password.",
                        },
                        {
                          "question": "How do I change my password?",
                          "answer":
                              "Go to Profile > Change Password. Enter your current password, then your new password twice to confirm. Tap Save to update.",
                        }
                      ].map(
                        (item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: boxShadow,
                            ),
                            child: AppExpansionTile(
                              content: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: AppText(
                                  item['answer']!,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 2,
                                  color: Colors.black87,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        item['question']!,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(CupertinoIcons.chevron_down, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      const AppText(
                        "Contact Information",
                        color: KColors.deepNavyBlue,
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          AppText(
                            "Support Email: ",
                            fontSize: 12,
                          ),
                          Expanded(
                            child: AppText(
                              "sharathnaik89@gmail.com",
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              color: KColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
