import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/button.dart';
import '../../../widgets/profile_avatar.dart';
import '../providers/provider.dart';

class ProfileEditPage extends ConsumerWidget {
  const ProfileEditPage({super.key});

  static const String route = "/profile-edit";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditProvider);
    final loggedUser = ref.watch(loggedUserProivder);

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
                        context.tr(AppLocalizations.profile),
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
                    key: ref.read(profileEditProvider.notifier).formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey(loggedUser?.photoUrl ?? ''),
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return ScaleTransition(
                                scale: AlwaysStoppedAnimation(value),
                                child: ProfileAvatar(
                                  image: loggedUser?.photoUrl,
                                  scale: 120,
                                  errorIconSize: 32,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppText(context.tr(AppLocalizations.fullName)),
                        TextFormField(
                          initialValue: loggedUser?.name,
                          onChanged: (value) {
                            final provider = ref.read(profileEditProvider.notifier);
                            final updated = state.copyWith(name: value.trim().isEmpty ? null : value);
                            provider.setState(updated);
                          },
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: context.tr(AppLocalizations.enterFullName),
                            hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppText(context.tr(AppLocalizations.email)),
                        TextFormField(
                          initialValue: loggedUser?.email,
                          onChanged: (value) {
                            final provider = ref.read(profileEditProvider.notifier);
                            final updated = state.copyWith(email: value.trim().isEmpty ? null : value);
                            provider.setState(updated);
                          },
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: context.tr(AppLocalizations.enterEmailAddress),
                            hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppText(context.tr(AppLocalizations.phoneNumber)),
                        TextFormField(
                          initialValue: loggedUser?.phone,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: const TextStyle(fontSize: 14, color: KColors.deepNavyBlue),
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: context.tr(AppLocalizations.enterPhoneNumber),
                            hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppButton(
                          onTap: () => ref.read(profileEditProvider.notifier).updateProfile(context, ref),
                          backgroundColor: KColors.instaGreen,
                          textColor: KColors.white,
                          text: context.tr(AppLocalizations.update),
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
