import 'package:bom_hamburguer/model/dtos/menu_item_dto.dart';

class Order {
  String id;
  Iterable<MenuItemDTO> purchasedItems;
  double total;

  Order({
    required this.id,
    required this.purchasedItems,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['purchasedItems'] as List<dynamic>;

    Iterable<MenuItemDTO> purchasedItems = itemsJson
        .map((itemJson) =>
            MenuItemDTO.fromJson(itemJson as Map<String, dynamic>))
        .toList();

    return Order(
        id: json['id'], purchasedItems: purchasedItems, total: json['total']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'purchasedItems': purchasedItems, 'total': total};
  }
}
