import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/svg_icon.dart';

const _privacyPolicy = """
Effective Date: Today

XLO ("we", "our", "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application [App Name] (the "App").

We collect various types of information in connection with the services we provide, including personal data (such as your name, email address, and contact details), usage data (such as log information, IP addresses, and interaction with the App), location data (with your consent), and device information (such as device ID and operating system). We use this information to provide and improve our services, communicate with you, personalize your experience, and ensure security.

We share your information with third-party service providers who perform services on our behalf, and we may also share information if required by law or with your explicit consent.
""";

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String route = "/privacy-policy";

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
                        context.tr(AppLocalizations.privacyPolicy),
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
                            icon: SvgIcons.privacy,
                            color: KColors.instaGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const AppText(
                        _privacyPolicy,
                        fontWeight: FontWeight.w400,
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
