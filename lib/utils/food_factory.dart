import '../models/foods.dart';

Food createFood({
  required String id,
  required List<String> categories,
  required String title,
  required String imageUrl,
  required List<String> ingredients,
  required List<String> steps,
  required int duration,
  required int calories,
  required String complexity,
  required String affordability,
  required bool isGlutenFree,
  required bool isLactoseFree,
  required bool isVegan,
  required bool isVegetarian,
}) {
  return Food(
    id: id,
    categories: categories,
    title: title,
    imageUrl: imageUrl,
    ingredients: ingredients,
    steps: steps,
    duration: duration,
    calories: calories,
    complexity: Complexity.values.firstWhere((c) => c.name == complexity),
    affordability: Affordability.values.firstWhere((a) => a.name == affordability),
    isGlutenFree: isGlutenFree,
    isLactoseFree: isLactoseFree,
    isVegan: isVegan,
    isVegetarian: isVegetarian,
  );
}
