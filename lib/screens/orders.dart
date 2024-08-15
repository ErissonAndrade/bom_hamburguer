import 'package:bom_hamburguer/model/dtos/menu_item_dto.dart';
import 'package:bom_hamburguer/providers/order_provider.dart';
import 'package:bom_hamburguer/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bom_hamburguer/model/order.dart';
import 'package:provider/provider.dart';

const tileTileTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const totalPriceTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order> orders = [];
  late OrderProvider orderProvider;

  Future<void> _loadOrders() async {
    final loadedOrders = await orderProvider.loadOrders();

    setState(() {
      orders = loadedOrders;
    });
  }

  @override
  void initState() {
    orderProvider = context.read<OrderProvider>();

    _loadOrders();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "Orders",
      body: orders.isEmpty
          ? const Center(
              child: Text("You haven't purchased anything yet."),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;
                int crossAxisCount = maxWidth > 600 ? 2 : 1;
                double tileWidth = maxWidth / crossAxisCount - 16;

                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: orders.map((order) {
                      Iterable<MenuItemDTO> purchasedItems =
                          order.purchasedItems;
                      String totalFormatted =
                          "Total: \$ ${order.total.toStringAsFixed(2)}";

                      return SizedBox(
                        width: tileWidth,
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            title: Center(
                              child: Text(
                                "Order ${orders.indexOf(order) + 1}",
                                style: tileTileTextStyle,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...purchasedItems.map((item) {
                                  return ListTile(
                                    title: Text(item.label),
                                    subtitle: Text(
                                        "\$${item.price.toStringAsFixed(2)}"),
                                    leading: Image.asset(item.imagePath),
                                  );
                                }),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  totalFormatted,
                                  style: totalPriceTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
