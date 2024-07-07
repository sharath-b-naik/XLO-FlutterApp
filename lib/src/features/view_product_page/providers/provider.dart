import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services.dart';
import '../../../utils/dialog/dailog_helper.dart';
import '../../home_page/models/product_model.dart';
import '../../home_page/providers/provider.dart';
import '../../my_products_page/providers/provider.dart';
import 'state.dart';

final productViewProvider = StateNotifierProvider.autoDispose<ProductNotifier, ProductViewState>(
  (ref) => ProductNotifier(),
);

class ProductNotifier extends StateNotifier<ProductViewState> {
  ProductNotifier() : super(const ProductViewState());

  void setState(ProductViewState value) => state = value;

  void setProduct(ProductModel product) => setState(state.copyWith(product: product));

  Future<void> favorite(WidgetRef ref, bool favourite) async {
    final productId = state.product!.id!;
    final product = state.product!.copyWith(favourite: !state.product!.favourite);
    setState(state.copyWith(product: product));

    final success = favourite
        ? await ApiServices.deleteFavouriteProduct(productId)
        : await ApiServices.addFavouriteProduct(productId);

    if (success) return ref.read(homeProvider.notifier).addOrRemoveFavouriteLocal(productId);

    // revert to original
    final reverted = state.product!.copyWith(favourite: !state.product!.favourite);
    setState(state.copyWith(product: reverted));
  }

  Future<void> deleteProduct(BuildContext context, WidgetRef ref) async {
    DialogHelper.showloading(context);
    final deleted = await ApiServices.deleteProduct(state.product!.id!);
    DialogHelper.removeLoading(context);
    if (deleted) {
      final provider = ref.read(myProductsProvider.notifier);
      final myProductsState = ref.read(myProductsProvider);
      final updated = myProductsState.products!.where((element) => element.id != state.product?.id).toList();
      provider.setState(myProductsState.copyWith(products: updated));
      Navigator.of(context).pop();
    }
  }
}
