import 'package:flutter/material.dart';
import '../services/like_service.dart';
import '../services/floor_like_service.dart';

// LikeButton: Only the like icon, no count
class LikeButton extends StatefulWidget {
  final String recipeId;
  const LikeButton({super.key, required this.recipeId});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    likeService.isLiked(widget.recipeId).then((val) {
      setState(() {
        _isLiked = val;
      });
    });
  }

  void _toggleLike() async {
    if (_isLiked) {
      await likeService.unlikeRecipe(widget.recipeId);
    } else {
      await likeService.likeRecipe(widget.recipeId);
    }
    final val = await likeService.isLiked(widget.recipeId);
    setState(() {
      _isLiked = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked ? Colors.red : null),
      onPressed: _toggleLike,
    );
  }
}


final LikeService likeService = FloorLikeService();

class LikeButtonWithCount extends StatefulWidget {
  final String recipeId;
  const LikeButtonWithCount({super.key, required this.recipeId});

  @override
  State<LikeButtonWithCount> createState() => _LikeButtonWithCountState();
}

class _LikeButtonWithCountState extends State<LikeButtonWithCount> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    likeService.isLiked(widget.recipeId).then((val) {
      setState(() {
        _isLiked = val;
      });
    });
  }

  void _toggleLike() async {
    if (_isLiked) {
      await likeService.unlikeRecipe(widget.recipeId);
    } else {
      await likeService.likeRecipe(widget.recipeId);
    }
    final val = await likeService.isLiked(widget.recipeId);
    setState(() {
      _isLiked = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: likeService.likeCountStream(widget.recipeId),
      initialData: 0,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : null),
              onPressed: _toggleLike,
            ),
            Text('$count likes'),
          ],
        );
      },
    );
  }
}
