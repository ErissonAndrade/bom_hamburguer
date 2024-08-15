import 'package:bom_hamburguer/model/menu_item_enums/extra.dart';
import 'package:bom_hamburguer/model/menu_item_enums/hamburguer.dart';
import 'package:bom_hamburguer/model/menu_item.dart';
import 'package:bom_hamburguer/providers/order_provider.dart';
import 'package:bom_hamburguer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final String friesLabel = Extra.fries.label;
final String softDrinkLabel = Extra.softDrink.label;

const hamburguerSelectionErrorMessage =
    "You can only select one hamburguer per order.";
final friesSelectionErrorMessage = "You can only select one $friesLabel.";
final softDrinkSelectionErrorMessage =
    "You can only select one $softDrinkLabel.";

const hamburguerCartErrorMessage =
    "You already have a hamburguer in your cart. You can only add one hamburger per order.";
final friesCartErrorMessage =
    "You already have a $friesLabel in your cart. You can only add one $friesLabel per order.";
final softDinkCartErrorMessage =
    "You already have a $softDrinkLabel in your cart. You can only add one $softDrinkLabel per order.";

class Validators {
  static bool isSelectionValid(BuildContext context, MenuItem item) {
    Utils.checkAndCloseSnackbar(context);

    OrderProvider orderProvider = context.read<OrderProvider>();
    List<MenuItem> selectedItems = orderProvider.selectedItems;

    if (item is Hamburguer) {
      bool isHamburguerAdded = selectedItems.any((item) => item is Hamburguer);

      if (isHamburguerAdded) {
        Utils.showSnackBar(context, hamburguerSelectionErrorMessage);
        return false;
      }
    }

    if (item == Extra.fries) {
      bool isFriesAdded = selectedItems.contains(Extra.fries);

      if (isFriesAdded) {
        Utils.showSnackBar(context, friesSelectionErrorMessage);
        return false;
      }
    }

    if (item == Extra.softDrink) {
      bool isSoftDrinkAdded = selectedItems.contains(Extra.softDrink);

      if (isSoftDrinkAdded) {
        Utils.showSnackBar(context, softDrinkSelectionErrorMessage);
        return false;
      }
    }

    return true;
  }

  static bool isCartValid(BuildContext context, MenuItem item) {
    Utils.checkAndCloseSnackbar(context);

    OrderProvider orderProvider = context.read<OrderProvider>();

    List<MenuItem> itemsOnCart = orderProvider.cartItems;

    if (item is Hamburguer) {
      bool isHamburguerAdded = itemsOnCart.any((item) => item is Hamburguer);

      if (isHamburguerAdded) {
        Utils.showSnackBar(context, hamburguerCartErrorMessage);
        return false;
      }
    }

    if (item == Extra.fries) {
      bool isFriesAdded = itemsOnCart.contains(Extra.fries);

      if (isFriesAdded) {
        Utils.showSnackBar(context, friesCartErrorMessage);
        return false;
      }
    }

    if (item == Extra.softDrink) {
      bool isSoftDrinkAdded = itemsOnCart.contains(Extra.softDrink);

      if (isSoftDrinkAdded) {
        Utils.showSnackBar(context, softDinkCartErrorMessage);
        return false;
      }
    }

    return true;
  }
}
