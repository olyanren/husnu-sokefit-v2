import 'package:sokefit/models/image_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  Future<Database> getDatabase() async {
    return openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'crossfit.db'),

      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY,name TEXT,image TEXT, "
          "phone TEXT, email TEXT, password TEXT,access_token TEXT,package_id INT,remaining_day INT,date_paid TEXT,finish_date TEXT,role TEXT,location_id INT)",
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        db.execute(
          "DROP TABLE users",
        );
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY,name TEXT,image TEXT, "
              "phone TEXT, email TEXT, password TEXT,access_token TEXT,package_id INT,remaining_day INT,date_paid TEXT,finish_date TEXT,role TEXT,location_id INT)",
        );
      },
      version: 8,
    );
  }

  // Define a function that inserts dogs into the database
  Future<bool> saveOrUpdateUser(UserModel userModel) async {
    var existingUser = await getUser(userModel.id);
    if (existingUser != null) userModel.id = existingUser.id;
    final Database db = await getDatabase();
    var result = await db.insert(
      'users',
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result >= 1;
  }

  Future<void> saveOrUpdateImages(List<ImageModel> imageModels) async {
    // Get a reference to the database.
    final Database db = await getDatabase();
    Batch batch = db.batch();
    for (var imageModel in imageModels) {
      batch.insert('images', imageModel.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<UserModel> getUser(int id) async {
    // Get a reference to the database.
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query('users', where: 'id=?', whereArgs: [id]);
    if (maps.length == 0) return null;
    return UserModel.fromJson(maps[0]);
  }

  Future<UserModel> user() async {
    // Get a reference to the database.
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users');
    if (maps.length == 0) return UserModel();
    return UserModel.fromJson(maps[0]);
  }

  Future<List<UserModel>> users() async {
    // Get a reference to the database.
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromJson(maps[i]);
    });
  }

  Future<bool> removeFromUsers(UserModel userModel) async {
    // Get a reference to the database.
    final Database db = await getDatabase();

    // In this case, replace any previous data.
    var result =
        await db.delete('users', where: "id=?", whereArgs: [userModel.id]);
    return result >= 1;
  }

  Future<bool> removeAll() async {
    final Database db = await getDatabase();
    var result = await db.delete('users');
    return result >= 1;
  }
}
