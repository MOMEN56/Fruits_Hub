import 'package:bloc/bloc.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  CartEntity cartEntity = CartEntity([]);
  void addProduct(ProductEntity productEntity) {
    bool isProductExist = cartEntity.isExis(productEntity);
    var carItem = cartEntity.getCarItem(productEntity);
    if (isProductExist) {
      carItem.increasquantity();
    } else {
      cartEntity.addCartItem(carItem);
    }
    emit(CartItemAdded());
  }

  void deleteProduct(CarItemEntity cartItem) {
    cartEntity.removeCartItem(cartItem);
    emit(CartItemRemoved());
  }

  void decreaseProductQuantity(ProductEntity productEntity) {
    var cartItem = cartEntity.getCarItem(productEntity);
    if (cartItem.quantity > 1) {
      cartItem.decreasquantity(); // أو increase/decrease صح إملائيًا
      emit(CartItemReset()); // state جديد لو عايز
    } else {
      deleteProduct(cartItem); // حذف لو 1
    }
  }
}
