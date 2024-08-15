import 'package:bom_hamburguer/model/menu_item.dart';

enum Extra with MenuItem {
  fries(
    label: "Fries",
    price: 2.00,
    description: "Crispy potato sticks, golden, seasoned, perfect side dish.",
    imagePath: "assets/images/fries.png",
  ),
  softDrink(
    label: "Soft drink",
    price: 2.50,
    description: "Refreshing, fizzy, sweet, perfect beverage for any meal.",
    imagePath: "assets/images/soft-drink.png",
  );

  const Extra({
    required this.label,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  @override
  final String label;

  @override
  final double price;

  @override
  final String description;

  @override
  final String imagePath;
}
