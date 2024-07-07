import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';

import 'src/core/constants/kcolors.dart';
import 'src/core/router/route_config.dart';
import 'src/core/shared/shared.dart';
import 'src/core/translations/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    EasyLocalization(
      supportedLocales: AppLocalizations.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppLocalizations.supportedLocales.first,
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: MaterialApp.router(
        title: appName,
        debugShowCheckedModeBanner: false,
        routerConfig: GoConfig.routerConfig,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          useMaterial3: false,
          scaffoldBackgroundColor: KColors.scaffoldBackgroundColor,
          primaryColor: KColors.deepNavyBlue,
          primarySwatch: Colors.blueGrey,
          fontFamily: "Poppins",
        ),
        builder: (context, child) => OKToast(child: child!),
      ),
    );
  }
}
