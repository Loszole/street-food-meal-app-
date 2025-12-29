import 'package:flutter/material.dart';

import 'package:recipe_app/widgets/bottom_nav_bar.dart';
import 'package:recipe_app/widgets/hamburger_menu.dart';

import 'package:recipe_app/screens/like.dart';
import 'package:recipe_app/screens/home.dart';
import 'package:recipe_app/screens/search.dart';
import 'package:recipe_app/screens/add.dart';
import 'package:recipe_app/screens/shoping_list.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    // Define the screens for each tab
    final List<Widget> screens = [
  const HomeScreen(),
  const SearchScreen(),
  const AddRecipeScreen(),
  const LikeScreen(),
  const ShoppingListScreen(),

      


    ];

    return 
    
     Scaffold(
       appBar: AppBar(
        leading: const HamburgerMenu(),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  
}