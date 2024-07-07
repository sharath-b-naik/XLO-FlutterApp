import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/constants/svg_icons.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/translations/translations.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/expansion_tile.dart';
import '../../../../widgets/rich_text.dart';
import '../../../../widgets/svg_icon.dart';
import '../../../../widgets/text_field.dart';
import '../providers/provider.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  static const String route = "/auth-page";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    final isSignUp = state.isSignUp;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SvgIcon(
              icon: SvgIcons.liquidCheeseBackground,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40.0),
                child: SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          appLogo,
                          height: 150,
                          width: 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppText(
                        isSignUp ? context.tr(AppLocalizations.createAccount) : context.tr(AppLocalizations.login),
                        fontSize: 24,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(bRadius),
                          boxShadow: boxShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: AppTextField(
                                onChanged: ref.read(authProvider.notifier).setPhone,
                                hintText: context.tr(AppLocalizations.phoneNumber),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: AppTextField(
                                onChanged: ref.read(authProvider.notifier).setPassword,
                                hintText: context.tr(AppLocalizations.password),
                                isPassword: true,
                              ),
                            ),
                            AppExpansionTile(
                              expand: isSignUp,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: AppTextField(
                                      onChanged: ref.read(authProvider.notifier).setConfirmPassword,
                                      hintText: context.tr(AppLocalizations.confirmPassword),
                                      isPassword: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        isLoading: state.isAuthenticating,
                        onTap: () {
                          final provider = ref.read(authProvider.notifier);
                          isSignUp ? provider.createAccount(context, ref) : provider.login(context, ref);
                        },
                        text: context.tr(isSignUp ? AppLocalizations.createAccount : AppLocalizations.login),
                      ),
                      const SizedBox(height: 20),
                      AppRichText(
                        texts: [
                          RichItem(
                            isSignUp
                                ? context.tr(AppLocalizations.alreadyHaveAccount)
                                : context.tr(AppLocalizations.dontHaveAccount),
                            fontSize: 12,
                          ),
                          RichItem(
                            " ",
                            fontSize: 12,
                          ),
                          RichItem(
                            isSignUp ? context.tr(AppLocalizations.login) : context.tr(AppLocalizations.createAccount),
                            color: KColors.instaGreen,
                            fontSize: 12,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              final provider = ref.read(authProvider.notifier);
                              final updated = state.copyWith(isSignUp: !isSignUp);
                              provider.setState(updated);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
