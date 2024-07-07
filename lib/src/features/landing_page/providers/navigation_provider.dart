import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = StateNotifierProvider.autoDispose<NavigationNotifier, int>((ref) => NavigationNotifier());

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int value) => state = value;
}
