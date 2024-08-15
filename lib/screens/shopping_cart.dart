import 'package:bom_hamburguer/model/menu_item.dart';
import 'package:bom_hamburguer/providers/order_provider.dart';
import 'package:bom_hamburguer/screens/checkout.dart';
import 'package:bom_hamburguer/screens/home.dart';
import 'package:bom_hamburguer/utils/utils.dart';
import 'package:bom_hamburguer/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const totalTextStyle = TextStyle(fontSize: 23, color: Colors.green);
const oldTotalTextStyle = TextStyle(
    fontSize: 16, decoration: TextDecoration.lineThrough, color: Colors.grey);
const buttonsTextStyle = TextStyle(fontSize: 16, color: Colors.black);
const totalSavedTextStyle = TextStyle(fontSize: 16, color: Colors.grey);

const String confirmMessage = "Are you sure you want to remove this item?";

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = context.watch<OrderProvider>();
    final List<MenuItem> itemsOnCart = orderProvider.cartItems;
    bool hasDiscount = orderProvider.hasDiscount();
    double total = orderProvider.getTotal();
    double discount = orderProvider.getDiscount();
    double totalWithDiscount = orderProvider.getTotalWithDiscount();
    String totalFormatted = "\$ ${total.toStringAsFixed(2)}";
    String discountFormatted = "$discount%";
    String totalWithDiscountFormatted =
        "\$${totalWithDiscount.toStringAsFixed(2)}";
    double totalSaved = total * (discount / 100);
    String totalSavedFormatted = "\$ ${totalSaved.toStringAsFixed(2)}";
    String totalSavedWithDiscount =
        "Save: $totalSavedFormatted ($discountFormatted)";

    double screenWidth = MediaQuery.sizeOf(context).width;

    Future<void> removeItemFromCart(MenuItem item) async {
      bool? isConfirmed =
          await Utils.showConfirmDialog(context, confirmMessage);

      if (isConfirmed == true) orderProvider.removeItemFromCart(item);
    }

    return MainScaffold(
        title: "Your Order",
        body: Column(
          children: [
            itemsOnCart.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No order added yet, please add one from Menu"),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                        itemCount: itemsOnCart.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: screenWidth < 600
                                ? screenWidth
                                : screenWidth / 2,
                            childAspectRatio: 4),
                        itemBuilder: (context, index) {
                          MenuItem item = itemsOnCart.elementAt(index);
                          String itemName = itemsOnCart.elementAt(index).label;
                          double itemPrice = itemsOnCart.elementAt(index).price;
                          String itemImagePath =
                              itemsOnCart.elementAt(index).imagePath;
                          String priceFormatted =
                              "\$ ${itemPrice.toStringAsFixed(2)}";

                          return ListTile(
                            title: Text(itemName),
                            subtitle: Text(priceFormatted),
                            leading: Image.asset(itemImagePath),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => removeItemFromCart(item),
                            ),
                          );
                        }),
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (itemsOnCart.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: totalTextStyle,
                        ),
                        Wrap(
                          spacing: 4,
                          alignment: WrapAlignment.center,
                          direction: Axis.vertical,
                          runAlignment: WrapAlignment.center,
                          children: [
                            if (hasDiscount)
                              Text(totalWithDiscountFormatted,
                                  style: totalTextStyle),
                            Text(
                              totalFormatted,
                              style: hasDiscount
                                  ? oldTotalTextStyle
                                  : totalTextStyle,
                            ),
                            if (hasDiscount)
                              Text(
                                totalSavedWithDiscount,
                                style: totalSavedTextStyle,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.white)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen())),
                          child: Text(
                            itemsOnCart.isEmpty ? "Go to Menu" : "Order More",
                            style: buttonsTextStyle,
                          )),
                      if (itemsOnCart.isNotEmpty)
                        ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green)),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Checkout())),
                            child: const Text(
                              "Go to checkout",
                              style: buttonsTextStyle,
                            ))
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
