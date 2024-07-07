import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    String? phone,
    String? password,
    String? confirmPassword,
    @Default(false) bool isSignUp,
    @Default(false) bool enableSubmit,
    @Default(false) bool isAuthenticating,
  }) = _LoginState;
}
