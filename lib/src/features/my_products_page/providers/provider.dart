import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services.dart';
import '../../../utils/dialog/dailog_helper.dart';
import '../../home_page/providers/provider.dart';
import 'state.dart';

final myProductsProvider = StateNotifierProvider.autoDispose<MyProducts, MyProductsState>(
  (ref) => MyProducts(),
);

class MyProducts extends StateNotifier<MyProductsState> {
  MyProducts() : super(const MyProductsState());

  void setState(MyProductsState value) => state = value;

  Future<void> getMyProducts() async {
    final products = await ApiServices.getProducts(mine: true);
    setState(state.copyWith(products: products));
  }

  Future<void> getFavouriteProducts() async {
    final favouriteProducts = await ApiServices.getProducts(favourite: true);
    setState(state.copyWith(favouriteProducts: favouriteProducts));
  }

  Future<void> deleteProduct(BuildContext context, String productId) async {
    DialogHelper.showloading(context);
    final deleted = await ApiServices.deleteProduct(productId);
    DialogHelper.removeLoading(context);
    if (deleted) {
      final updated = state.products!.where((element) => element.id != productId).toList();
      setState(state.copyWith(products: updated));
    }
  }

  Future<void> removeFavorite(WidgetRef ref, String productId) async {
    final success = await ApiServices.deleteFavouriteProduct(productId);
    if (!success) return;
    ref.read(homeProvider.notifier).addOrRemoveFavouriteLocal(productId);
    final favouriteProducts = state.favouriteProducts!.where((item) => item.id != productId).toList();
    setState(state.copyWith(favouriteProducts: favouriteProducts));
  }
}
