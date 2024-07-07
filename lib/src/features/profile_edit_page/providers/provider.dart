import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/shared/shared.dart';
import '../../../services/api_services.dart';
import '../../../utils/dialog/dailog_helper.dart';
import 'state.dart';

final profileEditProvider = StateNotifierProvider.autoDispose<ProfileEditNotifier, ProfileEditState>(
  (ref) => ProfileEditNotifier(),
);

class ProfileEditNotifier extends StateNotifier<ProfileEditState> {
  ProfileEditNotifier() : super(const ProfileEditState());

  final formKey = GlobalKey<FormState>();

  void setState(ProfileEditState value) => state = value;

  Future<void> updateProfile(BuildContext context, WidgetRef ref) async {
    final validated = formKey.currentState?.validate() ?? false;
    if (!validated) return;
    if (state.name == null && state.email == null) return;

    DialogHelper.showloading(context);
    final success = await ApiServices.updateUserDetails(state.name, state.email);
    DialogHelper.removeLoading(context);
    if (success != null) ref.read(loggedUserProivder.notifier).state = success;

    GoRouter.of(context).pop(); // Go back.
  }
}
