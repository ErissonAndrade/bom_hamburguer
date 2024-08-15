import 'package:bom_hamburguer/screens/home.dart';
import 'package:bom_hamburguer/screens/orders.dart';
import 'package:bom_hamburguer/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';

const drawerHeaderTextStyle = TextStyle(fontSize: 23, color: Colors.black);

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const MainScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: title,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'Welcome Back!',
                  style: drawerHeaderTextStyle,
                ),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
                child: const Text("Menu"),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Orders())),
                child: const Text("Last Orders"),
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
