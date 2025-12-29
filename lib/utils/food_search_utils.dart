import '../models/foods.dart';
import '../models/category.dart';
import '../data/dummy_data.dart';



/// Generic multi-keyword (AND) search for any list of items.
/// Returns items where all keywords are present in the searchable text (case-insensitive).
List<T> filterByKeywords<T>(List<T> items, String query, String Function(T) getText) {
  final q = query.toLowerCase().trim();
  final keywords = q.isEmpty
      ? []
      : q.split(RegExp(r'[ ,]+')).where((kw) => kw.isNotEmpty).toList();
  if (keywords.isEmpty) return items;
  return items.where((item) {
    final text = getText(item).toLowerCase();
    return keywords.every((kw) => text.contains(kw));
  }).toList();
}


/// Returns a string containing the title, category titles, and ingredients for a Food item.
/// Used for general search (title, category, ingredient, etc).
String foodSearchText(Food food) {
  final foodCategories = food.categories.map((catId) {
    final cat = dummyCategories.firstWhere(
      (c) => c.id == catId,
      orElse: () => const Category(id: '', title: '', imageUrl: ''),
    );
    return cat.title;
  }).join(' ');
  final ingredients = food.ingredients.join(' ');
  return '${food.title} $foodCategories $ingredients';
}

/// Filters a list of foods to only those that contain ALL of the given ingredient keywords (case-insensitive).
/// The query can be a space- or comma-separated list of ingredients.
List<Food> filterFoodsByIngredients(List<Food> foods, String query) {
  if (query.trim().isEmpty) return foods;
  // Split by comma or space, remove empty, lowercase
  final keywords = query
      .toLowerCase()
      .split(RegExp(r'[ ,]+'))
      .where((kw) => kw.isNotEmpty)
      .toList();
  return foods.where((food) {
    final foodIngredients = food.ingredients.map((i) => i.toLowerCase()).join(' ');
    // All keywords must be present in the ingredients string
    return keywords.every((kw) => foodIngredients.contains(kw));
  }).toList();
}

enum FoodFilter { vegetarian, vegan, lactoseFree, glutenFree }

List<Food> applyFoodFilters(List<Food> foods, Set<FoodFilter> filters) {
  return foods.where((food) {
    if (filters.contains(FoodFilter.vegetarian) && !food.isVegetarian) return false;
    if (filters.contains(FoodFilter.vegan) && !food.isVegan) return false;
    if (filters.contains(FoodFilter.lactoseFree) && !food.isLactoseFree) return false;
    if (filters.contains(FoodFilter.glutenFree) && !food.isGlutenFree) return false;
    return true;
  }).toList();
}
