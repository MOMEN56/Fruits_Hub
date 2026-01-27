import 'package:fruit_hub/core/utils/assets.dart';

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
    name: 'الرئيسية',
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.assetsImagesProductActive,
    inActiveImage: Assets.assetsImagesProducts,
    name: 'المنتجات',
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.assetsImagesShoppingCartActive,
    inActiveImage: Assets.assetsImagesShoppingCart,
    name: 'سلة التسوق',
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.assetsImagesUserActive,
    inActiveImage: Assets.assetsImagesUser,
    name: 'حسابي',
  ),
];
