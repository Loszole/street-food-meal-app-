import 'dart:io';
import 'package:flutter/material.dart';
import '../models/foods.dart';
import '../widgets/like_button_with_count.dart';
import '../utils/cook_mode_utils.dart';
import 'add.dart';

class FoodDetailsScreen extends StatefulWidget {
  final Food food;
  const FoodDetailsScreen({super.key, required this.food});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  bool cookingMode = false;
  // bool isLiked = false;
  int servingSize = 2;
  late List<bool> ingredientChecked;

  // Helper to check if imageUrl is a local file path
  bool _isLocalImage(String imageUrl) {
    // Simple heuristic: local images are file paths, not URLs
    return !(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
  }

  @override
  void initState() {
    super.initState();
    // No longer using RecipeCard.likedFoods; like state is handled by LikeButtonWithCount
    ingredientChecked = List<bool>.filled(
      widget.food.ingredients.length,
      false,
    );
  }

  @override
  void dispose() {
    // CRITICAL: Always disable wakelock when leaving the screen to save battery
    CookModeUtils.setCookMode(false);
    super.dispose();
  }

  void toggleCookingMode() {
    setState(() {
      cookingMode = !cookingMode;
      CookModeUtils.setCookMode(cookingMode); // Use the utility
    });
  }

  void updateServingSize(int newSize) {
    setState(() {
      servingSize = newSize;
      // We reset checks because quantities changed
      ingredientChecked = List<bool>.filled(
        widget.food.ingredients.length,
        false,
      );
    });
  }

  String scaleIngredient(String ingredient, int servings) {
    // Improved Regex to handle decimals and simple numbers
    final regex = RegExp(r'^(\d+(?:\.\d+)?)(.*)');
    final match = regex.firstMatch(ingredient.trim());

    if (match != null) {
      final numStr = match.group(1)!;
      final rest = match.group(2)!;
      double? base = double.tryParse(numStr);

      if (base != null) {
        double scaled = (base * servings) / 2;
        // Formatting: Remove .0 if it's a whole number
        String scaledStr = scaled % 1 == 0
            ? scaled.toInt().toString()
            : scaled.toStringAsFixed(1);
        return '$scaledStr$rest';
      }
    }
    return ingredient;
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Cache theme for cleaner code

    return Scaffold(
      appBar: AppBar(
        // The default back button will be shown automatically
        title: const Text("Recipe Details"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.star, color: theme.colorScheme.secondary, size: 20),
                const SizedBox(width: 4),
                Text(
                  "4.7",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Recipe',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                        MaterialPageRoute(
                          builder: (context) => AddRecipeScreen(
                            foodToEdit: widget.food,
                          ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        children: [
          // Title & Like Button
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.food.title,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              LikeButtonWithCount(recipeId: widget.food.id),
            ],
          ),

          // Meta info (Time & Complexity)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 18, color: theme.hintColor),
                const SizedBox(width: 4),
                Text("${widget.food.duration} min"),
                const SizedBox(width: 16),
                Icon(Icons.restaurant, size: 18, color: theme.hintColor),
                const SizedBox(width: 4),
                Text(widget.food.complexity.name.toUpperCase()),
              ],
            ),
          ),

          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _isLocalImage(widget.food.imageUrl)
                ? Image.file(
                    File(widget.food.imageUrl),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'lib/assets/recipe_placeholder.png',
                        fit: BoxFit.cover,
                        height: 220,
                        width: double.infinity,
                      );
                    },
                  )
                : Image.network( 
                    widget.food.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'lib/assets/recipe_placeholder.png',
                        fit: BoxFit.cover,
                        height: 220,
                        width: double.infinity,
                      );
                    },
                  ),
          ),

          const SizedBox(height: 8),

          // Ingredients Section
          ExpansionTile(
            title: Text(
              "Ingredients",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            initiallyExpanded: true,
            subtitle: const Text("Adjust servings below"),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: servingSize > 1
                        ? () => updateServingSize(servingSize - 1)
                        : null,
                  ),
                  Text(
                    '$servingSize Servings',
                    style: theme.textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => updateServingSize(servingSize + 1),
                  ),
                ],
              ),
              ...List.generate(
                widget.food.ingredients.length,
                (i) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    scaleIngredient(widget.food.ingredients[i], servingSize),
                  ),
                  value: ingredientChecked[i],
                  onChanged: (val) =>
                      setState(() => ingredientChecked[i] = val!),
                ),
              ),
            ],
          ),

          // Directions Section
          ExpansionTile(
            title: Text(
              "Directions",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            children: List.generate(
              widget.food.steps.length,
              (i) => ListTile(
                leading: CircleAvatar(child: Text("${i + 1}")),
                title: Text(widget.food.steps[i]),
              ),
          ),
        ),

        /// COOK MODE BUTTON SECTION
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: cookingMode
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.cardColor,
            child: ListTile(
              leading: Icon(
                Icons.lightbulb,
                color: cookingMode
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
              ),
              title: const Text("Cook Mode"),
              subtitle: const Text("Screen will stay on while cooking."),
              trailing: Switch(
                value: cookingMode,
                onChanged: (_) => toggleCookingMode(),
              ),
              onTap: toggleCookingMode,
            ),
          ),
        ),
      ],
    ),
      // COOK MODE BUTTON SECTION
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 40,
                    color: cookingMode
                        ? theme.colorScheme.primary
                        : theme.iconTheme.color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Cook Mode",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Screen will stay on while cooking."),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    value: cookingMode,
                    onChanged: (val) {
                      Navigator.pop(context);
                      toggleCookingMode();
                    },
                    title: Text(cookingMode ? "Turn Off" : "Turn On"),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.restaurant_menu,
          color: Colors.white,
          size: 36,
        ), // Use a chef hat icon if you have one
      ),
    );
  }
}
