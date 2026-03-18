import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "storage.db";

  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Map<int, String> migrationScripts = {
    1: '''CREATE TABLE House(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );

          CREATE TABLE Room(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            house INTEGER,
            FOREIGN KEY (house) REFERENCES House (id) ON DELETE CASCADE
          );

          CREATE TABLE Furniture(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            room INTEGER,
            FOREIGN KEY (room) REFERENCES Room (id) ON DELETE CASCADE
          );

          CREATE TABLE Shelf(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            furniture INTEGER,
            FOREIGN KEY (furniture) REFERENCES Furniture (id) ON DELETE CASCADE
          );

          CREATE TABLE Item(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            shelf INTEGER,
            FOREIGN KEY (shelf) REFERENCES Shelf (id) ON DELETE CASCADE
          );
              ''',
    2: '''
      ALTER TABLE Item ADD COLUMN taken INTEGER NOT NULL DEFAULT 0;

      CREATE TABLE Trip(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        selected INTEGER NOT NULL DEFAULT 0
      );

      CREATE TABLE TripItem(
        tripId INTEGER NOT NULL,
        itemId INTEGER NOT NULL,
        PRIMARY KEY (tripId, itemId),
        FOREIGN KEY (tripId) REFERENCES Trip (id) ON DELETE CASCADE,
        FOREIGN KEY (itemId) REFERENCES Item (id) ON DELETE CASCADE
      );
    ''',
  };

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    int databaseVersion = migrationScripts.length;

    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: (Database db, int version) async {
        for (int i = 1; i <= databaseVersion; i++) {
          await db.execute(migrationScripts[i]!);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          await db.execute(migrationScripts[i]!);
        }
      },
    );
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table, orderBy: 'name ASC');
  }

  Future<int> update(String table, Map<String, dynamic> values, int id) async {
    final db = await database;
    return await db.update(table, values, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
