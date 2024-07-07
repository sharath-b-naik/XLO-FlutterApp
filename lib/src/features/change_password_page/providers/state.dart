import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) = _ChangePasswordState;
}
