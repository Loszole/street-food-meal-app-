import 'package:flutter/material.dart';
import 'dart:io';

import '../models/foods.dart';
import '../widgets/like_button_with_count.dart';
import '../screens/food_details.dart';


class RecipeCard extends StatefulWidget {
  const RecipeCard({super.key, required this.food});
  final Food food;


  @override
  State<RecipeCard> createState() => _RecipeCardState();
}
  // Helper to check if imageUrl is a local file path
  bool _isLocalImage(String imageUrl) {
    // Simple heuristic: local images are file paths, not URLs
    return !(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
  }

class _RecipeCardState extends State<RecipeCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(food: widget.food),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        margin: const EdgeInsets.all(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _isLocalImage(widget.food.imageUrl)
                        ? Image.file(
                            File(widget.food.imageUrl),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/assets/recipe_placeholder.png',
                                fit: BoxFit.cover,
                                height: 120,
                                width: double.infinity,
                              );
                            },
                          )
                        : Image.network(
                            widget.food.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/assets/recipe_placeholder.png',
                                fit: BoxFit.cover,
                                height: 120,
                                width: double.infinity,
                              );
                            },
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatDuration(widget.food.duration),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LikeButton(recipeId: widget.food.id),
                        StreamBuilder<int>(
                          stream: likeService.likeCountStream(widget.food.id),
                          initialData: 0,
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Padding(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: Text('$count', style: Theme.of(context).textTheme.bodyMedium),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  


                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.food.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // LikeButtonWithCount(recipeId: widget.food.id),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.food.calories} Calories',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hrs = minutes ~/ 60;
      final mins = minutes % 60;
      return mins == 0 ? '$hrs hr' : '$hrs hr $mins min';
    }
  }
}
