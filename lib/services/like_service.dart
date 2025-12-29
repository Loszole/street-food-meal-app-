abstract class LikeService {
  Stream<int> likeCountStream(String recipeId);
  Future<void> likeRecipe(String recipeId);
  Future<void> unlikeRecipe(String recipeId);
  Future<bool> isLiked(String recipeId);
}
