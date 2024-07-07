import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/button.dart';
import '../../../widgets/svg_icon.dart';
import '../providers/provider.dart';

class ChangePasswordPage extends ConsumerWidget {
  const ChangePasswordPage({super.key});

  static const String route = "/change-password";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changePasswordProvider);

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
                        context.tr(AppLocalizations.changePassword),
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
                  child: Form(
                    key: ref.read(changePasswordProvider.notifier).formKey,
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
                              icon: SvgIcons.lock,
                              color: KColors.instaGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: AppText(context.tr(AppLocalizations.oldPassword)),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            final provider = ref.read(changePasswordProvider.notifier);
                            final updated = state.copyWith(oldPassword: value.trim().isEmpty ? null : value);
                            provider.setState(updated);
                          },
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            hintText: context.tr(AppLocalizations.enterOldPassword),
                            hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: AppText(context.tr(AppLocalizations.newPassword)),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            final provider = ref.read(changePasswordProvider.notifier);
                            final updated = state.copyWith(newPassword: value.trim().isEmpty ? null : value);
                            provider.setState(updated);
                          },
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: context.tr(AppLocalizations.enterNewPassword),
                            contentPadding: const EdgeInsets.all(15),
                            hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: AppText(context.tr(AppLocalizations.confirmNewPassword)),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            final provider = ref.read(changePasswordProvider.notifier);
                            final updated = state.copyWith(confirmPassword: value.trim().isEmpty ? null : value);
                            provider.setState(updated);
                          },
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: context.tr(AppLocalizations.enterNewPasswordAgain),
                            contentPadding: const EdgeInsets.all(15),
                            hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppButton(
                          onTap: () => ref.read(changePasswordProvider.notifier).changePassword(context, ref),
                          backgroundColor: KColors.instaGreen,
                          textColor: KColors.white,
                          text: context.tr(AppLocalizations.changePassword),
                        ),
                      ],
                    ),
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
