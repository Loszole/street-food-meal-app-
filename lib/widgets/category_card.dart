import 'package:flutter/material.dart';
import '../models/category.dart';
import '../screens/recipe.dart'; // Import the correct screen
import '../data/dummy_data.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
  final Category category;

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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              Image.network(
                category.imageUrl,
                fit: BoxFit.cover,
                height: 120,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'lib/assets/recipe_placeholder.png',
                    fit: BoxFit.cover,
                    height: 120,
                    width: double.infinity,
                  );
                },
              ),
              // Dark overlay
              Container(
                height: 120,
                width: double.infinity,
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
              ),
              // Centered title
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Center(
                  child: Text(
                    category.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.2,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}