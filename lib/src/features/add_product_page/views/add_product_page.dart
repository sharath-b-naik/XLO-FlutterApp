import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../core/translations/translations.dart';
import '../../../utils/string_extension.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/button.dart';
import '../../../widgets/dropdrown.dart';
import '../../home_page/models/product_model.dart';
import '../providers/provider.dart';

class AddProductPage extends ConsumerWidget {
  const AddProductPage({super.key});

  static const String route = "/add-product";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addProductProvider);
    final images = state.selectedImages;
    final product = state.product;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFEAEBFC), Colors.white])),
        child: Form(
          key: ref.read(addProductProvider.notifier).formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const AppBackButton(),
                    const SizedBox(width: 10),
                    Expanded(child: AppText(context.tr(AppLocalizations.sellProduct), fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [BoxShadow(color: Color(0x0E000000), blurRadius: 2)],
                    ),
                    child: Builder(
                      builder: (context) {
                        if (images.isEmpty || state.displayingImage == null) {
                          return GestureDetector(
                            onTap: ref.read(addProductProvider.notifier).pickProductImages,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(bRadius),
                              color: KColors.disabled,
                              padding: EdgeInsets.zero,
                              dashPattern: const [6, 3],
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(bRadius),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.photo,
                                      color: KColors.disabled,
                                      size: 42,
                                    ),
                                    const SizedBox(height: 5),
                                    AppText(
                                      context.tr(AppLocalizations.selectImages),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: KColors.disabled,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(state.displayingImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (images.isNotEmpty) ...[
                  Row(
                    children: [
                      ...List.generate(
                        images.length,
                        (index) {
                          final image = images[index];

                          return GestureDetector(
                            onTap: () {
                              final provider = ref.read(addProductProvider.notifier);
                              final updated = state.copyWith(displayingImage: image);
                              provider.setState(updated);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.only(right: 5),
                                alignment: Alignment.topRight,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(bRadius),
                                  image: DecorationImage(
                                    image: FileImage(File(image)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () => ref.read(addProductProvider.notifier).removeProductImage(image),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: ref.read(addProductProvider.notifier).pickProductImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          color: KColors.disabled,
                          padding: EdgeInsets.zero,
                          dashPattern: const [6, 3],
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.plus,
                                  color: KColors.disabled,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 30),
                AppText(context.tr(AppLocalizations.productName)),
                TextFormField(
                  onChanged: (value) {
                    final provider = ref.read(addProductProvider.notifier);
                    final updated = product.copyWith(name: value.trim().isEmpty ? null : value);
                    provider.setState(state.copyWith(product: updated));
                  },
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: context.tr(AppLocalizations.enterProductName),
                    hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AppText(context.tr(AppLocalizations.category)),
                AppDropDown(
                  value: state.product.category,
                  onChanged: (category) {
                    if (category == null) return;
                    final provider = ref.read(addProductProvider.notifier);
                    final updated = product.copyWith(category: category.trim().isEmpty ? null : category);
                    provider.setState(state.copyWith(product: updated));
                  },
                  validator: (value) => value == null ? context.tr(AppLocalizations.required) : null,
                  hinttext: context.tr(AppLocalizations.selectCategory),
                  items: categories.map((item) => item['category'].toString().toTitleCase()).toList(),
                ),
                const SizedBox(height: 30),
                AppText(context.tr(AppLocalizations.description)),
                TextFormField(
                  onChanged: (value) {
                    final provider = ref.read(addProductProvider.notifier);
                    final updated = product.copyWith(description: value.trim().isEmpty ? null : value);
                    provider.setState(state.copyWith(product: updated));
                  },
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                  maxLines: 5,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: context.tr(AppLocalizations.enterDescription),
                    hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AppText(context.tr(AppLocalizations.price)),
                TextFormField(
                  onChanged: (value) {
                    final provider = ref.read(addProductProvider.notifier);
                    final price = value.trim().isEmpty ? 0 : int.parse(value);
                    final updated = product.copyWith(price: price);
                    provider.setState(state.copyWith(product: updated));
                  },
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? context.tr(AppLocalizations.required) : null,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: context.tr(AppLocalizations.enterPrice),
                    hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFDD2C2C)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                      borderRadius: BorderRadius.circular(8),
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
                      AppText(context.tr(AppLocalizations.moreDetails)),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(context.tr(AppLocalizations.addInfo), fontWeight: FontWeight.w400),
                                const AppText("E.g. RAM : 16GB", fontWeight: FontWeight.w300, fontSize: 8),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              final provider = ref.read(addProductProvider.notifier);
                              final specifications = [...product.specifications, const Specification()];
                              final updated = product.copyWith(specifications: specifications);
                              provider.setState(state.copyWith(product: updated));
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFD6D6D6)),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.plus,
                                    color: KColors.deepNavyBlue,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      ...List.generate(
                        product.specifications.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: AppText(
                                    "${index + 1}.",
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      final type = value.trim().isEmpty ? null : value;
                                      final specifications = [...product.specifications];
                                      specifications[index] = specifications[index].copyWith(type: type);

                                      final provider = ref.read(addProductProvider.notifier);
                                      final updated = product.copyWith(specifications: specifications);
                                      provider.setState(state.copyWith(product: updated));
                                    },
                                    maxLines: 5,
                                    minLines: 1,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: context.tr(AppLocalizations.type),
                                      hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const AppText(":"),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      final typeValue = value.trim().isEmpty ? null : value;
                                      final specifications = [...product.specifications];
                                      specifications[index] = specifications[index].copyWith(value: typeValue);

                                      final provider = ref.read(addProductProvider.notifier);
                                      final updated = product.copyWith(specifications: specifications);
                                      provider.setState(state.copyWith(product: updated));
                                    },
                                    maxLines: 5,
                                    minLines: 1,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: context.tr(AppLocalizations.value),
                                      hintStyle: const TextStyle(color: KColors.textColor, fontSize: 12),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    final provider = ref.read(addProductProvider.notifier);
                                    final specifications = [...product.specifications];
                                    specifications.removeAt(index);
                                    final updated = product.copyWith(specifications: specifications);
                                    provider.setState(state.copyWith(product: updated));
                                  },
                                  child: const SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.clear,
                                          color: KColors.deepNavyBlue,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              context.tr(AppLocalizations.isUsedProduct),
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Switch(
                            value: product.used,
                            activeColor: KColors.instaGreen,
                            onChanged: (value) {
                              final provider = ref.read(addProductProvider.notifier);
                              final updated = product.copyWith(used: !product.used);
                              provider.setState(state.copyWith(product: updated));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: () => ref.read(addProductProvider.notifier).addProduct(context, ref),
                  backgroundColor: KColors.instaGreen,
                  textColor: KColors.white,
                  text: context.tr(AppLocalizations.sell),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
