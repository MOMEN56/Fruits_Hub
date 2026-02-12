import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';

import 'item.dart';

class ItemList {
  List<ItemEntity>? items;

  ItemList({this.items});

  factory ItemList.fromEntity({required List<CarItemEntity> items}) {
    return ItemList(items: items.map((e) => ItemEntity.fromEntity(e)).toList());
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((e) => e.toJson()).toList(),
  };
}
