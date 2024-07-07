import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/models/uploaded_file.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  static const defaultValue = ProductModel();
  const factory ProductModel({
    String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    String? name,
    String? description,
    int? price,
    String? category,
    @Default(false) bool used,
    @Default(false) bool favourite,
    @Default([]) List<Specification> specifications,
    @Default([]) List<UploadedFile> images,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}

@freezed
class Specification with _$Specification {
  const factory Specification({
    String? type,
    String? value,
  }) = _Specification;

  factory Specification.fromJson(Map<String, dynamic> json) => _$SpecificationFromJson(json);
}

extension ProductModelExt on List<ProductModel> {
  List<ProductModel> addOrRemoveFavorite(String id) => map((item) {
        return item.id != id ? item : item.copyWith(favourite: !item.favourite);
      }).toList();
}
