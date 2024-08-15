import 'package:bom_hamburguer/model/menu_item_enums/extra.dart';
import 'package:bom_hamburguer/model/menu_item_enums/hamburguer.dart';
import 'package:bom_hamburguer/model/menu_item.dart';
import 'package:bom_hamburguer/providers/order_provider.dart';
import 'package:bom_hamburguer/screens/shopping_cart.dart';
import 'package:bom_hamburguer/utils/utils.dart';
import 'package:bom_hamburguer/validators/validators.dart';
import 'package:bom_hamburguer/widgets/items_list.dart';
import 'package:bom_hamburguer/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const buttonStyle =
    ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white));

const buttonTextStyle = TextStyle(color: Colors.black, fontSize: 16);

const selectionIsEmptyMessage =
    "You need to select at least one item to add to the cart.";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = context.read<OrderProvider>();

    Iterable<MenuItem> selectedItems = orderProvider.selectedItems;

    void addItemtoCart(Iterable<MenuItem> selectedItems) {
      bool isSelectionEmpty = selectedItems.isEmpty;

      if (isSelectionEmpty) {
        Utils.showSnackBar(context, selectionIsEmptyMessage);
        return;
      }

      for (MenuItem item in selectedItems) {
        bool isCartValid = Validators.isCartValid(context, item);

        if (!isCartValid) return;
      }

      orderProvider.addItemToCart(selectedItems);

      orderProvider.cleanSelectedItems();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ShoppingCart()));
    }

    Iterable<Hamburguer> hamburguersList = Hamburguer.values;
    Iterable<Extra> extrasList = Extra.values;

    String hamburguersTitle = "Hamburguers";
    String extrasTitle = "Extras";
    double spaceBetweenLists = 8;

    double screenWidth = MediaQuery.sizeOf(context).width;

    return MainScaffold(
        title: "Menu",
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: screenWidth < 600
                      ? Column(
                          children: [
                            ItemsList(
                                itemsList: hamburguersList,
                                listTitle: hamburguersTitle),
                            SizedBox(height: spaceBetweenLists),
                            ItemsList(
                                itemsList: extrasList, listTitle: extrasTitle),
                          ],
                        )
                      :
                      // Landscape mode
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ItemsList(
                                itemsList: hamburguersList,
                                listTitle: hamburguersTitle,
                              ),
                            ),
                            SizedBox(width: spaceBetweenLists),
                            Expanded(
                              child: ItemsList(
                                itemsList: extrasList,
                                listTitle: extrasTitle,
                              ),
                            ),
                          ],
                        )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    addItemtoCart(selectedItems);
                  },
                  child: const Text(
                    "Add to Cart",
                    style: buttonTextStyle,
                  )),
            )
          ],
        ));
  }
}
