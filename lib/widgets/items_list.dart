import 'package:bom_hamburguer/model/menu_item.dart';
import 'package:bom_hamburguer/providers/order_provider.dart';
import 'package:bom_hamburguer/utils/utils.dart';
import 'package:bom_hamburguer/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const mainTitleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 23);
const tileTitleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
const priceStyle = TextStyle(fontSize: 16);
const quantityStyle = TextStyle(fontSize: 18);

class ItemsList extends StatefulWidget {
  const ItemsList(
      {super.key, required this.listTitle, required this.itemsList});

  final String listTitle;
  final Iterable<MenuItem> itemsList;

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  int itemQuantity = 0;

  void _addItem(MenuItem item) {
    bool isSelectionValid = Validators.isSelectionValid(context, item);

    if (!isSelectionValid) return;

    OrderProvider orderProvider = context.read<OrderProvider>();
    orderProvider.addItemToSelection(context, item);
  }

  void _removeItem(MenuItem item) {
    Utils.checkAndCloseSnackbar(context);
    OrderProvider orderProvider = context.read<OrderProvider>();

    orderProvider.removeItemFromSelection(item);
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = context.watch<OrderProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            widget.listTitle,
            style: mainTitleStyle,
          ),
        ),
        Column(
          children: widget.itemsList.map((item) {
            String itemName = item.label;
            String itemDescription = item.description;
            double itemPrice = item.price;
            String itemImagePath = item.imagePath;
            String priceFormatted = "\$ ${itemPrice.toStringAsFixed(2)}";

            itemQuantity = orderProvider.getQuantity(item);

            return ListTile(
              title: Text(
                itemName,
                style: tileTitleStyle,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(itemDescription),
                  Text(
                    priceFormatted,
                    style: priceStyle,
                  ),
                ],
              ),
              leading: ClipOval(
                child: Image.asset(
                  itemImagePath,
                  fit: BoxFit.fill,
                  width: 60,
                  height: 80,
                ),
              ),
              trailing: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                spacing: 12,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addItem(item),
                  ),
                  Text(
                    itemQuantity.toString(),
                    style: quantityStyle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _removeItem(item),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
