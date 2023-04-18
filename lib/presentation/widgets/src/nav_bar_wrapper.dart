import 'package:flutter/material.dart';
import 'package:kyla_test/presentation/presentation.dart';
import 'package:kyla_test/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class NavBarWrapper extends StatefulWidget {
  const NavBarWrapper({super.key});

  @override
  State<NavBarWrapper> createState() => _NavBarWrapperState();
}

class _NavBarWrapperState extends State<NavBarWrapper> {
  int selectedPage = 0;

  Widget getPage() {
    switch (selectedPage) {
      case 0:
        return const Discover();
      case 3:
        return const CartPage();
      default:
        return const Discover();
    }
  }

  List<BottomNavigationBarItem> items(int sneakersAmount) => [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_work_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: sneakersAmount != 0,
            label: Text(sneakersAmount.toString()),
            child: const Icon(Icons.shopping_basket_outlined),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: '',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, provider, _) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: items(provider.sneakers.amount),
            currentIndex: selectedPage,
            onTap: (value) {
              selectedPage = value;
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
