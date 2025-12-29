import 'package:floor/floor.dart';

@Entity(tableName: 'foods')
class FoodEntity {
  @primaryKey
  final String id;
  final String title;
  final String imageUrl;
  final String categories; // Comma-separated
  final String ingredients; // Comma-separated
  final String steps; // Comma-separated
  final int duration;
  final int calories;
  final String complexity;
  final String affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;

  FoodEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.categories,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.calories,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
  });
}
