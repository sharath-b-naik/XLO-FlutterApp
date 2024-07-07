import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api_services.dart';
import '../../../services/file_service/file_service.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dialog/dailog_helper.dart';
import '../../my_products_page/providers/provider.dart';
import 'state.dart';

final addProductProvider = StateNotifierProvider.autoDispose<AddProductNotifier, AddProductState>(
  (ref) => AddProductNotifier(),
);
const totalImagesToPost = 3;

class AddProductNotifier extends StateNotifier<AddProductState> {
  AddProductNotifier() : super(const AddProductState());

  final formKey = GlobalKey<FormState>();

  void setState(AddProductState value) => state = value;

  void pickProductImages() async {
    final paths = await FileServiceX.pickMultiImages();
    if (paths == null || paths.isEmpty) return;
    final imagePaths = {...state.selectedImages, ...paths}.toSet().toList();
    if (imagePaths.length > totalImagesToPost) return Toast.info("You can select upto $totalImagesToPost images");
    final displayImage = imagePaths.isNotEmpty ? imagePaths.first : null;
    final updated = state.copyWith(selectedImages: imagePaths, displayingImage: displayImage);
    setState(updated);
  }

  void removeProductImage(String image) async {
    final updated = state.selectedImages.where((element) => element != image).toList();
    final displayImage = image == state.displayingImage
        ? updated.isNotEmpty
            ? updated.first
            : null
        : state.displayingImage;

    setState(state.copyWith(selectedImages: updated, displayingImage: displayImage));
  }

  void addProduct(BuildContext context, WidgetRef ref) async {
    final validated = formKey.currentState?.validate() ?? false;
    if (!validated) return;
    if (state.selectedImages.isEmpty) return Toast.info("Please select atleast 1 image");
    DialogHelper.showloading(context);
    final product = await ApiServices.createProduct(state.product);
    if (product != null) {
      final images = await ApiServices.uploadProductImages(product.id!, state.selectedImages);
      final provider = ref.read(myProductsProvider.notifier);
      final homeState = ref.read(myProductsProvider);
      final updated = homeState.copyWith(products: [...(homeState.products ?? []), product.copyWith(images: images)]);
      provider.setState(updated);
    }
    DialogHelper.removeLoading(context);
    if (product != null) GoRouter.of(context).pop(); // Go back.
  }
}
