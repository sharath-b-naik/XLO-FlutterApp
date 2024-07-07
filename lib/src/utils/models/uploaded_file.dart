import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_file.freezed.dart';
part 'uploaded_file.g.dart';

@freezed
class UploadedFile with _$UploadedFile {
  const factory UploadedFile({
    @JsonKey(name: "file_name") String? fileName,
    String? url,
    @JsonKey(name: "content_type") String? contentType,
    @Default(0) int size,
    @JsonKey(name: "storage_path") String? storagePath,
  }) = _UploadedFile;

  factory UploadedFile.fromJson(Map<String, dynamic> json) => _$UploadedFileFromJson(json);
}
