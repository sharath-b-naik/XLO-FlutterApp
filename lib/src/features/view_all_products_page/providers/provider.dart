import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services.dart';
import 'state.dart';

final viewProductsProvider = StateNotifierProvider.autoDispose<ViewProducts, ViewProductsState>(
  (ref) => ViewProducts(),
);

class ViewProducts extends StateNotifier<ViewProductsState> {
  ViewProducts() : super(const ViewProductsState());

  void setState(ViewProductsState value) => state = value;

  Future<void> getProductByCategory(String? category) async {
    final products = await ApiServices.getProducts(category: category);
    setState(state.copyWith(products: products));
  }
}
