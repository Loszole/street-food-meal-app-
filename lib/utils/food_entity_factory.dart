import '../db/food_entity.dart';
import '../models/foods.dart';

FoodEntity foodToEntity(Food food) {
  return FoodEntity(
    id: food.id,
    title: food.title,
    imageUrl: food.imageUrl,
    categories: food.categories.join(','),
    ingredients: food.ingredients.join(','),
    steps: food.steps.join(','),
    duration: food.duration,
    calories: food.calories,
    complexity: food.complexity.name,
    affordability: food.affordability.name,
    isGlutenFree: food.isGlutenFree,
    isLactoseFree: food.isLactoseFree,
    isVegan: food.isVegan,
    isVegetarian: food.isVegetarian,
  );
}
