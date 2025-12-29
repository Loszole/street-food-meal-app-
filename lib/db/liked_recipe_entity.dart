import 'package:floor/floor.dart';

@Entity(tableName: 'liked_recipes')
class LikedRecipeEntity {
  @primaryKey
  final String recipeId;

  LikedRecipeEntity({required this.recipeId});
}
