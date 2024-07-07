import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../splash_screen.dart';
import '../../widgets/app_text.dart';
import '../../widgets/button.dart';
import '../constants/kcolors.dart';
import '../shared/shared.dart';

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({super.key});

  static const String route = "route-not-found-page";

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.red, Colors.black],
                      ).createShader(bounds);
                    },
                    child: const AppText(
                      "404",
                      color: Colors.white,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w700,
                      fontSize: 72,
                      height: 1.0,
                    ),
                  ),
                  const AppText(
                    "Page not found",
                    color: Colors.black,
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 1.0,
                  ),
                  const SizedBox(height: 30),
                  const AppText(
                    "Oops! This page seems to be missing.\nPlease check the URL and try again.",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  const Spacer(),
                  const AppText(
                    appName,
                    color: KColors.deepNavyBlue,
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    height: 1.0,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    onTap: () => GoRouter.of(context).goNamed(SplashScreen.route),
                    height: 50,
                    text: "Go to home",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
