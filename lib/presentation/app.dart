import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyla_test/presentation/presentation.dart';
import 'package:kyla_test/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.pink,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          fontFamily: GoogleFonts.averiaLibre().fontFamily,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.black26,
            elevation: 0,
          ),
        ),
        themeMode: ThemeMode.light,
        home: const NavBarWrapper(),
      ),
    );
  }
}
