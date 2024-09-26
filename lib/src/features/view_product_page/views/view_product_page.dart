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
import '../../../widgets/button.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/svg_icon.dart';
import '../../chat_page/views/chat_page.dart';
import '../../home_page/models/product_model.dart';
import '../providers/provider.dart';

class ViewProductPage extends ConsumerStatefulWidget {
  final ProductModel product;
  const ViewProductPage({super.key, required this.product});

  static const String route = "/view-product";

  @override
  ConsumerState<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends ConsumerState<ViewProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productViewProvider.notifier).setProduct(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productViewProvider);
    final product = state.product;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 10,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            AppBackButton(),
          ],
        ),
      ),
      body: Builder(builder: (context) {
        if (product == null) return const Center(child: LoadingIndicator());

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(bRadius),
                    child: InteractiveViewer(
                      child: CachedNetworkImage(
                        repeat: ImageRepeat.noRepeat,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        imageUrl:
                            state.selectedImage ?? (product.images.isEmpty ? "" : product.images.first.url ?? ''),
                        errorWidget: (context, url, error) => const SizedBox(),
                        placeholder: (context, url) => const LoadingIndicator(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...product.images.map(
                            (item) {
                              final selected = item.url == state.selectedImage;
                              return GestureDetector(
                                onTap: () {
                                  if (selected) return;
                                  final provider = ref.read(productViewProvider.notifier);
                                  provider.setState(state.copyWith(selectedImage: item.url));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(bRadius),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                selected ? Colors.black38 : Colors.transparent,
                                                BlendMode.colorBurn,
                                              ),
                                              child: CachedNetworkImage(
                                                repeat: ImageRepeat.noRepeat,
                                                fit: BoxFit.cover,
                                                fadeInDuration: Duration.zero,
                                                fadeOutDuration: Duration.zero,
                                                imageUrl: item.url ?? '',
                                                errorWidget: (context, url, error) => const SizedBox(),
                                                placeholder: (context, url) => const LoadingIndicator(),
                                              ),
                                            ),
                                          ),
                                          if (selected) ...[
                                            const Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KColors.white,
                      borderRadius: BorderRadius.circular(bRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
                                color: product.used ? KColors.deepNavyBlue : Colors.teal,
                              ),
                              child: AppText(
                                product.used ? context.tr(AppLocalizations.used) : context.tr(AppLocalizations.neww),
                                color: KColors.white,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const SvgIcon(icon: SvgIcons.recipt, size: 16),
                                const SizedBox(width: 5),
                                AppText(
                                  "Rs ${product.price ?? 0}",
                                  fontSize: 16,
                                  color: KColors.instaGreen,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        AppText(product.name ?? ''),
                        AppText(
                          product.description ?? '',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KColors.white,
                      borderRadius: BorderRadius.circular(bRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(context.tr(AppLocalizations.moreDetails)),
                        const Divider(),
                        if (product.specifications.isEmpty) ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: AppText(
                                context.tr(AppLocalizations.noProductSpecification),
                                color: KColors.textColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ] else ...[
                          Wrap(
                            runSpacing: 10,
                            spacing: 30,
                            children: [
                              ...product.specifications.map(
                                (item) {
                                  final widget = Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        item.type ?? '',
                                        color: KColors.textColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                      ),
                                      AppText(
                                        item.value ?? '',
                                        color: KColors.deepNavyBlue,
                                      ),
                                    ],
                                  );

                                  return widget;
                                },
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (product.createdBy == userId) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onTap: () => ref.read(productViewProvider.notifier).deleteProduct(context, ref),
                        backgroundColor: KColors.white,
                        borderColor: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SvgIcon(
                              icon: SvgIcons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
                            AppText(
                              context.tr(AppLocalizations.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        onTap: () {},
                        backgroundColor: KColors.instaGreen,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SvgIcon(
                              icon: SvgIcons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            AppText(
                              context.tr(AppLocalizations.edit),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => ref.read(productViewProvider.notifier).favorite(ref, product.favourite),
                      child: Container(
                        height: 45,
                        width: 45,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD6D6D6)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgIcon(
                              icon: product.favourite ? SvgIcons.bookmarkFilled : SvgIcons.bookmark,
                              color: Colors.pink,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                            ChatPage.route,
                            extra: {
                              "room": null,
                              "receiver_id": product.createdBy,
                            },
                          );
                        },
                        backgroundColor: KColors.white,
                        borderColor: KColors.instaGreen,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SvgIcon(
                              icon: SvgIcons.chat,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            AppText(
                              context.tr(AppLocalizations.chat),
                              color: KColors.deepNavyBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        onTap: () {},
                        backgroundColor: KColors.instaGreen,
                        textColor: KColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SvgIcon(
                              icon: SvgIcons.buyNow,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            AppText(
                              context.tr(AppLocalizations.buyNow),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
