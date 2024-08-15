import 'package:bom_hamburguer/model/menu_item.dart';
import 'package:bom_hamburguer/providers/order_provider.dart';
import 'package:bom_hamburguer/screens/home.dart';
import 'package:bom_hamburguer/screens/shopping_cart.dart';
import 'package:bom_hamburguer/utils/utils.dart';
import 'package:bom_hamburguer/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const submitButtonStyle =
    ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green));
const submitButtonTextStyle = TextStyle(color: Colors.white, fontSize: 18);
const goBackToCartButtonStyle =
    ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white));
const goBackToCartTextStyle = TextStyle(color: Colors.black, fontSize: 18);

const confirmDialogMessageStyle = TextStyle(fontSize: 18);
const confirmDialogBtnTextStyle = TextStyle(fontSize: 16, color: Colors.white);

const String cartIsEmptyMessage = "Your cart is empty, please check it.";

const String orderConfirmedMessage =
    "Your order has been successfully placed! Thank you for choosing us.";

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late AnimationController progressIndicatorController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    progressIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    progressIndicatorController.dispose();
    super.dispose();
  }

  String? validators(String? value) {
    if (value == null || value.isEmpty) return "Value must not be empty";

    return null;
  }

  void _confirmingOrderDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop:
                false, // Prevents the user from using the back button to avoid undesired behavior
            child: AlertDialog(
              title: const Text("Confirming your order..."),
              content: AnimatedBuilder(
                animation: progressIndicatorController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    color: Colors.white,
                    value: progressIndicatorController.isCompleted
                        ? 1.0
                        : progressIndicatorController.value,
                  );
                },
              ),
            ),
          );
        });
  }

  _progressIndicatorListener() {
    progressIndicatorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          OrderProvider orderProvider = context.read<OrderProvider>();
          orderProvider.cleanCart();

          Navigator.of(context).pop();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return PopScope(
                canPop:
                    false, // Prevents the user from using the back button to avoid undesired behavior
                child: AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text("Order Confirmed"),
                    ],
                  ),
                  content: const Text(
                    orderConfirmedMessage,
                    style: confirmDialogMessageStyle,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => route.isFirst,
                        );
                      },
                      child: const Center(
                          child: Text(
                        "OK",
                        style: confirmDialogBtnTextStyle,
                      )),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    });
  }

  _confirmPayment() {
    if (!_formKey.currentState!.validate()) return;

    OrderProvider orderProvider = context.read<OrderProvider>();
    List<MenuItem> cartItems = orderProvider.cartItems;
    bool isCartEmpty = cartItems.isEmpty;

    if (isCartEmpty) {
      Utils.showSnackBar(context, cartIsEmptyMessage);
      return;
    }

    progressIndicatorController.forward(from: 0.0);

    _confirmingOrderDialog();

    _progressIndicatorListener();

    orderProvider.addOrder();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        title: "Checkout",
        body: Center(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("Please enter your name to continue")),
                      controller: _nameController,
                      validator: validators,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            style: submitButtonStyle,
                            onPressed: () => _confirmPayment(),
                            child: const Text(
                              "Confirm order",
                              style: submitButtonTextStyle,
                            )),
                        const SizedBox(
                          height: 32,
                        ),
                        ElevatedButton(
                            style: goBackToCartButtonStyle,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ShoppingCart())),
                            child: const Text(
                              "Go back to cart",
                              style: goBackToCartTextStyle,
                            )),
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}
