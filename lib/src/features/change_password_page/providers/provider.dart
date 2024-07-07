import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api_services.dart';
import '../../../utils/dialog/dailog_helper.dart';
import 'state.dart';

final changePasswordProvider = StateNotifierProvider.autoDispose<ChangePasswordNotifier, ChangePasswordState>(
  (ref) => ChangePasswordNotifier(),
);

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier() : super(const ChangePasswordState());

  final formKey = GlobalKey<FormState>();

  void setState(ChangePasswordState value) => state = value;

  Future<void> changePassword(BuildContext context, WidgetRef ref) async {
    final validated = formKey.currentState?.validate() ?? false;
    if (!validated) return;

    DialogHelper.showloading(context);
    final success = await ApiServices.changePassword(state.oldPassword!, state.newPassword!, state.confirmPassword!);
    DialogHelper.removeLoading(context);
    if (success) GoRouter.of(context).pop(); // Go back.
  }
}
