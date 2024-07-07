import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home_page/models/product_model.dart';

part 'state.freezed.dart';

@freezed
class ViewProductsState with _$ViewProductsState {
  const factory ViewProductsState({
    List<ProductModel>? products,
  }) = _ViewProductsState;
}
