import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/generated/l10n.dart';

class BottomNavigationBarEntity {
  final String activeImage, inActiveImage;
  final String name;

  BottomNavigationBarEntity({
    required this.activeImage,
    required this.inActiveImage,
    required this.name,
  });
}

List<BottomNavigationBarEntity> get bottomNavigationBarItems => [
  BottomNavigationBarEntity(
    activeImage: Assets.assetsImagesHomeActive,
    inActiveImage: Assets.assetsImagesHome,
    name: S.current.home,
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.assetsImagesProductActive,
    inActiveImage: Assets.assetsImagesProducts,
    name: S.current.products,
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.assetsImagesShoppingCartActive,
    inActiveImage: Assets.assetsImagesShoppingCart,
    name: S.current.cart,
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.assetsImagesUserActive,
    inActiveImage: Assets.assetsImagesUser,
    name: S.current.myOrders,
  ),
];
