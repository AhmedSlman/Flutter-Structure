import 'package:shgrade/src/features/cart/domain/repo/cart_repo.dart';
import 'package:shgrade/core/di/injection_container.dart';

class CartMergeService {
  static Future<void> mergeGuestCartWithRemote() async {
    final cartRepo = sl<CartRepository>();
    final localDataSource = (cartRepo as dynamic).localDataSource;
    try {
      final localCart = await localDataSource.getCartLocal();
      final localProducts = localCart.products;

      if (localProducts.isEmpty) return;

      final remoteCartResult = await cartRepo.getCart();
      final remoteCart = remoteCartResult.fold((l) => null, (r) => r);

      if (remoteCart == null || remoteCart.data.products.isEmpty) {
        for (final product in localProducts) {
          await cartRepo.addItem(product);
        }
        await localDataSource.clearCartLocal();
      }
    } catch (e) {}
  }
}
