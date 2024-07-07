// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/shared/shared.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/profile_avatar.dart';
import '../../../widgets/svg_icon.dart';
import '../../change_password_page/views/change_password_page.dart';
import '../../contact_page/views/contact_page.dart';
import '../../privacy_policy_page/views/privacy_policy_page.dart';
import '../../profile_edit_page/views/profile_edit_page.dart';
import '../../support_page/views/support_page.dart';
import '../providers/provider.dart';
import 'widgets/change_language_dialog.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const String route = "/profile";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedUser = ref.watch(loggedUserProivder);

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: KColors.instaGreen,
              floating: true,
              pinned: true,
              title: AppText(context.tr(AppLocalizations.profile), color: Colors.white, fontSize: 16),
            )
          ];
        },
        body: SingleChildScrollView(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.3, 0.7, 1.0],
                      colors: [KColors.instaGreen, Color(0xFFF2F8FF), KColors.scaffoldBackgroundColor],
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: KColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        if (loggedUser?.photoUrl != null)
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ProfileAvatar(image: loggedUser?.photoUrl, scale: 100),
                              Positioned(
                                right: -5,
                                bottom: -5,
                                child: CupertinoButton(
                                  onPressed: () => ref.read(profileProvider.notifier).uploadPhoto(context, ref),
                                  padding: const EdgeInsets.only(),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: KColors.deepNavyBlue, width: 0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const SvgIcon(
                                      icon: SvgIcons.edit,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              loggedUser?.name ?? context.tr(AppLocalizations.unknown),
                              fontSize: 16,
                              color: KColors.deepNavyBlue,
                            ),
                            AppText(
                              loggedUser?.phone ?? '-',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: KColors.deepNavyBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: KColors.white,
                    boxShadow: boxShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppText(context.tr(AppLocalizations.account), fontSize: 16),
                        ),
                        const Divider(height: 0, thickness: 2, color: Colors.black12),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.editProfile), // "Edit profile",
                          icon: SvgIcons.edit,
                          onTap: () => GoRouter.of(context).pushNamed(ProfileEditPage.route),
                          iconColor: Colors.purple,
                        ),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.changePassword), // "Change password",
                          icon: SvgIcons.lock,
                          onTap: () => GoRouter.of(context).pushNamed(ChangePasswordPage.route),
                          iconColor: Colors.cyan,
                        ),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.language), // "Language",
                          icon: SvgIcons.language,
                          onTap: () => showLanguageChangeDialog(context),
                          iconColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: KColors.white,
                    boxShadow: boxShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppText(context.tr(AppLocalizations.general), fontSize: 16),
                        ),
                        const Divider(height: 0, thickness: 2, color: Colors.black12),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.contact), // "Contact",
                          icon: SvgIcons.contact,
                          onTap: () => GoRouter.of(context).pushNamed(ContactPage.route),
                          iconColor: Colors.pink,
                        ),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.support), // "Support",
                          icon: SvgIcons.support,
                          onTap: () => GoRouter.of(context).pushNamed(SupportPage.route),
                          iconColor: Colors.green,
                        ),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.privacyPolicy), // "Privacy policy",
                          icon: SvgIcons.privacy,
                          onTap: () => GoRouter.of(context).pushNamed(PrivacyPolicyPage.route),
                          iconColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: KColors.white,
                    boxShadow: boxShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppText(context.tr(AppLocalizations.more), fontSize: 16),
                        ),
                        const Divider(height: 0, thickness: 2, color: Colors.black12),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.referEarn), // "Refer & earn",
                          icon: SvgIcons.refer,
                          iconColor: KColors.blue,
                          onTap: () {},
                        ),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.logout), // "Logout",
                          icon: SvgIcons.logout,
                          iconColor: KColors.orange,
                          onTap: () => ref.read(profileProvider.notifier).logout(context),
                        ),
                        _ProfileButton(
                          title: context.tr(AppLocalizations.deleteAccount), // "Delete account",
                          icon: SvgIcons.warning,
                          iconColor: Colors.red,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  const _ProfileButton({
    required this.title,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (iconColor ?? KColors.instaGreen).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: SvgIcon(
                      icon: icon,
                      size: 20,
                      color: iconColor ?? KColors.instaGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppText(
                      title,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 0, color: Colors.black12)
      ],
    );
  }
}
