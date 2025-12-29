import 'dart:async';
import 'like_service.dart';

class MockLikeService implements LikeService {
  final Map<String, int> _likeCounts = {};
  final Map<String, bool> _liked = {};
  final Map<String, StreamController<int>> _controllers = {};

  @override
  Stream<int> likeCountStream(String recipeId) {
    _controllers.putIfAbsent(recipeId, () => StreamController<int>.broadcast());
    _likeCounts.putIfAbsent(recipeId, () => 0);
    // Emit initial value
    Future.microtask(() => _controllers[recipeId]!.add(_likeCounts[recipeId]!));
    return _controllers[recipeId]!.stream;
  }

  @override
  Future<void> likeRecipe(String recipeId) async {
    _likeCounts[recipeId] = (_likeCounts[recipeId] ?? 0) + 1;
    _liked[recipeId] = true;
    _controllers[recipeId]?.add(_likeCounts[recipeId]!);
  }

  @override
  Future<void> unlikeRecipe(String recipeId) async {
    _likeCounts[recipeId] = (_likeCounts[recipeId] ?? 1) - 1;
    _liked[recipeId] = false;
    _controllers[recipeId]?.add(_likeCounts[recipeId]!);
  }

  @override
  Future<bool> isLiked(String recipeId) async {
    return _liked[recipeId] ?? false;
  }
}
