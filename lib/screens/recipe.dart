import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/foods.dart';
import '../widgets/recipr_card.dart';

class RecipeScreen extends StatelessWidget {
  final List<Category> selectedCategories;
  final List<Food> foods;

  const RecipeScreen({
    super.key,
    required this.selectedCategories,
    required this.foods,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show selected categories as chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: selectedCategories
                  .map((cat) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(
                          label: Text(cat.title),
                          avatar: CircleAvatar(
                            backgroundImage: NetworkImage(cat.imageUrl),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Grid of foods
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.90,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return RecipeCard(food: foods[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
