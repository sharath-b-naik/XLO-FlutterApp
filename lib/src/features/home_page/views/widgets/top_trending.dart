import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/shared/shared.dart';

class TopTrending extends ConsumerWidget {
  const TopTrending({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(seconds: 2),
              viewportFraction: 0.9,
              height: double.infinity,
            ),
            items: [
              "assets/banners/banner1.png",
              "assets/banners/banner2.png",
              "assets/banners/banner3.png",
              "assets/banners/banner4.png",
              "assets/banners/banner5.png",
              "assets/banners/banner6.png",
            ].map((banner) => TopTrendingCard(banner: banner)).toList(),
          ),
        ),
      ],
    );
  }
}

class TopTrendingCard extends StatelessWidget {
  final String banner;

  const TopTrendingCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: KColors.white,
          borderRadius: BorderRadius.circular(bRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
