// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FoodDao? _foodDaoInstance;

  LikedRecipeDao? _likedRecipeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `foods` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `categories` TEXT NOT NULL, `ingredients` TEXT NOT NULL, `steps` TEXT NOT NULL, `duration` INTEGER NOT NULL, `calories` INTEGER NOT NULL, `complexity` TEXT NOT NULL, `affordability` TEXT NOT NULL, `isGlutenFree` INTEGER NOT NULL, `isLactoseFree` INTEGER NOT NULL, `isVegan` INTEGER NOT NULL, `isVegetarian` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `liked_recipes` (`recipeId` TEXT NOT NULL, PRIMARY KEY (`recipeId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FoodDao get foodDao {
    return _foodDaoInstance ??= _$FoodDao(database, changeListener);
  }

  @override
  LikedRecipeDao get likedRecipeDao {
    return _likedRecipeDaoInstance ??=
        _$LikedRecipeDao(database, changeListener);
  }
}

class _$FoodDao extends FoodDao {
  _$FoodDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _foodEntityInsertionAdapter = InsertionAdapter(
            database,
            'foods',
            (FoodEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'imageUrl': item.imageUrl,
                  'categories': item.categories,
                  'ingredients': item.ingredients,
                  'steps': item.steps,
                  'duration': item.duration,
                  'calories': item.calories,
                  'complexity': item.complexity,
                  'affordability': item.affordability,
                  'isGlutenFree': item.isGlutenFree ? 1 : 0,
                  'isLactoseFree': item.isLactoseFree ? 1 : 0,
                  'isVegan': item.isVegan ? 1 : 0,
                  'isVegetarian': item.isVegetarian ? 1 : 0
                }),
        _foodEntityUpdateAdapter = UpdateAdapter(
            database,
            'foods',
            ['id'],
            (FoodEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'imageUrl': item.imageUrl,
                  'categories': item.categories,
                  'ingredients': item.ingredients,
                  'steps': item.steps,
                  'duration': item.duration,
                  'calories': item.calories,
                  'complexity': item.complexity,
                  'affordability': item.affordability,
                  'isGlutenFree': item.isGlutenFree ? 1 : 0,
                  'isLactoseFree': item.isLactoseFree ? 1 : 0,
                  'isVegan': item.isVegan ? 1 : 0,
                  'isVegetarian': item.isVegetarian ? 1 : 0
                }),
        _foodEntityDeletionAdapter = DeletionAdapter(
            database,
            'foods',
            ['id'],
            (FoodEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'imageUrl': item.imageUrl,
                  'categories': item.categories,
                  'ingredients': item.ingredients,
                  'steps': item.steps,
                  'duration': item.duration,
                  'calories': item.calories,
                  'complexity': item.complexity,
                  'affordability': item.affordability,
                  'isGlutenFree': item.isGlutenFree ? 1 : 0,
                  'isLactoseFree': item.isLactoseFree ? 1 : 0,
                  'isVegan': item.isVegan ? 1 : 0,
                  'isVegetarian': item.isVegetarian ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FoodEntity> _foodEntityInsertionAdapter;

  final UpdateAdapter<FoodEntity> _foodEntityUpdateAdapter;

  final DeletionAdapter<FoodEntity> _foodEntityDeletionAdapter;

  @override
  Future<List<FoodEntity>> findAllFoods() async {
    return _queryAdapter.queryList('SELECT * FROM foods',
        mapper: (Map<String, Object?> row) => FoodEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            imageUrl: row['imageUrl'] as String,
            categories: row['categories'] as String,
            ingredients: row['ingredients'] as String,
            steps: row['steps'] as String,
            duration: row['duration'] as int,
            calories: row['calories'] as int,
            complexity: row['complexity'] as String,
            affordability: row['affordability'] as String,
            isGlutenFree: (row['isGlutenFree'] as int) != 0,
            isLactoseFree: (row['isLactoseFree'] as int) != 0,
            isVegan: (row['isVegan'] as int) != 0,
            isVegetarian: (row['isVegetarian'] as int) != 0));
  }

  @override
  Future<FoodEntity?> findFoodById(String id) async {
    return _queryAdapter.query('SELECT * FROM foods WHERE id = ?1',
        mapper: (Map<String, Object?> row) => FoodEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            imageUrl: row['imageUrl'] as String,
            categories: row['categories'] as String,
            ingredients: row['ingredients'] as String,
            steps: row['steps'] as String,
            duration: row['duration'] as int,
            calories: row['calories'] as int,
            complexity: row['complexity'] as String,
            affordability: row['affordability'] as String,
            isGlutenFree: (row['isGlutenFree'] as int) != 0,
            isLactoseFree: (row['isLactoseFree'] as int) != 0,
            isVegan: (row['isVegan'] as int) != 0,
            isVegetarian: (row['isVegetarian'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> insertFood(FoodEntity food) async {
    await _foodEntityInsertionAdapter.insert(food, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFood(FoodEntity food) async {
    await _foodEntityUpdateAdapter.update(food, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFood(FoodEntity food) async {
    await _foodEntityDeletionAdapter.delete(food);
  }
}

class _$LikedRecipeDao extends LikedRecipeDao {
  _$LikedRecipeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _likedRecipeEntityInsertionAdapter = InsertionAdapter(
            database,
            'liked_recipes',
            (LikedRecipeEntity item) =>
                <String, Object?>{'recipeId': item.recipeId}),
        _likedRecipeEntityDeletionAdapter = DeletionAdapter(
            database,
            'liked_recipes',
            ['recipeId'],
            (LikedRecipeEntity item) =>
                <String, Object?>{'recipeId': item.recipeId});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LikedRecipeEntity> _likedRecipeEntityInsertionAdapter;

  final DeletionAdapter<LikedRecipeEntity> _likedRecipeEntityDeletionAdapter;

  @override
  Future<List<LikedRecipeEntity>> getAllLiked() async {
    return _queryAdapter.queryList('SELECT * FROM liked_recipes',
        mapper: (Map<String, Object?> row) =>
            LikedRecipeEntity(recipeId: row['recipeId'] as String));
  }

  @override
  Future<LikedRecipeEntity?> findByRecipeId(String recipeId) async {
    return _queryAdapter.query(
        'SELECT * FROM liked_recipes WHERE recipeId = ?1',
        mapper: (Map<String, Object?> row) =>
            LikedRecipeEntity(recipeId: row['recipeId'] as String),
        arguments: [recipeId]);
  }

  @override
  Future<void> likeRecipe(LikedRecipeEntity entity) async {
    await _likedRecipeEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> unlikeRecipe(LikedRecipeEntity entity) async {
    await _likedRecipeEntityDeletionAdapter.delete(entity);
  }
}
