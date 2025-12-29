
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../data/dummy_data.dart';
import '../screens/recipe.dart';

class CategoryChip extends StatelessWidget {
	final Category category;
	final VoidCallback? onTap;

	const CategoryChip({super.key, required this.category, this.onTap});


	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () {
        // Filter foods by this category
        final filteredFoods = appFoods
            .where((food) => food.categories.contains(category.id))
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(
              selectedCategories: [category],
              foods: filteredFoods,
            ),
          ),
        );
      },
			child: Chip(
				label: Text(
					category.title,
					style: Theme.of(context).textTheme.labelLarge?.copyWith(
						color: Theme.of(context).colorScheme.onSurface,
						fontWeight: FontWeight.bold,
						fontSize: 16,
						letterSpacing: 1.1,
					),
				),
				backgroundColor: Theme.of(context).chipTheme.backgroundColor ?? Theme.of(context).cardColor,
				avatar: CircleAvatar(
					backgroundImage: NetworkImage(category.imageUrl),
				),
				padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
			),
		);
	}
}
