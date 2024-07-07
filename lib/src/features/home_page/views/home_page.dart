import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/shared/shared.dart';
import '../../../core/translations/translations.dart';
import '../../../utils/string_extension.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/svg_icon.dart';
import '../providers/provider.dart';
import 'widgets/categories_builder.dart';
import 'widgets/horizontal_products_builder.dart';
import 'widgets/top_trending.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const String route = "/home";

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(homeProvider.notifier).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    final products = state.products;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 320,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        Container(
                          height: 220,
                          decoration: const BoxDecoration(
                            color: KColors.instaGreen,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                          ),
                        ),
                        Container(
                          height: 100,
                          color: KColors.scaffoldBackgroundColor,
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 300,
                            width: 300,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(22, 255, 255, 255),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -50,
                          left: 0,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                              color: Color(0x08FFFFFF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Consumer(builder: (context, ref, child) {
                                            final name = ref.watch(loggedUserProivder.select((value) => value?.name));
                                            return AppText(
                                              "Hi, ${name ?? ''}",
                                              fontSize: 18,
                                              color: Colors.white,
                                              maxLines: 1,
                                              fontWeight: FontWeight.bold,
                                            );
                                          }),
                                          AppText(
                                            DateTime.now().toString().toDate('MMMM dd, yyyy'),
                                            color: Colors.white,
                                            maxLines: 2,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ClipOval(
                                      child: Material(
                                        color: Colors.white12,
                                        shape: const CircleBorder(),
                                        child: IconButton(
                                          onPressed: () {},
                                          padding: EdgeInsets.zero,
                                          color: Colors.red,
                                          icon: const SvgIcon(
                                            icon: SvgIcons.notification,
                                            size: 24,
                                            color: KColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: TopTrending(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 20, bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: KColors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SvgIcon(icon: SvgIcons.search, color: KColors.disabled),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        context.tr(AppLocalizations.searchFavoriteProducts),
                        fontWeight: FontWeight.w400,
                        color: KColors.disabled,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CategoriesBuilder(),
            HorizontalProductBuilder(
              title: context.tr(AppLocalizations.featuredProducts),
              titleColor: Colors.red,
              products: products ?? [],
              showViewAll: false,
            ),
            const SizedBox(height: 20),
            HorizontalProductBuilder(
              title: context.tr(AppLocalizations.electronicsAppliances),
              titleColor: KColors.deepNavyBlue,
              products:
                  (products ?? []).where((element) => element.category!.contains("Electronics & Appliances")).toList(),
            ),
            const SizedBox(height: 20),
            HorizontalProductBuilder(
              title: context.tr(AppLocalizations.vehicles),
              titleColor: KColors.deepNavyBlue,
              products: (products ?? []).where((element) => element.category!.contains("Vehicles")).toList(),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
