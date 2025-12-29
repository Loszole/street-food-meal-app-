import 'package:floor/floor.dart';
import 'liked_recipe_entity.dart';

@dao
abstract class LikedRecipeDao {
  @Query('SELECT * FROM liked_recipes')
  Future<List<LikedRecipeEntity>> getAllLiked();

  @Query('SELECT * FROM liked_recipes WHERE recipeId = :recipeId')
  Future<LikedRecipeEntity?> findByRecipeId(String recipeId);

  @insert
  Future<void> likeRecipe(LikedRecipeEntity entity);

  @delete
  Future<void> unlikeRecipe(LikedRecipeEntity entity);
}
