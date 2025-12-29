import 'package:flutter/material.dart';
import '../utils/food_search_utils.dart';
import 'food_filter_button.dart';
import '../models/foods.dart';

/// A search bar widget that manages its own search query and filtering logic.
/// It takes a list of items and a filter function, and exposes filtered results via a callback.
class SearchBarWidget<T> extends StatefulWidget {
  final List<T> items;
  final List<T> Function(List<T> items, String query)? filter;
  final void Function(List<T> results)? onResults;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.items,
    this.filter,
    this.onResults,
    this.hintText = 'Search...',
  });

  @override
  State<SearchBarWidget<T>> createState() => _SearchBarWidgetState<T>();
}

class _SearchBarWidgetState<T> extends State<SearchBarWidget<T>> {
  String _query = '';
  Set<FoodFilter> _activeFilters = {};
  List<T> _results = [];

  @override
  void initState() {
    super.initState();
    _results = widget.items;
  }

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      _applySearchAndFilters();
    });
  }

  void _onFiltersChanged(Set<FoodFilter> filters) {
    setState(() {
      _activeFilters = filters;
      _applySearchAndFilters();
    });
  }

  void _applySearchAndFilters() {
    List<T> filtered = widget.filter != null
        ? widget.filter!(widget.items, _query)
        : widget.items;
    // If T is Food, apply food filters
    if (T == Food && _activeFilters.isNotEmpty) {
      filtered = applyFoodFilters(filtered.cast<Food>(), _activeFilters).cast<T>();
    }
    _results = filtered;
    widget.onResults?.call(_results);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: _onQueryChanged,
          ),
        ),
        if (T == Food)
          FoodFilterButton(
            activeFilters: _activeFilters,
            onChanged: _onFiltersChanged,
          ),
      ],
    );
  }
}
