import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/cart.dart';
import '../screens/home.dart';
import '../screens/search.dart';
import 'widgets/user_menu.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  bool isSearchActive = false;

  List<Widget> screens = [
    const Home(),
    const Search(),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: isSearchActive
            ? FadeIn(
                delay: const Duration(milliseconds: 300),
                child: const Text(
                  "Buscar",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
            : FadeIn(
                delay: const Duration(milliseconds: 300),
                child: const Text(
                  "Inicio",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            print("=== Menu ===");
            //aqui se abre el menu!
            _key.currentState!.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive;
              });
            },
            icon: isSearchActive
                ? const Icon(
                    LineIcons.searchMinus,
                    color: Colors.black,
                    size: 30,
                  )
                : const Icon(
                    LineIcons.search,
                    color: Colors.black,
                    size: 30,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                LineIcons.shoppingBag,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Cart(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: isSearchActive ? const Search() : const Home(),
      drawer: const Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListViewUserMenu()),
      /*bottomNavigationBar: BottomBarBubble(
        color: Colors.white,
        selectedIndex: _index,
        items: [
          BottomBarItem(iconData: Icons.home),
          BottomBarItem(iconData: Icons.search),
          BottomBarItem(iconData: Icons.explore),
          BottomBarItem(iconData: Icons.settings),
          BottomBarItem(iconData: Icons.mail),
        ],
        onSelect: (index) {},
      ),*/
    );
  }
}
