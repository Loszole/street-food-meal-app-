import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.menu,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        // Add your menu opening logic here
      },
    );
  }
}
