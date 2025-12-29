import 'dart:async';
import 'package:floor/floor.dart';
import 'food_entity.dart';
import 'food_dao.dart';
import 'liked_recipe_entity.dart';
import 'liked_recipe_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [FoodEntity, LikedRecipeEntity])
abstract class AppDatabase extends FloorDatabase {
  FoodDao get foodDao;
  LikedRecipeDao get likedRecipeDao;
}
