import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services.dart';
import '../models/product_model.dart';
import 'state.dart';

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  void setState(HomeState value) => state = value;

  Future<void> getProducts() async {
    final products = await ApiServices.getProducts();
    setState(state.copyWith(products: products));
  }

  Future<void> addOrRemoveFavouriteLocal(String productId) async {
    final updated = state.products!.addOrRemoveFavorite(productId);
    setState(state.copyWith(products: updated.toList()));
  }
}
