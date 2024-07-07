import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/constants/kcolors.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/translations/translations.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/svg_icon.dart';
import '../../../view_all_products_page/views/view_all_products_page.dart';

class CategoriesBuilder extends StatelessWidget {
  const CategoriesBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    context.tr(AppLocalizations.categories),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: KColors.deepNavyBlue,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...categories.map(
                  (item) {
                    final category = context.tr(item['category']);
                    final icon = item['icon'];
                    final color = item['color'] as int;

                    return GestureDetector(
                      onTap: () => GoRouter.of(context).pushNamed(ViewAllProductsPage.route, extra: category),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 70,
                          child: Column(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(60),
                                onTap: () =>
                                    GoRouter.of(context).pushNamed(ViewAllProductsPage.route, extra: category),
                                child: Ink(
                                  padding: const EdgeInsets.all(18),
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 243, 243, 243),
                                    shape: BoxShape.circle,
                                    boxShadow: boxShadow,
                                  ),
                                  child: SvgIcon(
                                    icon: icon,
                                    color: Color(color),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              AppText(
                                category,
                                fontSize: 10,
                                textAlign: TextAlign.center,
                                color: KColors.deepNavyBlue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
