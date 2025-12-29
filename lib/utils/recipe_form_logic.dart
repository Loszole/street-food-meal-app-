import '../models/foods.dart';
import '../data/dummy_data.dart';
import 'food_factory.dart';

class RecipeFormLogic {
  String name = '';
  List<String> selectedCategories = [];
  String imageUrl = '';
  List<String> ingredients = [];
  List<String> steps = [];
  int duration = 0;
  int calories = 0;
  String complexity = 'simple';
  String affordability = 'affordable';
  bool isGlutenFree = false;
  bool isLactoseFree = false;
  bool isVegan = false;
  bool isVegetarian = false;

  String? categoryError;
  String? ingredientsError;
  String? stepsError;

  RecipeFormLogic({Food? foodToEdit}) {
    if (foodToEdit != null) {
      name = foodToEdit.title;
      selectedCategories = List<String>.from(foodToEdit.categories);
      imageUrl = foodToEdit.imageUrl;
      ingredients = List<String>.from(foodToEdit.ingredients);
      steps = List<String>.from(foodToEdit.steps);
      duration = foodToEdit.duration;
      calories = foodToEdit.calories;
      complexity = foodToEdit.complexity.name;
      affordability = foodToEdit.affordability.name;
      isGlutenFree = foodToEdit.isGlutenFree;
      isLactoseFree = foodToEdit.isLactoseFree;
      isVegan = foodToEdit.isVegan;
      isVegetarian = foodToEdit.isVegetarian;
    }
  }

  void processIngredients(String text) {
    if (text.trim().isNotEmpty) {
      final lines = text.split('\n');
      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty && !ingredients.contains(trimmed)) {
          ingredients.add(trimmed);
        }
      }
    }
  }

  void processSteps(String text) {
    if (text.trim().isNotEmpty) {
      final lines = text.split('\n');
      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty && !steps.contains(trimmed)) {
          steps.add(trimmed);
        }
      }
    }
  }

  void validate() {
    categoryError = selectedCategories.isEmpty ? 'Select at least one category' : null;
    ingredientsError = ingredients.isEmpty ? 'Add at least one ingredient' : null;
    stepsError = steps.isEmpty ? 'Add at least one step' : null;
  }

  void save(Food? foodToEdit) {
    if (foodToEdit != null) {
      final index = appFoods.indexWhere((f) => f.id == foodToEdit.id);
      if (index != -1) {
        appFoods[index] = createFood(
          id: foodToEdit.id,
          categories: selectedCategories,
          title: name,
          imageUrl: imageUrl,
          ingredients: ingredients,
          steps: steps,
          duration: duration,
          calories: calories,
          complexity: complexity,
          affordability: affordability,
          isGlutenFree: isGlutenFree,
          isLactoseFree: isLactoseFree,
          isVegan: isVegan,
          isVegetarian: isVegetarian,
        );
      }
    } else {
      final newFood = createFood(
        id: DateTime.now().toString(),
        categories: selectedCategories,
        title: name,
        imageUrl: imageUrl,
        ingredients: ingredients,
        steps: steps,
        duration: duration,
        calories: calories,
        complexity: complexity,
        affordability: affordability,
        isGlutenFree: isGlutenFree,
        isLactoseFree: isLactoseFree,
        isVegan: isVegan,
        isVegetarian: isVegetarian,
      );
      appFoods.add(newFood);
    }
  }
}
