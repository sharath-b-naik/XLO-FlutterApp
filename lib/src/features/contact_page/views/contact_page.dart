import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/svg_icon.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static const String route = "/contact";

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
                        context.tr(AppLocalizations.contact),
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
                            icon: SvgIcons.contact,
                            color: KColors.instaGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: AppText(context.tr(AppLocalizations.contactDetails)),
                      ),
                      const SizedBox(height: 16),
                      const ContactCard()
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

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Sharath B Naik",
            fontSize: 18,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SvgIcon(icon: SvgIcons.gmail, size: 16),
              SizedBox(width: 10),
              Expanded(
                child: AppText(
                  "sharathnaik89@gmail.com",
                  color: KColors.blue,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SvgIcon(icon: SvgIcons.github, size: 16),
              SizedBox(width: 10),
              Expanded(
                child: AppText(
                  "https://github.com/sharath-b-naik",
                  color: KColors.blue,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SvgIcon(icon: SvgIcons.linkedin, size: 16),
              SizedBox(width: 10),
              Expanded(
                child: AppText(
                  "https://www.linkedin.com/in/sharath-b-naik-6184101b8/",
                  color: KColors.blue,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
