import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton service for managing SQLite database connections.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  /// Retrieves the existing database instance or initializes it if null.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database at the default location.
  ///
  /// Returns the open [Database] instance.
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'internet_manager.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Creates the database tables when the database is first created.
  ///
  /// [db] The database instance.
  /// [version] The schema version.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        remainingBalance REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE usage(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        weeklyUsage REAL NOT NULL,
        amountPaid REAL NOT NULL,
        recordDate TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY,
        gigabytePrice REAL NOT NULL
      )
    ''');
  }
}
