import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home_page/models/product_model.dart';

part 'state.freezed.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState({
    String? displayingImage,
    @Default([]) List<String> selectedImages,
    @Default(ProductModel.defaultValue) ProductModel product,
  }) = _AddProductState;
}
