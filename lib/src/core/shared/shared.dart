import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../env_options.dart';
import '../../features/authentication/models/user_model.dart';
import '../../services/api_services.dart';
import '../../utils/string_extension.dart';

/// ####################################################
/// Run python script [generate_env.py]
/// to generate the environment file(env_options.dart)
/// and EnvOptions class.
/// ####################################################

const appName = "XLO";
const appLogo = "assets/images/app_icon.png";

/// Useful when server running on [debug] mode or [localhost]
/// web: http://localhost:3000
/// Mobile emulator: http://10.0.2.2:3000 real device: http://192.168.43.134:3000
const apiUrl = EnvOptions.apiUrl;

// Theme constants
const double bRadius = 12.0;
const List<BoxShadow> boxShadow = [BoxShadow(color: Color(0x05000000), blurRadius: 5)];

String? _userId;
String? get userId => _userId;
set userId(String? value) => _userId = value;

String? _authToken;
String? get authToken => _authToken;
set authToken(String? value) => _authToken = value;

final loggedUserProivder = StateProvider<UserModel?>((ref) => null);

Future<bool> setAuthToken(String? token, WidgetRef ref) async {
  if (token == null) return false;
  _authToken = token;
  _userId = token.decodeJWTAndGetUserId();
  final user = await ApiServices.getUserDetails();
  ref.read(loggedUserProivder.notifier).state = user;
  return user != null;
}
