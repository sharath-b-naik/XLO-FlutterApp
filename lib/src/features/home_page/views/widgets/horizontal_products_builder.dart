// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/constants/svg_icons.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/translations/translations.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/svg_icon.dart';
import '../../../view_all_products_page/views/view_all_products_page.dart';
import '../../../view_product_page/views/view_product_page.dart';
import '../../models/product_model.dart';

class HorizontalProductBuilder extends StatelessWidget {
  final String title;
  final Color titleColor;
  final List<ProductModel> products;
  final bool showViewAll;
  const HorizontalProductBuilder({
    super.key,
    required this.title,
    required this.titleColor,
    required this.products,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
              if (showViewAll) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => GoRouter.of(context).pushNamed(ViewAllProductsPage.route, extra: title),
                  child: AppText(
                    context.tr(AppLocalizations.viewAll),
                    fontWeight: FontWeight.w400,
                    color: KColors.textColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...products.map(
                  (product) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => GoRouter.of(context).pushNamed(ViewProductPage.route, extra: product),
                        borderRadius: BorderRadius.circular(bRadius),
                        splashColor: Colors.black12,
                        child: Stack(
                          children: [
                            Ink(
                              width: 150,
                              height: 200,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: KColors.white,
                                borderRadius: BorderRadius.circular(bRadius),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: product.images.first.url ?? '',
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) => const SizedBox(),
                                          placeholder: (context, url) => const LoadingIndicator(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          product.name ?? '',
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 5),
                                        AppText(
                                          product.category ?? '',
                                          fontSize: 10,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 5),
                                        const Spacer(),
                                        const Divider(),
                                        Row(
                                          children: [
                                            const SvgIcon(icon: SvgIcons.recipt, size: 16),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: AppText(
                                                "Rs.${product.price ?? 0}",
                                                color: KColors.deepNavyBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!product.used) ...[
                              Positioned(
                                top: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
                                    color: Colors.pink,
                                  ),
                                  child: AppText(
                                    context.tr(AppLocalizations.neww),
                                    color: KColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
