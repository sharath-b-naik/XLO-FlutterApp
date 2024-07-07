import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home_page/models/product_model.dart';

part 'state.freezed.dart';

@freezed
class MyProductsState with _$MyProductsState {
  const factory MyProductsState({
    List<ProductModel>? products,
    List<ProductModel>? favouriteProducts,
  }) = _MyProductsState;
}
