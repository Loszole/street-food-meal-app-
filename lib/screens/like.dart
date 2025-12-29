import 'package:flutter/material.dart';

import '../widgets/recipr_card.dart';
import '../models/foods.dart';
import '../db/database_provider.dart';
// import '../db/food_entity.dart';
// import '../db/liked_recipe_entity.dart';
import '../utils/food_factory.dart';
import '../data/dummy_data.dart'; // Import where appFoods is defined

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  Future<List<Food>> _fetchAllLikedFoods() async {
    final db = await DatabaseProvider.database;
    final likedEntities = await db.likedRecipeDao.getAllLiked();
    final allFoods = await db.foodDao.findAllFoods();
    final likedIds = likedEntities.map((e) => e.recipeId).toSet();
    // Foods from Floor DB
    final likedFoodsDb = allFoods
        .where((e) => likedIds.contains(e.id))
        .map((e) => createFood(
              id: e.id,
              categories: e.categories.split(','),
              title: e.title,
              imageUrl: e.imageUrl,
              ingredients: e.ingredients.split(','),
              steps: e.steps.split(','),
              duration: e.duration,
              calories: e.calories,
              complexity: e.complexity,
              affordability: e.affordability,
              isGlutenFree: e.isGlutenFree,
              isLactoseFree: e.isLactoseFree,
              isVegan: e.isVegan,
              isVegetarian: e.isVegetarian,
            ))
        .toList();
    // Foods from dummy_data.dart (appFoods) that are liked but not in DB
    final dbIds = allFoods.map((e) => e.id).toSet();
    final likedFoodsDummy = appFoods
        .where((f) => likedIds.contains(f.id) && !dbIds.contains(f.id))
        .toList();
    // Merge both lists
    return [...likedFoodsDb, ...likedFoodsDummy];
  }

  // Refresh the liked meals when returning to this page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Recipes'),
      ),
      body: FutureBuilder<List<Food>>(
        future: _fetchAllLikedFoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final likedFoods = snapshot.data ?? [];
          if (likedFoods.isEmpty) {
            return const Center(child: Text('No liked recipes yet.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.90,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: likedFoods.length,
            itemBuilder: (context, index) {
              return RecipeCard(food: likedFoods[index]);
            },
          );
        },
      ),
    );
  }
}