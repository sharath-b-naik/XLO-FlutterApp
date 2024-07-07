import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/shared.dart';
import '../../../../services/api_services.dart';
import '../../../../services/shared_pref_service/shared_pref_service.dart';
import '../../../../utils/custom_toast.dart';
import '../../../landing_page/views/landing_page.dart';
import 'state.dart';

final authProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) => LoginNotifier());

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  void setState(LoginState value) => state = value;

  void setPhone(String value) {
    final email = value.trim().isEmpty ? null : value.trim();
    final updated = state.copyWith(phone: email);
    setState(updated);
  }

  void setPassword(String value) {
    final password = value.trim().isEmpty ? null : value.trim();
    final updated = state.copyWith(password: password);
    setState(updated);
  }

  void setConfirmPassword(String value) {
    final password = value.trim().isEmpty ? null : value.trim();
    final updated = state.copyWith(confirmPassword: password);
    setState(updated);
  }

  void login(BuildContext context, WidgetRef ref) async {
    if (state.phone == null || state.password == null) return;
    setState(state.copyWith(isAuthenticating: true));
    final String? token = await ApiServices.login(state.phone!, state.password!);
    if (token != null) {
      await PrefService.saveToken(token);
      final success = await setAuthToken(token, ref);
      if (!success) Toast.failure("Something went wrong");
      if (success) GoRouter.of(context).goNamed(LandingPage.route);
    }
    setState(state.copyWith(isAuthenticating: false));
  }

  void createAccount(BuildContext context, WidgetRef ref) async {
    if (state.phone == null || state.password == null) return;
    if (state.password != state.confirmPassword) return Toast.failure("Password not matched");
    setState(state.copyWith(isAuthenticating: true));
    final String? hasError = await ApiServices.createAccount(state.phone!, state.password!);
    setState(state.copyWith(isAuthenticating: false, isSignUp: hasError != null));
    if (hasError == null) Toast.success("Account created successfully. Please login");
  }
}
