import 'package:flutter/material.dart';

import '../widgets/recipr_card.dart';
import '../widgets/category_card.dart';
import '../screens/recipe.dart';

import '../db/database_provider.dart';
import '../db/food_entity.dart';
// import '../db/food_dao.dart';
import '../models/foods.dart';
import '../utils/food_factory.dart';
import '../data/dummy_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Food>> _allFoodsFuture;
  late Future<List<Food>> _userFoodsFuture;

  @override
  void initState() {
    super.initState();
    _allFoodsFuture = _fetchAllFoods();
    _userFoodsFuture = _fetchUserFoods();
  }

  Future<List<Food>> _fetchAllFoods() async {
    final db = await DatabaseProvider.database;
    final List<FoodEntity> entities = await db.foodDao.findAllFoods();
    return entities
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
        .toList().reversed.toList();
  }

  Future<List<Food>> _fetchUserFoods() async {
    final allFoods = await _fetchAllFoods();
    return allFoods.where((f) => f.id.length > 10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Food>>(
        future: _allFoodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final allFoods = snapshot.data ?? [];
          return ListView(
            padding: EdgeInsets.zero,
            children: [
          // Featured Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Illustration
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    child: Image.asset(
                      'lib/assets/home_cook.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "INSPIRATION",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "40+ tasty sides to build your perfect plate.",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Loszole",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                            const Spacer(),
                            Icon(Icons.favorite_border, size: 18, color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(width: 4),
                            Text(
                              "96752",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Our Latest Recipes",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    // Show all recipes, latest first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeScreen(
                          selectedCategories: const [],
                          foods: List.of(appFoods.reversed), 
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "See All",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),                  
                ),
              ],
            ),
          ),
          SizedBox(
                    height: 220,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: appFoods.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 200,
                          child: RecipeCard(food: appFoods[index]),
                        );
                      },
                    ),
                  ),

          // User-added recipes section (async)
          FutureBuilder<List<Food>>(
            future: _userFoodsFuture,
            builder: (context, userSnapshot) {
              final userFoods = userSnapshot.data ?? [];
              if (userFoods.isEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Recipes",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeScreen(
                                  selectedCategories: const [],
                                  foods: List.of(userFoods.reversed),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "See All",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: userFoods.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 200,
                          child: RecipeCard(food: userFoods[index]),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),

            
          // Horizontal Recipe Cards
          
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: dummyCategories.map((category) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: CategoryCard(category: category),
            )).toList(),
          ),
        ],
      );
        },
      ),
    );
  }
}