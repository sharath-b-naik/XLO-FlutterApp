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
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/svg_icon.dart';
import '../../../widgets/tab_indicator.dart';
import '../../../widgets/text_field.dart';
import '../../home_page/models/product_model.dart';
import '../../view_product_page/views/view_product_page.dart';
import '../providers/provider.dart';

class MyProductsPage extends ConsumerStatefulWidget {
  const MyProductsPage({super.key});

  static const String route = "/my-products";

  @override
  ConsumerState<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends ConsumerState<MyProductsPage> with SingleTickerProviderStateMixin {
  late final TabController tabcontroller = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    ref.read(myProductsProvider.notifier).getMyProducts();
    ref.read(myProductsProvider.notifier).getFavouriteProducts();
  }

  @override
  void dispose() {
    tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProductsProvider);

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: KColors.instaGreen,
                pinned: true,
                floating: true,
                title: AppText(context.tr(AppLocalizations.myProducts), color: Colors.white, fontSize: 16),
                bottom: TabBar(
                  controller: tabcontroller,
                  labelColor: KColors.white,
                  indicator: const MaterialIndicator(),
                  indicatorSize: TabBarIndicatorSize.label,
                  padding: EdgeInsets.zero,
                  onTap: (value) {},
                  tabs: [
                    context.tr(AppLocalizations.myAds),
                    context.tr(AppLocalizations.favourites),
                  ].map((tab) => Tab(text: tab)).toList(),
                ),
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
              const SizedBox(height: 20),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: TabBarView(
                    controller: tabcontroller,
                    children: [
                      if (state.products == null) ...[
                        const Center(
                          child: LoadingIndicator(),
                        )
                      ] else if (state.products!.isEmpty) ...[
                        Center(
                          child: AppText(
                            context.tr(AppLocalizations.noAdsFound),
                            color: KColors.deepNavyBlue,
                            fontSize: 12,
                          ),
                        ),
                      ] else ...[
                        ListView.separated(
                          itemCount: state.products?.length ?? 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final product = state.products![index];
                            return MyAdCard(product: product);
                          },
                        ),
                      ],

                      ///
                      ///
                      ///
                      if (state.favouriteProducts == null) ...[
                        const Center(
                          child: LoadingIndicator(),
                        )
                      ] else if (state.favouriteProducts!.isEmpty) ...[
                        Center(
                          child: AppText(
                            context.tr(AppLocalizations.noFavourites),
                            color: KColors.deepNavyBlue,
                            fontSize: 12,
                          ),
                        ),
                      ] else ...[
                        ListView.separated(
                          itemCount: state.favouriteProducts?.length ?? 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final product = state.favouriteProducts![index];
                            return MyAdCard(product: product, isFavorite: true);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyAdCard extends ConsumerWidget {
  final ProductModel product;
  final bool isFavorite;
  const MyAdCard({
    super.key,
    required this.product,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).pushNamed(ViewProductPage.route, extra: product),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: KColors.white,
          borderRadius: BorderRadius.circular(bRadius),
          boxShadow: boxShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: product.images.first.url ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      product.name ?? '',
                      maxLines: 1,
                    ),
                    AppText(
                      product.category ?? '',
                      color: KColors.disabled,
                      fontWeight: FontWeight.w400,
                      maxLines: 1,
                      fontSize: 10,
                    ),
                    const SizedBox(height: 5),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
                            color: product.used ? Colors.pink : Colors.teal,
                          ),
                          child: AppText(
                            product.used ? context.tr(AppLocalizations.used) : context.tr(AppLocalizations.neww),
                            color: KColors.white,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        AppText(
                          "Rs. ${product.price}",
                          color: KColors.deepNavyBlue,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (product.favourite) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => ref.read(myProductsProvider.notifier).removeFavorite(ref, product.id!),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: KColors.instaGreen.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const SvgIcon(
                                icon: SvgIcons.bookmarkFilled,
                                color: KColors.instaGreen,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => ref.read(myProductsProvider.notifier).deleteProduct(context, product.id!),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const SvgIcon(
                                icon: SvgIcons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: KColors.instaGreen.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const SvgIcon(
                                icon: SvgIcons.edit,
                                color: KColors.instaGreen,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
