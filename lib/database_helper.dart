import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'history_model.dart';

class DatabaseHelper {
  static const _databaseName = "calculatorHistory.db";
  static const _databaseVersion = 1;

  static const table = "history";

  static const columnId = "id";
  static const columnExpression = "expression";
  static const columnResult = "result";
  static const columnTimestamp = "timestamp";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnExpression TEXT NOT NULL,
            $columnResult TEXT NOT NULL,
            $columnTimestamp TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertHistory(HistoryItem item) async {
    Database db = await database;
    return await db.insert(table, item.toMap());
  }

  Future<List<HistoryItem>> queryAllHistory() async {
    Database db = await database;
    var res = await db.query(table);
    List<HistoryItem> list =
        res.isNotEmpty ? res.map((c) => HistoryItem.fromMap(c)).toList() : [];
    return list;
  }

  // You can also add delete, update methods here as per your requirements
}
