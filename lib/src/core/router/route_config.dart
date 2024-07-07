import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_product_page/views/add_product_page.dart';
import '../../features/authentication/presentation/view/auth_page.dart';
import '../../features/change_password_page/views/change_password_page.dart';
import '../../features/chat_lists_page/models/chat_room.dart';
import '../../features/chat_page/views/chat_page.dart';
import '../../features/contact_page/views/contact_page.dart';
import '../../features/home_page/models/product_model.dart';
import '../../features/landing_page/views/landing_page.dart';
import '../../features/privacy_policy_page/views/privacy_policy_page.dart';
import '../../features/profile_edit_page/views/profile_edit_page.dart';
import '../../../splash_screen.dart';
import '../../features/support_page/views/support_page.dart';
import '../../features/view_all_products_page/views/view_all_products_page.dart';
import '../../features/view_product_page/views/view_product_page.dart';
import '../../utils/page_route.dart';
import 'route_not_found_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@immutable
class GoConfig {
  const GoConfig._();
  factory GoConfig() => _instance;
  static const GoConfig _instance = GoConfig._();

  static final GoRouter routerConfig = GoRouter(
    initialLocation: SplashScreen.route,
    navigatorKey: navigatorKey,
    errorBuilder: (context, state) => const RouteNotFoundPage(),
    routes: [
      GoRoute(
        name: SplashScreen.route,
        path: SplashScreen.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        name: AuthPage.route,
        path: AuthPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const AuthPage()),
      ),
      GoRoute(
        name: LandingPage.route,
        path: LandingPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const LandingPage()),
      ),
      GoRoute(
        name: ViewProductPage.route,
        path: ViewProductPage.route,
        pageBuilder: (context, state) => XloRoutePage(
          key: state.pageKey,
          child: ViewProductPage(product: state.extra as ProductModel),
        ),
      ),
      GoRoute(
        name: AddProductPage.route,
        path: AddProductPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const AddProductPage()),
      ),
      GoRoute(
        name: ProfileEditPage.route,
        path: ProfileEditPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const ProfileEditPage()),
      ),
      GoRoute(
        name: ChangePasswordPage.route,
        path: ChangePasswordPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const ChangePasswordPage()),
      ),
      GoRoute(
        name: ContactPage.route,
        path: ContactPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const ContactPage()),
      ),
      GoRoute(
        name: SupportPage.route,
        path: SupportPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const SupportPage()),
      ),
      GoRoute(
        name: PrivacyPolicyPage.route,
        path: PrivacyPolicyPage.route,
        pageBuilder: (context, state) => XloRoutePage(key: state.pageKey, child: const PrivacyPolicyPage()),
      ),
      GoRoute(
        name: ViewAllProductsPage.route,
        path: ViewAllProductsPage.route,
        pageBuilder: (context, state) => XloRoutePage(
          key: state.pageKey,
          child: ViewAllProductsPage(category: state.extra as String),
        ),
      ),
      GoRoute(
        name: ChatPage.route,
        path: ChatPage.route,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return XloRoutePage(
            key: state.pageKey,
            child: ChatPage(
              room: extra['room_id'] as ChatRoom?,
              receiverId: extra['receiver_id'] as String,
            ),
          );
        },
      ),
    ],
  );
}
