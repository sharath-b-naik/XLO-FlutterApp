import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'src/core/constants/kcolors.dart';
import 'src/core/shared/shared.dart';
import 'src/core/translations/translations.dart';
import 'src/features/authentication/presentation/view/auth_page.dart';
import 'src/features/landing_page/views/landing_page.dart';
import 'src/services/shared_pref_service/shared_pref_service.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static const route = "/";

  Future<void> checkAuthentication(BuildContext context, WidgetRef ref) async {
    AppLocalizations.setLocale(context, ref);
    final String? token = await PrefService.getToken();
    if (token == null) return GoRouter.of(context).goNamed(AuthPage.route);
    final bool success = await setAuthToken(token, ref);
    if (!success) return GoRouter.of(context).goNamed(AuthPage.route);
    GoRouter.of(context).goNamed(LandingPage.route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: KColors.instaGreen,
      body: TweenAnimationBuilder(
        tween: Tween<double>(begin: 15, end: 100),
        duration: const Duration(seconds: 3),
        curve: Curves.easeIn,
        onEnd: () => checkAuthentication(context, ref),
        builder: (context, value, child) {
          return Stack(
            children: [
              Center(
                child: ScaleTransition(
                  scale: AlwaysStoppedAnimation(value),
                  child: Container(
                    height: value,
                    width: value,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Center(
                child: ScaleTransition(
                  scale: AlwaysStoppedAnimation(value),
                  child: Container(
                    height: value - 15,
                    width: value - 15,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    appLogo,
                  ),
                ),
              ),
              const Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
