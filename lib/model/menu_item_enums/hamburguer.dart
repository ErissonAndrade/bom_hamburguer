import 'package:bom_hamburguer/model/menu_item.dart';

enum Hamburguer with MenuItem {
  xBurguer(
    label: "X-Burguer",
    price: 5.00,
    description: "Juicy beef patty, cheese, lettuce, tomato, toasted bun.",
    imagePath: "assets/images/x-burguer.png",
  ),

  xEgg(
    label: "X-Egg",
    price: 4.50,
    description: "Beef patty, fried egg, cheese, lettuce, tomato, bun.",
    imagePath: "assets/images/x-egg.png",
  ),
  xBacon(
    label: "X-Bacon",
    price: 7.00,
    description: "Beef patty, crispy bacon, cheese, lettuce, tomato, bun.",
    imagePath: "assets/images/x-bacon.png",
  );

  const Hamburguer({
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
