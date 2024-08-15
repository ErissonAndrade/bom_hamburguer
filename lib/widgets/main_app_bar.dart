import 'package:bom_hamburguer/providers/order_provider.dart';
import 'package:bom_hamburguer/screens/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const MainAppBar({super.key, required this.title});

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    final List itemsOnCart = context.watch<OrderProvider>().cartItems;

    return AppBar(
      centerTitle: true,
      title: Text(
        widget.title,
      ),
      actions: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShoppingCart())),
                icon: const Icon(Icons.shopping_cart)),
            Text(itemsOnCart.length.toString())
          ],
        )
      ],
    );
  }
}
