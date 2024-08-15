import 'package:bom_hamburguer/model/dtos/menu_item_dto.dart';

mixin MenuItem {
  String get label;
  double get price;
  String get description;
  String get imagePath;

  MenuItemDTO toDTO() {
    return MenuItemDTO(label: label, price: price, imagePath: imagePath);
  }
}
