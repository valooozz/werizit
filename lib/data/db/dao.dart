import 'database_helper.dart';
import '../models/house.dart';
import '../models/room.dart';
import '../models/furniture.dart';
import '../models/shelf.dart';
import '../models/item.dart';

class DAO {
  final dbHelper = DatabaseHelper.instance;

  // ---------- HOUSE ----------
  Future<int> insertHouse(House house) async =>
      await dbHelper.insert('House', house.toMap());

  Future<List<House>> getHouses() async {
    final maps = await dbHelper.queryAll('House');
    return maps.map((m) => House.fromMap(m)).toList();
  }

  // ---------- ROOM ----------
  Future<int> insertRoom(Room room) async =>
      await dbHelper.insert('Room', room.toMap());

  Future<List<Room>> getRoomsByHouse(int houseId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Room',
      where: 'house = ?',
      whereArgs: [houseId],
    );
    return maps.map((m) => Room.fromMap(m)).toList();
  }

  // ---------- FURNITURE ----------
  Future<int> insertFurniture(Furniture f) async =>
      await dbHelper.insert('Furniture', f.toMap());

  Future<List<Furniture>> getFurnitureByRoom(int roomId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Furniture',
      where: 'room = ?',
      whereArgs: [roomId],
    );
    return maps.map((m) => Furniture.fromMap(m)).toList();
  }

  // ---------- SHELF ----------
  Future<int> insertShelf(Shelf shelf) async =>
      await dbHelper.insert('Shelf', shelf.toMap());

  Future<List<Shelf>> getShelvesByFurniture(int furnitureId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Shelf',
      where: 'furniture = ?',
      whereArgs: [furnitureId],
    );
    return maps.map((m) => Shelf.fromMap(m)).toList();
  }

  // ---------- ITEM ----------
  Future<int> insertItem(Item obj) async =>
      await dbHelper.insert('ObjectItem', obj.toMap());

  Future<List<Item>> getItemsByShelf(int shelfId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Item',
      where: 'shelf = ?',
      whereArgs: [shelfId],
    );
    return maps.map((m) => Item.fromMap(m)).toList();
  }
}
