import 'package:flutter/material.dart';
import '../utils/food_search_utils.dart';

class FoodFilterButton extends StatelessWidget {
  final Set<FoodFilter> activeFilters;
  final ValueChanged<Set<FoodFilter>> onChanged;

  const FoodFilterButton({
    super.key,
    required this.activeFilters,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filter',
      onPressed: () async {
        final result = await showModalBottomSheet<Set<FoodFilter>>(
          context: context,
          builder: (context) {
            Set<FoodFilter> tempFilters = Set.from(activeFilters);
            return StatefulBuilder(
              builder: (context, setModalState) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: const Text('Vegetarian'),
                      value: tempFilters.contains(FoodFilter.vegetarian),
                      onChanged: (val) => setModalState(() {
                        val!
                            ? tempFilters.add(FoodFilter.vegetarian)
                            : tempFilters.remove(FoodFilter.vegetarian);
                      }),
                    ),
                    CheckboxListTile(
                      title: const Text('Vegan'),
                      value: tempFilters.contains(FoodFilter.vegan),
                      onChanged: (val) => setModalState(() {
                        val!
                            ? tempFilters.add(FoodFilter.vegan)
                            : tempFilters.remove(FoodFilter.vegan);
                      }),
                    ),
                    CheckboxListTile(
                      title: const Text('Lactose Free'),
                      value: tempFilters.contains(FoodFilter.lactoseFree),
                      onChanged: (val) => setModalState(() {
                        val!
                            ? tempFilters.add(FoodFilter.lactoseFree)
                            : tempFilters.remove(FoodFilter.lactoseFree);
                      }),
                    ),
                    CheckboxListTile(
                      title: const Text('Gluten Free'),
                      value: tempFilters.contains(FoodFilter.glutenFree),
                      onChanged: (val) => setModalState(() {
                        val!
                            ? tempFilters.add(FoodFilter.glutenFree)
                            : tempFilters.remove(FoodFilter.glutenFree);
                      }),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, tempFilters),
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        if (result != null) {
          onChanged(result);
        }
      },
    );
  }
}