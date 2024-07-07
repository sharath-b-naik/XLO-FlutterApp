import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

 
@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) isChatLoading,
  }) = _ChatState;
}
