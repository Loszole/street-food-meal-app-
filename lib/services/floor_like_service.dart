import 'dart:async';
import '../db/database_provider.dart';
import '../db/liked_recipe_entity.dart';
import 'like_service.dart';

class FloorLikeService implements LikeService {
  @override
  Stream<int> likeCountStream(String recipeId) async* {
    final db = await DatabaseProvider.database;
    final count = (await db.likedRecipeDao.getAllLiked()).where((e) => e.recipeId == recipeId).length;
    yield count;
    // For demo: no real-time updates, just yield once
  }

  @override
  Future<void> likeRecipe(String recipeId) async {
    final db = await DatabaseProvider.database;
    await db.likedRecipeDao.likeRecipe(LikedRecipeEntity(recipeId: recipeId));
  }

  @override
  Future<void> unlikeRecipe(String recipeId) async {
    final db = await DatabaseProvider.database;
    await db.likedRecipeDao.unlikeRecipe(LikedRecipeEntity(recipeId: recipeId));
  }

  @override
  Future<bool> isLiked(String recipeId) async {
    final db = await DatabaseProvider.database;
    final liked = await db.likedRecipeDao.findByRecipeId(recipeId);
    return liked != null;
  }
}



