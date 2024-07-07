import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/translations/translations.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/button.dart';

Future<bool?> showLanguageChangeDialog(BuildContext context) async {
  String? selectedLang;
  Locale? selectedLocale;

  return showDialog<bool?>(
    context: context,
    barrierColor: Colors.black38,
    builder: (context) {
      return Dialog(
        backgroundColor: KColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(builder: (context, stateSetter) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          context.tr(AppLocalizations.language),
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => GoRouter.of(context).pop(false),
                        child: const Icon(
                          Icons.cancel,
                          color: KColors.buttonGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...[
                    {"locale": const Locale('en', 'US'), "lang": "English"},
                    {"locale": const Locale('kn', 'IN'), "lang": "Kannada"},
                    {"locale": const Locale('hi', 'IN'), "lang": "Hindi"},
                  ].map(
                    (item) {
                      final lang = item['lang'] as String;
                      final locale = item['locale'] as Locale;

                      return Row(
                        children: [
                          Radio(
                            value: lang,
                            groupValue: selectedLang,
                            onChanged: (value) {
                              selectedLang = lang;
                              selectedLocale = locale;
                              stateSetter(() {});
                            },
                          ),
                          AppText(
                            lang,
                            color: Colors.black,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    onTap: () {
                      log(selectedLocale.toString());
                      if (selectedLocale == null) return;
                      context.setLocale(selectedLocale!);
                    },
                    height: 40,
                    text: context.tr(AppLocalizations.update),
                  )
                ],
              );
            }),
          ),
        ),
      );
    },
  );
}
