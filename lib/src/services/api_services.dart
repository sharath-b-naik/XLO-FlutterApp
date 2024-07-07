import '../core/api/api_helper.dart';
import '../features/authentication/models/user_model.dart';
import '../features/chat_lists_page/models/chat_room.dart';
import '../features/chat_page/models/message_model.dart';
import '../features/home_page/models/product_model.dart';
import '../utils/custom_toast.dart';
import '../utils/models/uploaded_file.dart';

class ApiServices {
  static Future<String?> login(String phone, String password) async {
    String path = "/auth/login";
    final response = await ApiHelper.post(path, body: {"phone": phone, "password": password});
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold((error) => null, (result) => result.data['token']);
  }

  static Future<String?> createAccount(String phone, String password) async {
    String path = "/auth/create-account";
    final response = await ApiHelper.post(path, body: {"phone": phone, "password": password});
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold((error) => error.message, (result) => null);
  }

  static Future<bool> changePassword(String old, String newP, String confimP) async {
    String path = "/auth/change-password";
    final response = await ApiHelper.post(
      path,
      body: {"old_password": old, "new_password": newP, "confirm_new_password": confimP},
    );
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold((error) => false, (result) => true);
  }

  static Future<UserModel?> getUserDetails() async {
    String path = "/users";
    final response = await ApiHelper.get(path);
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold((error) => null, (result) => UserModel.fromJson(result.data));
  }

  static Future<UserModel?> uploadPhoto(String photo) async {
    String path = "/users/photo/upload";
    final response = await ApiHelper.upload(path, [photo]);
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold((error) => null, (result) => UserModel.fromJson(result.data));
  }

  static Future<UserModel?> updateUserDetails(String? name, String? email) async {
    String path = "/users";
    final response = await ApiHelper.put(path, body: {"name": name, "email": email});
    return response.fold((error) => null, (result) => UserModel.fromJson(result.data));
  }

  static Future<List<ProductModel>> getProducts({
    bool mine = false,
    bool favourite = false,
    String? category,
  }) async {
    assert(mine == false || favourite == false); // Any of one should pass.
    String path = "/products";
    final response = await ApiHelper.get(
      path,
      queryParams: {
        "mine": mine,
        "favourite": favourite,
        if (category != null) "category": category,
      },
    );
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold<List<ProductModel>>(
      (error) => [],
      (result) => List.from(result.data ?? []).map((e) => ProductModel.fromJson(e)).toList(),
    );
  }

  static Future<ProductModel?> createProduct(ProductModel product) async {
    String path = "/products";
    final specifications = product.specifications.where((item) => item.type != null && item.value != null);
    final response = await ApiHelper.post(
      path,
      body: {
        "name": product.name,
        "description": product.description,
        "category": product.category,
        "price": product.price,
        "used": product.used,
        "specifications": specifications.map((item) => {"type": item.type, "value": item.value}).toList()
      },
    );
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold<ProductModel?>((error) => null, (result) => ProductModel.fromJson(result.data));
  }

  static Future<bool> deleteProduct(String productId) async {
    String path = "/products/$productId";
    final response = await ApiHelper.delete(path);
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold<bool>((error) => false, (result) => true);
  }

  static Future<bool> addFavouriteProduct(String productId) async {
    String path = "/products/$productId/favourites";
    final response = await ApiHelper.post(path);
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold<bool>((error) => false, (result) => true);
  }

  static Future<bool> deleteFavouriteProduct(String productId) async {
    String path = "/products/$productId/favourites";
    final response = await ApiHelper.delete(path);
    if (response.isLeft()) response.fold((error) => Toast.failure(error.message), (result) => null);
    return response.fold<bool>((error) => false, (result) => true);
  }

  static Future<List<UploadedFile>> uploadProductImages(String productId, List<String> images) async {
    String path = "/products/$productId/upload/files";
    final response = await ApiHelper.upload(path, images);
    return response.fold<List<UploadedFile>>(
      (error) => [],
      (result) => List.from(result.data ?? []).map((item) => UploadedFile.fromJson(item)).toList(),
    );
  }

  static Future<ChatRoom?> createChatRoom(String receiverId) async {
    String path = "/chat-rooms";
    final response = await ApiHelper.post(path, queryParams: {"receiver_id": receiverId});
    return response.fold<ChatRoom?>((error) => null, (result) => ChatRoom.fromJson(result.data));
  }

  static Future<List<ChatRoom>> getChatRooms([String? receiverId]) async {
    String path = "/chat-rooms";
    final qparams = receiverId == null ? null : {"receiver_id": receiverId};
    final response = await ApiHelper.get(path, queryParams: qparams);

    return response.fold<List<ChatRoom>>(
      (error) => [],
      (result) => List.from(result.data ?? []).map((item) => ChatRoom.fromJson(item)).toList(),
    );
  }

  static Future<List<ChatMessage>> getChatRoomMessages(String roomId) async {
    String path = "/chat-rooms/$roomId/messages";
    final response = await ApiHelper.get(path);
    return response.fold<List<ChatMessage>>(
      (error) => [],
      (result) => List.from(result.data ?? []).map((item) => ChatMessage.fromJson(item)).toList(),
    );
  }

  static Future<ChatMessage?> sendMessage(String roomId, String message) async {
    String path = "/chat-rooms/$roomId/messages";
    final response = await ApiHelper.post(path, body: {"message": message});
    return response.fold<ChatMessage?>((error) => null, (result) => ChatMessage.fromJson(result.data));
  }
}
