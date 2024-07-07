import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/shared/shared.dart';
import '../../../services/api_services.dart';
import '../../../services/file_service/file_service.dart';
import '../../../services/shared_pref_service/shared_pref_service.dart';
import '../../../utils/dialog/crop_image_diolog.dart';
import '../../../utils/dialog/dailog_helper.dart';
import '../../authentication/presentation/view/auth_page.dart';
import 'state.dart';

final profileProvider = StateNotifierProvider.autoDispose<ProfileNotifier, ChatState>(
  (ref) => ProfileNotifier(),
);

class ProfileNotifier extends StateNotifier<ChatState> {
  ProfileNotifier() : super(const ChatState());

  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  void setState(ChatState value) => state = value;

  Future<void> uploadPhoto(BuildContext context, WidgetRef ref) async {
    final photo = await FileServiceX.pickGallaryImage();
    if (photo == null) return;
    final cropeedImage = await cropImageDialog(context, photo);
    if (cropeedImage == null) return;
    DialogHelper.showloading(context);
    final result = await ApiServices.uploadPhoto(cropeedImage.path);
    DialogHelper.removeLoading(context);
    if (result == null) return;
    ref.read(loggedUserProivder.notifier).state = result;
  }

  void logout(BuildContext context) async {
    DialogHelper.showloading(context);
    userId = null;
    authToken = null;
    await PrefService.saveToken(null); // clear the token,
    DialogHelper.removeLoading(context);
    GoRouter.of(context).goNamed(AuthPage.route);
  }
}
