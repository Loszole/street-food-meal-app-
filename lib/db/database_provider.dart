import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'app_database.dart';

class DatabaseProvider {
  static AppDatabase? _database;

  static Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'recipes.db');
    _database = await $FloorAppDatabase.databaseBuilder(path).build();
    return _database!;
  }
}
