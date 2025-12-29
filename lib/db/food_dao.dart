import 'package:floor/floor.dart';
import 'food_entity.dart';

@dao
abstract class FoodDao {
  @Query('SELECT * FROM foods')
  Future<List<FoodEntity>> findAllFoods();

  @Query('SELECT * FROM foods WHERE id = :id')
  Future<FoodEntity?> findFoodById(String id);

  @insert
  Future<void> insertFood(FoodEntity food);

  @update
  Future<void> updateFood(FoodEntity food);

  @delete
  Future<void> deleteFood(FoodEntity food);
}
