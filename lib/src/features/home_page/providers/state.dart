import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/product_model.dart';

part 'state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    List<ProductModel>? products,
    // List<TaskModel>? requests,
    // @Default([]) List<TableAcpZoneScheme> tableAcpZoneScheme,
    // @Default([]) List<TableStationScheme> tableStationScheme,
    // @Default([]) List<TableStageScheme> tableStageScheme,
  }) = _HomeState;
}
