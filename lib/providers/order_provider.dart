import 'dart:convert';

import 'package:bom_hamburguer/model/dtos/menu_item_dto.dart';
import 'package:bom_hamburguer/model/menu_item_enums/extra.dart';
import 'package:bom_hamburguer/model/menu_item_enums/hamburguer.dart';
import 'package:bom_hamburguer/model/menu_item.dart';
import 'package:bom_hamburguer/model/order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class OrderProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final List<MenuItem> _selectedItems = [];
  final List<MenuItem> _cartItems = [];
  final String _ordersKey = "ordersKey";

  List<MenuItem> get selectedItems => _selectedItems;
  List<MenuItem> get cartItems => _cartItems;

  int getQuantity(MenuItem item) {
    return _selectedItems.where((selectedItem) => selectedItem == item).length;
  }

  void addItemToSelection(BuildContext context, MenuItem item) {
    _selectedItems.add(item);

    notifyListeners();
  }

  void removeItemFromSelection(MenuItem item) {
    _selectedItems.remove(item);

    notifyListeners();
  }

  void cleanSelectedItems() {
    _selectedItems.clear();
  }

  void addItemToCart(Iterable<MenuItem> _selectedItems) {
    for (MenuItem item in _selectedItems) {
      _cartItems.add(item);
    }

    cleanSelectedItems();
    notifyListeners();
  }

  void removeItemFromCart(MenuItem item) {
    _cartItems.remove(item);

    notifyListeners();
  }

  void cleanCart() {
    _cartItems.clear();
  }

  double getTotal() {
    return _cartItems.fold(
        0, (previousValue, element) => previousValue + element.price);
  }

  bool hasDiscount() {
    bool containsHamburguer = _cartItems.any((item) => item is Hamburguer);
    bool containsExtra = _cartItems.any((item) => item is Extra);

    if (containsHamburguer && containsExtra) return true;

    return false;
  }

  double getDiscount() {
    double discount = 0;

    if (!hasDiscount()) return 0;

    bool containsSoftDrink = _cartItems.contains(Extra.softDrink);
    bool containsFries = _cartItems.contains(Extra.fries);

    if (containsSoftDrink) {
      discount = 15;
    }

    if (containsFries) {
      discount = 10;
    }

    if (containsSoftDrink && containsFries) {
      discount = 20;
    }

    return discount;
  }

  double getTotalWithDiscount() {
    double totalPrice = getTotal();

    double discount = getDiscount();

    double totalWithDiscount = totalPrice - (totalPrice * (discount / 100));

    return totalWithDiscount;
  }

  Future<void> addOrder() async {
    const uuid = Uuid();

    List<Order> savedOrders = [];

    List<MenuItemDTO> convertToDto =
        _cartItems.map((cartItem) => cartItem.toDTO()).toList();

    Order newOrder = Order(
        id: uuid.v1(),
        purchasedItems: convertToDto,
        total: getTotalWithDiscount());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? savedOrdersList = prefs.getStringList(_ordersKey);

    // If orders are saved, update first
    if (savedOrdersList != null) {
      savedOrders = await loadOrders();
    }

    savedOrders.add(newOrder);

    List<String> stringOrderList =
        savedOrders.map((order) => jsonEncode(order.toJson())).toList();

    prefs.setStringList(_ordersKey, stringOrderList);

    loadOrders();
  }

  Future<List<Order>> loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? jsonStringList = prefs.getStringList(_ordersKey);

    if (jsonStringList == null) return [];

    List<Order> ordersList = jsonStringList
        .map((jsonString) => Order.fromJson(jsonDecode(jsonString)))
        .toList();

    return ordersList;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('_selectedItems', _selectedItems));
    properties.add(IterableProperty('_cartItems', _cartItems));
  }
}
