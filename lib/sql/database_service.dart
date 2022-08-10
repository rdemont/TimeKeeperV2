import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timekeeperv2/sql/working_slot_db.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  // When the database is first created, create a table to store breeds
// and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${WorkingSlotDB.TABLE_WORKING_SLOT} (
            ${WorkingSlotDB.COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${WorkingSlotDB.COL_DATE} TEXT NOT NULL,
            ${WorkingSlotDB.COL_STARTTIME} TEXT NOT NULL,
            ${WorkingSlotDB.COL_ENDTIME} TEXT NULL,
            ${WorkingSlotDB.COL_DESCRIPTION} TEXT NULL
          )
          ''');
  }
}
