import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home_page/models/product_model.dart';

part 'state.freezed.dart';

@freezed
class ProductViewState with _$ProductViewState {
  const factory ProductViewState({
    String? selectedImage,
    ProductModel? product,
    // List<MyTask>? mytaks,
    // List<TaskModel>? requests,
    // @Default([]) List<TableAcpZoneScheme> tableAcpZoneScheme,
    // @Default([]) List<TableStationScheme> tableStationScheme,
    // @Default([]) List<TableStageScheme> tableStageScheme,
  }) = _ProductViewState;
}
