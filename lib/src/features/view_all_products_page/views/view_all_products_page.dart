// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/constants/svg_icons.dart';
import '../../../core/shared/shared.dart';
import '../../../core/translations/translations.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/svg_icon.dart';
import '../../../widgets/text_field.dart';
import '../../view_product_page/views/view_product_page.dart';
import '../providers/provider.dart';

class ViewAllProductsPage extends ConsumerStatefulWidget {
  final String? category;
  const ViewAllProductsPage({
    super.key,
    required this.category,
  });

  static const String route = "/view-all-products";

  @override
  ConsumerState<ViewAllProductsPage> createState() => _ViewAllProductsPageState();
}

class _ViewAllProductsPageState extends ConsumerState<ViewAllProductsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(viewProductsProvider.notifier).getProductByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewProductsProvider);
    final products = state.products;

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: KColors.instaGreen,
              pinned: true,
              floating: true,
              leadingWidth: 70,
              leading: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [AppBackButton(color: Colors.white)],
              ),
              titleSpacing: 10,
              title: AppText("${widget.category}", color: Colors.white, fontSize: 16),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [KColors.instaGreen, KColors.scaffoldBackgroundColor],
                ),
              ),
              child: AppTextField(
                hintText: context.tr(AppLocalizations.search),
                height: 45,
                hideKeyboardOnTapOutside: true,
                leading: const SvgIcon(icon: SvgIcons.search, size: 20, color: KColors.buttonGrey),
                filledColor: Colors.white,
                radius: 30,
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Builder(builder: (context) {
                  if (products == null) {
                    {
                      return const Center(
                        child: LoadingIndicator(),
                      );
                    }
                  } else if (products.isEmpty) {
                    return Center(
                      child: AppText(
                        context.tr(AppLocalizations.noProductsInCategory),
                        color: KColors.deepNavyBlue,
                        fontSize: 12,
                      ),
                    );
                  } else {
                    return GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return InkWell(
                          onTap: () => GoRouter.of(context).pushNamed(ViewProductPage.route, extra: product),
                          borderRadius: BorderRadius.circular(bRadius),
                          splashColor: Colors.black12,
                          child: Stack(
                            children: [
                              Ink(
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
                                            maxLines: 2,
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
                        );
                      },
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
