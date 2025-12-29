import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';


import '../data/dummy_data.dart';
import '../models/foods.dart';
import '../utils/recipe_form_logic.dart';
import 'food_details.dart';
import '../db/database_provider.dart';
// import '../db/food_entity.dart';
import '../utils/food_entity_factory.dart';

class AddRecipeScreen extends StatefulWidget {
  final Food? foodToEdit;
  const AddRecipeScreen({super.key, this.foodToEdit});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _stepController = TextEditingController();
  late RecipeFormLogic logic;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    logic = RecipeFormLogic(foodToEdit: widget.foodToEdit);
    _nameController.text = logic.name;
    _imageUrlController.text = logic.imageUrl;
    _durationController.text = logic.duration > 0 ? logic.duration.toString() : '';
    _caloriesController.text = logic.calories > 0 ? logic.calories.toString() : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _ingredientController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        logic.imageUrl = pickedFile.path;
        _imageUrlController.clear(); // Clear URL if image picked
      });
    }
  }

  Future<void> _validateAndSave() async {
    logic.name = _nameController.text;
    logic.imageUrl = _imageUrlController.text;
    logic.duration = int.tryParse(_durationController.text) ?? 0;
    logic.calories = int.tryParse(_caloriesController.text) ?? 0;
    logic.processIngredients(_ingredientController.text);
    logic.processSteps(_stepController.text);
    _ingredientController.clear();
    _stepController.clear();
    logic.validate();
    setState(() {});
    // Check for errors and show SnackBar if any
    String? errorMsg;
    if (!_formKey.currentState!.validate()) {
      errorMsg = 'Please fill all required fields.';
    } else if (logic.categoryError != null) {
      errorMsg = logic.categoryError;
    } else if (logic.ingredientsError != null) {
      errorMsg = logic.ingredientsError;
    } else if (logic.stepsError != null) {
      errorMsg = logic.stepsError;
    }
    if (errorMsg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
      return;
    }


    // --- USER ADDED FOOD STORAGE LOGIC (Floor DB) ---
    Food savedFood;
    if (widget.foodToEdit == null) {
      // New recipe
      final newFood = Food(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        categories: List<String>.from(logic.selectedCategories),
        title: logic.name,
        imageUrl: _pickedImage != null ? _pickedImage!.path : logic.imageUrl,
        ingredients: List<String>.from(logic.ingredients),
        steps: List<String>.from(logic.steps),
        duration: logic.duration,
        calories: logic.calories,
        complexity: Complexity.values.firstWhere((c) => c.name == logic.complexity),
        affordability: Affordability.values.firstWhere((a) => a.name == logic.affordability),
        isGlutenFree: logic.isGlutenFree,
        isLactoseFree: logic.isLactoseFree,
        isVegan: logic.isVegan,
        isVegetarian: logic.isVegetarian,
      );
      final db = await DatabaseProvider.database;
      await db.foodDao.insertFood(foodToEntity(newFood));
      savedFood = newFood;
    } else {
      // Edit existing recipe
      final updatedFood = Food(
        id: widget.foodToEdit!.id,
        categories: List<String>.from(logic.selectedCategories),
        title: logic.name,
        imageUrl: _pickedImage != null ? _pickedImage!.path : logic.imageUrl,
        ingredients: List<String>.from(logic.ingredients),
        steps: List<String>.from(logic.steps),
        duration: logic.duration,
        calories: logic.calories,
        complexity: Complexity.values.firstWhere((c) => c.name == logic.complexity),
        affordability: Affordability.values.firstWhere((a) => a.name == logic.affordability),
        isGlutenFree: logic.isGlutenFree,
        isLactoseFree: logic.isLactoseFree,
        isVegan: logic.isVegan,
        isVegetarian: logic.isVegetarian,
      );
      final db = await DatabaseProvider.database;
      await db.foodDao.updateFood(foodToEntity(updatedFood));
      savedFood = updatedFood;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.foodToEdit == null ? 'Recipe added!' : 'Recipe updated!')),
    );

    // --- RESET FORM FIELDS ---
    void clearForm() {
      _nameController.clear();
      _imageUrlController.clear();
      _durationController.clear();
      _caloriesController.clear();
      _ingredientController.clear();
      _stepController.clear();
      setState(() {
        _pickedImage = null;
        logic.selectedCategories.clear();
        logic.ingredients.clear();
        logic.steps.clear();
        logic.name = '';
        logic.imageUrl = '';
        logic.duration = 0;
        logic.calories = 0;
      });
    }
    clearForm();

    // 1. If we are EDITING, we want to pop the edit screen first
    if (widget.foodToEdit != null) {
      if (!mounted) return;
      Navigator.of(context).pop(); 
    }

    // 2. Push the details screen normally (this adds it to the stack)
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FoodDetailsScreen(food: savedFood),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.foodToEdit == null ? 'Add Recipe' : 'Edit Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- IMAGE PICKER SECTION ---
              // --- IMAGE PICKER SECTION ---
              if (_pickedImage != null)
                Image.file(_pickedImage!, height: 150),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
                onPressed: _imageUrlController.text.isEmpty ? _pickImage : null,
              ),
              const SizedBox(height: 10),
              // --- BASIC INFO SECTION ---
              // Food name input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Food Name'),
                onChanged: (val) => logic.name = val,
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 10),

              // --- CATEGORY SELECTION SECTION ---
              // Category selection (multi-select)
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 6,
                  children: dummyCategories.map((cat) {
                    final isSelected = logic.selectedCategories.contains(cat.id);
                    return FilterChip(
                      label: Text(cat.title),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            logic.selectedCategories.add(cat.id);
                          } else {
                            logic.selectedCategories.remove(cat.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              if (logic.categoryError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      logic.categoryError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // --- IMAGE URL SECTION ---
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                onChanged: (val) {
                  logic.imageUrl = val;
                  if (val.isNotEmpty && _pickedImage != null) {
                    setState(() {
                      _pickedImage = null;
                    });
                  }
                  setState(() {});
                },
                enabled: _pickedImage == null,
              ),
              const SizedBox(height: 10),

              // --- INGREDIENTS SECTION ---
              // Ingredients input
              TextFormField(
                controller: _ingredientController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Add Ingredients (one per line)',
                  hintText: 'Carrots\nOnions\nCelery',
                ),
                onFieldSubmitted: (val) {
                  final lines = val.split('\n');
                  setState(() {
                    for (var line in lines) {
                      final trimmed = line.trim();
                      if (trimmed.isNotEmpty) {
                        logic.ingredients.add(trimmed);
                      }
                    }
                    _ingredientController.clear();
                  });
                },
              ),
              Wrap(
                spacing: 6,
                children: logic.ingredients
                    .map(
                      (ing) => Chip(
                        label: Text(ing),
                        onDeleted: () {
                          setState(() {
                            logic.ingredients.remove(ing);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              if (logic.ingredientsError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      logic.ingredientsError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // --- STEPS SECTION ---
              // Steps input (multi-line, like ingredients)
              TextFormField(
                controller: _stepController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Add Steps (one per line)',
                  hintText: 'Chop onions\nHeat oil\nAdd spices',
                ),
                onFieldSubmitted: (val) {
                  final lines = val.split('\n');
                  setState(() {
                    for (var line in lines) {
                      final trimmed = line.trim();
                      if (trimmed.isNotEmpty) {
                        logic.steps.add(trimmed);
                      }
                    }
                    _stepController.clear();
                  });
                },
              ),
              Wrap(
                spacing: 6,
                children: logic.steps
                    .map(
                      (step) => Chip(
                        label: Text(step),
                        onDeleted: () {
                          setState(() {
                            logic.steps.remove(step);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              if (logic.stepsError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      logic.stepsError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // --- META INFO SECTION ---
              // Duration input
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => logic.duration = int.tryParse(val) ?? 0,
              ),
              const SizedBox(height: 10),
              // Calories input
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                onChanged: (val) => logic.calories = int.tryParse(val) ?? 0,
              ),
              const SizedBox(height: 10),
              // Complexity dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Complexity'),
                initialValue: logic.complexity,
                items: ['simple', 'challenging', 'hard']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => logic.complexity = val!),
              ),
              const SizedBox(height: 10),
              // Affordability dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Affordability'),
                initialValue: logic.affordability,
                items: ['affordable', 'pricey', 'luxurious']
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (val) => setState(() => logic.affordability = val!),
              ),

              // --- DIETARY INFO SECTION ---
              SwitchListTile(
                title: const Text('Gluten Free'),
                value: logic.isGlutenFree,
                onChanged: (val) => setState(() => logic.isGlutenFree = val),
              ),
              SwitchListTile(
                title: const Text('Lactose Free'),
                value: logic.isLactoseFree,
                onChanged: (val) => setState(() => logic.isLactoseFree = val),
              ),
              SwitchListTile(
                title: const Text('Vegan'),
                value: logic.isVegan,
                onChanged: (val) => setState(() => logic.isVegan = val),
              ),
              SwitchListTile(
                title: const Text('Vegetarian'),
                value: logic.isVegetarian,
                onChanged: (val) => setState(() => logic.isVegetarian = val),
              ),

              // --- SUBMIT BUTTON SECTION ---
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateAndSave,
                child: Text(widget.foodToEdit == null ? 'Add Recipe' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
