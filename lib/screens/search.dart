import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/foods.dart';
import '../models/category.dart';
import '../db/database_provider.dart';
import '../db/food_entity.dart';
import '../utils/food_factory.dart';


import '../widgets/category_chip.dart';
import '../widgets/recipr_card.dart';
import '../widgets/search_bar_widget.dart';
import '../utils/food_search_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Food> _allFoodsDb = [];
  List<Food> _allFoodsDummy = [];
  List<Food> _filteredDb = [];
  List<Food> _filteredDummy = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  Future<void> _fetchFoods() async {
    final db = await DatabaseProvider.database;
    final List<FoodEntity> entities = await db.foodDao.findAllFoods();
    final foodsDb = entities
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
    final dbIds = foodsDb.map((e) => e.id).toSet();
    final foodsDummy = appFoods.where((f) => !dbIds.contains(f.id)).toList();
    setState(() {
      _allFoodsDb = foodsDb;
      _allFoodsDummy = foodsDummy;
      _filteredDb = foodsDb;
      _filteredDummy = foodsDummy;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<Category> categories = dummyCategories;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'INSPIRATION',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 10),
                  // Search bar
                  SearchBarWidget<Food>(
                    items: [..._allFoodsDb, ..._allFoodsDummy],
                    filter: (items, query) => filterByKeywords(items, query, foodSearchText),
                    onResults: (results) {
                      final dbIds = _allFoodsDb.map((e) => e.id).toSet();
                      setState(() {
                        _filteredDb = results.where((f) => dbIds.contains(f.id)).toList();
                        _filteredDummy = results.where((f) => !dbIds.contains(f.id)).toList();
                      });
                    },
                    hintText: 'Search recipes, categories, ingredients...',
                  ),
                  const SizedBox(height: 16),
                  // Category chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return CategoryChip(
                          category: cat,
                          onTap: () {
                            // You can implement category filter logic here if needed
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Popular Categories
                  Text(
                    'Popular Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle(),
                  ),
                  const SizedBox(height: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_upward, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Eoant recipies', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Easy dinner', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Recent Searches', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Trending Now',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle(),
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      final mergedResults = [..._filteredDb, ..._filteredDummy];
                      if (mergedResults.isEmpty) {
                        return const Center(child: Text('No results found.'));
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mergedResults.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          final food = mergedResults[index];
                          return RecipeCard(food: food);
                        },
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}